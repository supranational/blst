// Copyright Supranational LLC
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

use core::num::Wrapping;
use core::ops::{Index, IndexMut};
use core::slice::SliceIndex;

struct tile {
    x: usize,
    dx: usize,
    y: usize,
    dy: usize,
}

// Minimalist core::cell::Cell stand-in, but with Sync marker, which
// makes it possible to pass it to multiple threads. It works, because
// *here* each Cell is written only once and by just one thread.
#[repr(transparent)]
struct Cell<T: ?Sized> {
    value: T,
}
unsafe impl<T: ?Sized + Sync> Sync for Cell<T> {}
impl<T> Cell<T> {
    pub fn as_ptr(&self) -> *mut T {
        &self.value as *const T as *mut T
    }
}

macro_rules! pippenger_mult_impl {
    (
        $points:ident,
        $point:ty,
        $point_affine:ty,
        $to_affines:ident,
        $scratch_sizeof:ident,
        $multi_scalar_mult:ident,
        $tile_mult:ident,
        $add_or_double:ident,
        $double:ident,
        $test_mod:ident,
        $generator:ident,
        $mult:ident,
        $add:ident,
    ) => {
        pub struct $points {
            points: Vec<$point_affine>,
        }

        impl<I: SliceIndex<[$point_affine]>> Index<I> for $points {
            type Output = I::Output;

            #[inline]
            fn index(&self, i: I) -> &Self::Output {
                &self.points[i]
            }
        }
        impl<I: SliceIndex<[$point_affine]>> IndexMut<I> for $points {
            #[inline]
            fn index_mut(&mut self, i: I) -> &mut Self::Output {
                &mut self.points[i]
            }
        }

        impl $points {
            #[inline]
            pub fn as_slice(&self) -> &[$point_affine] {
                self.points.as_slice()
            }

            pub fn from(points: &[$point]) -> Self {
                let npoints = points.len();
                let mut ret = Self {
                    points: Vec::with_capacity(npoints),
                };

                let ncpus = rayon::current_num_threads();
                if ncpus < 2 || npoints < 768 {
                    let p = [points.as_ptr(), ptr::null()];
                    unsafe {
                        $to_affines(
                            ret.points.as_mut_ptr(),
                            p.as_ptr(),
                            ret.points.capacity(),
                        );
                        ret.points.set_len(ret.points.capacity());
                    };
                    return ret;
                }

                let mut nslices = (npoints + 511) / 512;
                nslices = core::cmp::min(nslices, ncpus);

                // TODO: Use pointer arithmetic once Rust 1.75 can be used
                #[allow(clippy::uninit_vec)]
                unsafe {
                    ret.points.set_len(ret.points.capacity());
                }
                let (mut delta, mut rem) =
                    (npoints / nslices + 1, Wrapping(npoints % nslices));
                rayon::scope(|scope| {
                    let mut ret_points = ret.points.as_mut_slice();
                    let mut points = points;
                    while !points.is_empty() {
                        if rem == Wrapping(0) {
                            delta -= 1;
                        }
                        rem -= Wrapping(1);

                        let out;
                        (out, ret_points) = ret_points.split_at_mut(delta);
                        let inp;
                        (inp, points) = points.split_at(delta);

                        scope.spawn(move |_scope| {
                            let p = [inp.as_ptr(), ptr::null()];
                            unsafe {
                                $to_affines(out.as_mut_ptr(), p.as_ptr(), delta)
                            };
                        });
                    }
                });

                ret
            }

            pub fn mult(&self, scalars: &[u8], nbits: usize) -> $point {
                let npoints = self.points.len();
                let nbytes = (nbits + 7) / 8;

                if scalars.len() < nbytes * npoints {
                    panic!("scalars length mismatch");
                }

                let ncpus = rayon::current_num_threads();
                if ncpus < 2 || npoints < 32 {
                    let p = [self.points.as_ptr(), ptr::null()];
                    let s = [scalars.as_ptr(), ptr::null()];

                    let mut ret = <$point>::default();
                    unsafe {
                        let mut scratch: Vec<u64> =
                            Vec::with_capacity($scratch_sizeof(npoints) / 8);

                        $multi_scalar_mult(
                            &mut ret,
                            p.as_ptr(),
                            npoints,
                            s.as_ptr(),
                            nbits,
                            scratch.as_mut_ptr(),
                        );
                    }
                    return ret;
                }

                let (nx, ny, window) =
                    breakdown(nbits, pippenger_window_size(npoints), ncpus);

                // |grid[]| holds "coordinates" and place for result
                let mut grid =
                    Vec::<(tile, Cell<$point>)>::with_capacity(nx * ny);
                // TODO: Use pointer arithmetic once Rust 1.75 can be used
                #[allow(clippy::uninit_vec)]
                unsafe {
                    grid.set_len(grid.capacity());
                }
                let dx = npoints / nx;
                let mut y = window * (ny - 1);
                let mut total = 0usize;

                while total < nx {
                    grid[total].0.x = total * dx;
                    grid[total].0.dx = dx;
                    grid[total].0.y = y;
                    grid[total].0.dy = nbits - y;
                    total += 1;
                }
                grid[total - 1].0.dx = npoints - grid[total - 1].0.x;
                while y != 0 {
                    y -= window;
                    for i in 0..nx {
                        grid[total].0.x = grid[i].0.x;
                        grid[total].0.dx = grid[i].0.dx;
                        grid[total].0.y = y;
                        grid[total].0.dy = window;
                        total += 1;
                    }
                }
                let grid = &grid[..];

                let points = &self.points[..];
                let sz = unsafe { $scratch_sizeof(0) / 8 };

                let mut row_sync = Vec::with_capacity(ny);
                row_sync.resize_with(ny, AtomicUsize::default);
                let counter = AtomicUsize::new(0);
                let (tx, rx) = channel();
                rayon::scope(|scope| {
                    scope.spawn_broadcast(move |_scope, _ctx| {
                        let mut scratch = vec![0u64; sz << (window - 1)];
                        let mut p = [ptr::null(), ptr::null()];
                        let mut s = [ptr::null(), ptr::null()];

                        loop {
                            let work = counter.fetch_add(1, Ordering::Relaxed);
                            if work >= total {
                                break;
                            }
                            let x = grid[work].0.x;
                            let y = grid[work].0.y;

                            p[0] = &points[x];
                            s[0] = &scalars[x * nbytes];
                            unsafe {
                                $tile_mult(
                                    grid[work].1.as_ptr(),
                                    p.as_ptr(),
                                    grid[work].0.dx,
                                    s.as_ptr(),
                                    nbits,
                                    scratch.as_mut_ptr(),
                                    y,
                                    window,
                                );
                            }
                            if row_sync[y / window]
                                .fetch_add(1, Ordering::AcqRel)
                                == nx - 1
                            {
                                tx.send(y).expect("disaster");
                            }
                        }
                    });
                });

                let mut ret = <$point>::default();
                let mut rows = vec![false; ny];
                let mut row = 0usize;
                for _ in 0..ny {
                    let mut y = rx.recv().unwrap();
                    rows[y / window] = true;
                    while grid[row].0.y == y {
                        while row < total && grid[row].0.y == y {
                            unsafe {
                                $add_or_double(
                                    &mut ret,
                                    &ret,
                                    grid[row].1.as_ptr(),
                                );
                            }
                            row += 1;
                        }
                        if y == 0 {
                            break;
                        }
                        for _ in 0..window {
                            unsafe { $double(&mut ret, &ret) };
                        }
                        y -= window;
                        if !rows[y / window] {
                            break;
                        }
                    }
                }
                ret
            }

            pub fn add(&self) -> $point {
                let npoints = self.points.len();

                let ncpus = rayon::current_num_threads();
                if ncpus < 2 || npoints < 384 {
                    let p = [self.points.as_ptr(), ptr::null()];
                    let mut ret = <$point>::default();
                    unsafe { $add(&mut ret, p.as_ptr(), npoints) };
                    return ret;
                }

                let ret = Mutex::new(None::<$point>);
                let counter = AtomicUsize::new(0);
                let nchunks = (npoints + 255) / 256;
                let chunk = npoints / nchunks + 1;

                rayon::scope(|scope| {
                    let ret = &ret;
                    scope.spawn_broadcast(move |_scope, _ctx| {
                        let mut processed = 0;
                        let mut acc = <$point>::default();
                        let mut chunk = chunk;
                        let mut p = [ptr::null(), ptr::null()];

                        loop {
                            let work =
                                counter.fetch_add(chunk, Ordering::Relaxed);
                            if work >= npoints {
                                break;
                            }
                            p[0] = &self.points[work];
                            if work + chunk > npoints {
                                chunk = npoints - work;
                            }
                            unsafe {
                                let mut t = MaybeUninit::<$point>::uninit();
                                $add(t.as_mut_ptr(), p.as_ptr(), chunk);
                                $add_or_double(&mut acc, &acc, t.as_ptr());
                            };
                            processed += 1;
                        }
                        if processed > 0 {
                            let mut ret = ret.lock().unwrap();
                            match ret.as_mut() {
                                Some(ret) => {
                                    unsafe { $add_or_double(ret, ret, &acc) };
                                }
                                None => {
                                    ret.replace(acc);
                                }
                            }
                        }
                    })
                });

                let mut ret = ret.lock().unwrap();
                ret.take().unwrap()
            }
        }

        #[cfg(test)]
        pippenger_test_mod!(
            $test_mod,
            $points,
            $point,
            $add_or_double,
            $generator,
            $mult,
        );
    };
}

