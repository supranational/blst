// Copyright Supranational LLC
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

use core::ops::{Index, IndexMut};
use core::slice::SliceIndex;

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

                let p = [points.as_ptr(), ptr::null()];
                unsafe {
                    $to_affines(ret.points.as_mut_ptr(), p.as_ptr(), npoints);
                    ret.points.set_len(npoints);
                }
                ret
            }

            pub fn mult(&self, scalars: &[u8], nbits: usize) -> $point {
                let npoints = self.points.len();
                let nbytes = (nbits + 7) / 8;

                if scalars.len() < nbytes * npoints {
                    panic!("scalars length mismatch");
                }

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
                ret
            }

            pub fn add(&self) -> $point {
                let npoints = self.points.len();

                let p = [self.points.as_ptr(), ptr::null()];
                let mut ret = <$point>::default();
                unsafe { $add(&mut ret, p.as_ptr(), npoints) };

                ret
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