#[cfg(test)]
include!("pippenger-test_mod.rs");

pippenger_mult_impl!(
    p1_affines,
    blst_p1,
    blst_p1_affine,
    blst_p1s_to_affine,
    blst_p1s_mult_pippenger_scratch_sizeof,
    blst_p1s_mult_pippenger,
    blst_p1s_tile_pippenger,
    blst_p1_add_or_double,
    blst_p1_double,
    p1_multi_scalar,
    blst_p1_generator,
    blst_p1_mult,
    blst_p1s_add,
);

pippenger_mult_impl!(
    p2_affines,
    blst_p2,
    blst_p2_affine,
    blst_p2s_to_affine,
    blst_p2s_mult_pippenger_scratch_sizeof,
    blst_p2s_mult_pippenger,
    blst_p2s_tile_pippenger,
    blst_p2_add_or_double,
    blst_p2_double,
    p2_multi_scalar,
    blst_p2_generator,
    blst_p2_mult,
    blst_p2s_add,
);

fn num_bits(l: usize) -> usize {
    8 * core::mem::size_of_val(&l) - l.leading_zeros() as usize
}

fn breakdown(
    nbits: usize,
    window: usize,
    ncpus: usize,
) -> (usize, usize, usize) {
    let mut nx: usize;
    let mut wnd: usize;

    if nbits > window * ncpus {
        nx = 1;
        wnd = num_bits(ncpus / 4);
        if (window + wnd) > 18 {
            wnd = window - wnd;
        } else {
            wnd = (nbits / window + ncpus - 1) / ncpus;
            if (nbits / (window + 1) + ncpus - 1) / ncpus < wnd {
                wnd = window + 1;
            } else {
                wnd = window;
            }
        }
    } else {
        nx = 2;
        wnd = window - 2;
        while (nbits / wnd + 1) * nx < ncpus {
            nx += 1;
            wnd = window - num_bits(3 * nx / 2);
        }
        nx -= 1;
        wnd = window - num_bits(3 * nx / 2);
    }
    let ny = nbits / wnd + 1;
    wnd = nbits / ny + 1;

    (nx, ny, wnd)
}

fn pippenger_window_size(npoints: usize) -> usize {
    let wbits = num_bits(npoints);

    if wbits > 13 {
        return wbits - 4;
    }
    if wbits > 5 {
        return wbits - 3;
    }
    2
}
