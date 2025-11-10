// automatically generated with 'zig translate-c'
pub const BLST_SUCCESS: c_int = 0;
pub const BLST_BAD_ENCODING: c_int = 1;
pub const BLST_POINT_NOT_ON_CURVE: c_int = 2;
pub const BLST_POINT_NOT_IN_GROUP: c_int = 3;
pub const BLST_AGGR_TYPE_MISMATCH: c_int = 4;
pub const BLST_VERIFY_FAIL: c_int = 5;
pub const BLST_PK_IS_INFINITY: c_int = 6;
pub const BLST_BAD_SCALAR: c_int = 7;
pub const BLST_ERROR = c_uint;
pub const byte = u8;
pub const limb_t = u64;
pub const blst_scalar = extern struct {
    b: [32]byte = @import("std").mem.zeroes([32]byte),
};
pub const blst_fr = extern struct {
    l: [4]limb_t = @import("std").mem.zeroes([4]limb_t),
};
pub const blst_fp = extern struct {
    l: [6]limb_t = @import("std").mem.zeroes([6]limb_t),
};
pub const blst_fp2 = extern struct {
    fp: [2]blst_fp = @import("std").mem.zeroes([2]blst_fp),
};
pub const blst_fp6 = extern struct {
    fp2: [3]blst_fp2 = @import("std").mem.zeroes([3]blst_fp2),
};
pub const blst_fp12 = extern struct {
    fp6: [2]blst_fp6 = @import("std").mem.zeroes([2]blst_fp6),
};
pub extern fn blst_scalar_from_uint32(out: [*c]blst_scalar, a: [*c]const u32) void;
pub extern fn blst_uint32_from_scalar(out: [*c]u32, a: [*c]const blst_scalar) void;
pub extern fn blst_scalar_from_uint64(out: [*c]blst_scalar, a: [*c]const u64) void;
pub extern fn blst_uint64_from_scalar(out: [*c]u64, a: [*c]const blst_scalar) void;
pub extern fn blst_scalar_from_bendian(out: [*c]blst_scalar, a: [*c]const byte) void;
pub extern fn blst_bendian_from_scalar(out: [*c]byte, a: [*c]const blst_scalar) void;
pub extern fn blst_scalar_from_lendian(out: [*c]blst_scalar, a: [*c]const byte) void;
pub extern fn blst_lendian_from_scalar(out: [*c]byte, a: [*c]const blst_scalar) void;
pub extern fn blst_scalar_fr_check(a: [*c]const blst_scalar) bool;
pub extern fn blst_sk_check(a: [*c]const blst_scalar) bool;
pub extern fn blst_sk_add_n_check(out: [*c]blst_scalar, a: [*c]const blst_scalar, b: [*c]const blst_scalar) bool;
pub extern fn blst_sk_sub_n_check(out: [*c]blst_scalar, a: [*c]const blst_scalar, b: [*c]const blst_scalar) bool;
pub extern fn blst_sk_mul_n_check(out: [*c]blst_scalar, a: [*c]const blst_scalar, b: [*c]const blst_scalar) bool;
pub extern fn blst_sk_inverse(out: [*c]blst_scalar, a: [*c]const blst_scalar) void;
pub extern fn blst_scalar_from_le_bytes(out: [*c]blst_scalar, in: [*c]const byte, len: usize) bool;
pub extern fn blst_scalar_from_be_bytes(out: [*c]blst_scalar, in: [*c]const byte, len: usize) bool;
pub extern fn blst_fr_add(ret: [*c]blst_fr, a: [*c]const blst_fr, b: [*c]const blst_fr) void;
pub extern fn blst_fr_sub(ret: [*c]blst_fr, a: [*c]const blst_fr, b: [*c]const blst_fr) void;
pub extern fn blst_fr_mul_by_3(ret: [*c]blst_fr, a: [*c]const blst_fr) void;
pub extern fn blst_fr_lshift(ret: [*c]blst_fr, a: [*c]const blst_fr, count: usize) void;
pub extern fn blst_fr_rshift(ret: [*c]blst_fr, a: [*c]const blst_fr, count: usize) void;
pub extern fn blst_fr_mul(ret: [*c]blst_fr, a: [*c]const blst_fr, b: [*c]const blst_fr) void;
pub extern fn blst_fr_sqr(ret: [*c]blst_fr, a: [*c]const blst_fr) void;
pub extern fn blst_fr_cneg(ret: [*c]blst_fr, a: [*c]const blst_fr, flag: bool) void;
pub extern fn blst_fr_eucl_inverse(ret: [*c]blst_fr, a: [*c]const blst_fr) void;
pub extern fn blst_fr_inverse(ret: [*c]blst_fr, a: [*c]const blst_fr) void;
pub extern fn blst_fr_from_uint64(ret: [*c]blst_fr, a: [*c]const u64) void;
pub extern fn blst_uint64_from_fr(ret: [*c]u64, a: [*c]const blst_fr) void;
pub extern fn blst_fr_from_scalar(ret: [*c]blst_fr, a: [*c]const blst_scalar) void;
pub extern fn blst_scalar_from_fr(ret: [*c]blst_scalar, a: [*c]const blst_fr) void;
pub extern fn blst_fp_add(ret: [*c]blst_fp, a: [*c]const blst_fp, b: [*c]const blst_fp) void;
pub extern fn blst_fp_sub(ret: [*c]blst_fp, a: [*c]const blst_fp, b: [*c]const blst_fp) void;
pub extern fn blst_fp_mul_by_3(ret: [*c]blst_fp, a: [*c]const blst_fp) void;
pub extern fn blst_fp_mul_by_8(ret: [*c]blst_fp, a: [*c]const blst_fp) void;
pub extern fn blst_fp_lshift(ret: [*c]blst_fp, a: [*c]const blst_fp, count: usize) void;
pub extern fn blst_fp_mul(ret: [*c]blst_fp, a: [*c]const blst_fp, b: [*c]const blst_fp) void;
pub extern fn blst_fp_sqr(ret: [*c]blst_fp, a: [*c]const blst_fp) void;
pub extern fn blst_fp_cneg(ret: [*c]blst_fp, a: [*c]const blst_fp, flag: bool) void;
pub extern fn blst_fp_eucl_inverse(ret: [*c]blst_fp, a: [*c]const blst_fp) void;
pub extern fn blst_fp_inverse(ret: [*c]blst_fp, a: [*c]const blst_fp) void;
pub extern fn blst_fp_sqrt(ret: [*c]blst_fp, a: [*c]const blst_fp) bool;
pub extern fn blst_fp_from_uint32(ret: [*c]blst_fp, a: [*c]const u32) void;
pub extern fn blst_uint32_from_fp(ret: [*c]u32, a: [*c]const blst_fp) void;
pub extern fn blst_fp_from_uint64(ret: [*c]blst_fp, a: [*c]const u64) void;
pub extern fn blst_uint64_from_fp(ret: [*c]u64, a: [*c]const blst_fp) void;
pub extern fn blst_fp_from_bendian(ret: [*c]blst_fp, a: [*c]const byte) void;
pub extern fn blst_bendian_from_fp(ret: [*c]byte, a: [*c]const blst_fp) void;
pub extern fn blst_fp_from_lendian(ret: [*c]blst_fp, a: [*c]const byte) void;
pub extern fn blst_lendian_from_fp(ret: [*c]byte, a: [*c]const blst_fp) void;
pub extern fn blst_fp2_add(ret: [*c]blst_fp2, a: [*c]const blst_fp2, b: [*c]const blst_fp2) void;
pub extern fn blst_fp2_sub(ret: [*c]blst_fp2, a: [*c]const blst_fp2, b: [*c]const blst_fp2) void;
pub extern fn blst_fp2_mul_by_3(ret: [*c]blst_fp2, a: [*c]const blst_fp2) void;
pub extern fn blst_fp2_mul_by_8(ret: [*c]blst_fp2, a: [*c]const blst_fp2) void;
pub extern fn blst_fp2_lshift(ret: [*c]blst_fp2, a: [*c]const blst_fp2, count: usize) void;
pub extern fn blst_fp2_mul(ret: [*c]blst_fp2, a: [*c]const blst_fp2, b: [*c]const blst_fp2) void;
pub extern fn blst_fp2_sqr(ret: [*c]blst_fp2, a: [*c]const blst_fp2) void;
pub extern fn blst_fp2_cneg(ret: [*c]blst_fp2, a: [*c]const blst_fp2, flag: bool) void;
pub extern fn blst_fp2_eucl_inverse(ret: [*c]blst_fp2, a: [*c]const blst_fp2) void;
pub extern fn blst_fp2_inverse(ret: [*c]blst_fp2, a: [*c]const blst_fp2) void;
pub extern fn blst_fp2_sqrt(ret: [*c]blst_fp2, a: [*c]const blst_fp2) bool;
pub extern fn blst_fp12_sqr(ret: [*c]blst_fp12, a: [*c]const blst_fp12) void;
pub extern fn blst_fp12_cyclotomic_sqr(ret: [*c]blst_fp12, a: [*c]const blst_fp12) void;
pub extern fn blst_fp12_mul(ret: [*c]blst_fp12, a: [*c]const blst_fp12, b: [*c]const blst_fp12) void;
pub extern fn blst_fp12_mul_by_xy00z0(ret: [*c]blst_fp12, a: [*c]const blst_fp12, xy00z0: [*c]const blst_fp6) void;
pub extern fn blst_fp12_conjugate(a: [*c]blst_fp12) void;
pub extern fn blst_fp12_inverse(ret: [*c]blst_fp12, a: [*c]const blst_fp12) void;
pub extern fn blst_fp12_frobenius_map(ret: [*c]blst_fp12, a: [*c]const blst_fp12, n: usize) void;
pub extern fn blst_fp12_is_equal(a: [*c]const blst_fp12, b: [*c]const blst_fp12) bool;
pub extern fn blst_fp12_is_one(a: [*c]const blst_fp12) bool;
pub extern fn blst_fp12_in_group(a: [*c]const blst_fp12) bool;
pub extern fn blst_fp12_one() [*c]const blst_fp12;
pub const blst_p1 = extern struct {
    x: blst_fp = @import("std").mem.zeroes(blst_fp),
    y: blst_fp = @import("std").mem.zeroes(blst_fp),
    z: blst_fp = @import("std").mem.zeroes(blst_fp),
};
pub const blst_p1_affine = extern struct {
    x: blst_fp = @import("std").mem.zeroes(blst_fp),
    y: blst_fp = @import("std").mem.zeroes(blst_fp),
};
pub extern fn blst_p1_add(out: [*c]blst_p1, a: [*c]const blst_p1, b: [*c]const blst_p1) void;
pub extern fn blst_p1_add_or_double(out: [*c]blst_p1, a: [*c]const blst_p1, b: [*c]const blst_p1) void;
pub extern fn blst_p1_add_affine(out: [*c]blst_p1, a: [*c]const blst_p1, b: [*c]const blst_p1_affine) void;
pub extern fn blst_p1_add_or_double_affine(out: [*c]blst_p1, a: [*c]const blst_p1, b: [*c]const blst_p1_affine) void;
pub extern fn blst_p1_double(out: [*c]blst_p1, a: [*c]const blst_p1) void;
pub extern fn blst_p1_mult(out: [*c]blst_p1, p: [*c]const blst_p1, scalar: [*c]const byte, nbits: usize) void;
pub extern fn blst_p1_cneg(p: [*c]blst_p1, cbit: bool) void;
pub extern fn blst_p1_to_affine(out: [*c]blst_p1_affine, in: [*c]const blst_p1) void;
pub extern fn blst_p1_from_affine(out: [*c]blst_p1, in: [*c]const blst_p1_affine) void;
pub extern fn blst_p1_on_curve(p: [*c]const blst_p1) bool;
pub extern fn blst_p1_in_g1(p: [*c]const blst_p1) bool;
pub extern fn blst_p1_is_equal(a: [*c]const blst_p1, b: [*c]const blst_p1) bool;
pub extern fn blst_p1_is_inf(a: [*c]const blst_p1) bool;
pub extern fn blst_p1_generator() [*c]const blst_p1;
pub extern fn blst_p1_affine_on_curve(p: [*c]const blst_p1_affine) bool;
pub extern fn blst_p1_affine_in_g1(p: [*c]const blst_p1_affine) bool;
pub extern fn blst_p1_affine_is_equal(a: [*c]const blst_p1_affine, b: [*c]const blst_p1_affine) bool;
pub extern fn blst_p1_affine_is_inf(a: [*c]const blst_p1_affine) bool;
pub extern fn blst_p1_affine_generator() [*c]const blst_p1_affine;
pub const blst_p2 = extern struct {
    x: blst_fp2 = @import("std").mem.zeroes(blst_fp2),
    y: blst_fp2 = @import("std").mem.zeroes(blst_fp2),
    z: blst_fp2 = @import("std").mem.zeroes(blst_fp2),
};
pub const blst_p2_affine = extern struct {
    x: blst_fp2 = @import("std").mem.zeroes(blst_fp2),
    y: blst_fp2 = @import("std").mem.zeroes(blst_fp2),
};
pub extern fn blst_p2_add(out: [*c]blst_p2, a: [*c]const blst_p2, b: [*c]const blst_p2) void;
pub extern fn blst_p2_add_or_double(out: [*c]blst_p2, a: [*c]const blst_p2, b: [*c]const blst_p2) void;
pub extern fn blst_p2_add_affine(out: [*c]blst_p2, a: [*c]const blst_p2, b: [*c]const blst_p2_affine) void;
pub extern fn blst_p2_add_or_double_affine(out: [*c]blst_p2, a: [*c]const blst_p2, b: [*c]const blst_p2_affine) void;
pub extern fn blst_p2_double(out: [*c]blst_p2, a: [*c]const blst_p2) void;
pub extern fn blst_p2_mult(out: [*c]blst_p2, p: [*c]const blst_p2, scalar: [*c]const byte, nbits: usize) void;
pub extern fn blst_p2_cneg(p: [*c]blst_p2, cbit: bool) void;
pub extern fn blst_p2_to_affine(out: [*c]blst_p2_affine, in: [*c]const blst_p2) void;
pub extern fn blst_p2_from_affine(out: [*c]blst_p2, in: [*c]const blst_p2_affine) void;
pub extern fn blst_p2_on_curve(p: [*c]const blst_p2) bool;
pub extern fn blst_p2_in_g2(p: [*c]const blst_p2) bool;
pub extern fn blst_p2_is_equal(a: [*c]const blst_p2, b: [*c]const blst_p2) bool;
pub extern fn blst_p2_is_inf(a: [*c]const blst_p2) bool;
pub extern fn blst_p2_generator() [*c]const blst_p2;
pub extern fn blst_p2_affine_on_curve(p: [*c]const blst_p2_affine) bool;
pub extern fn blst_p2_affine_in_g2(p: [*c]const blst_p2_affine) bool;
pub extern fn blst_p2_affine_is_equal(a: [*c]const blst_p2_affine, b: [*c]const blst_p2_affine) bool;
pub extern fn blst_p2_affine_is_inf(a: [*c]const blst_p2_affine) bool;
pub extern fn blst_p2_affine_generator() [*c]const blst_p2_affine;
pub extern fn blst_p1s_to_affine(dst: [*c]blst_p1_affine, points: [*c]const [*c]const blst_p1, npoints: usize) void;
pub extern fn blst_p1s_add(ret: [*c]blst_p1, points: [*c]const [*c]const blst_p1_affine, npoints: usize) void;
pub extern fn blst_p1s_mult_wbits_precompute_sizeof(wbits: usize, npoints: usize) usize;
pub extern fn blst_p1s_mult_wbits_precompute(table: [*c]blst_p1_affine, wbits: usize, points: [*c]const [*c]const blst_p1_affine, npoints: usize) void;
pub extern fn blst_p1s_mult_wbits_scratch_sizeof(npoints: usize) usize;
pub extern fn blst_p1s_mult_wbits(ret: [*c]blst_p1, table: [*c]const blst_p1_affine, wbits: usize, npoints: usize, scalars: [*c]const [*c]const byte, nbits: usize, scratch: [*c]limb_t) void;
pub extern fn blst_p1s_mult_pippenger_scratch_sizeof(npoints: usize) usize;
pub extern fn blst_p1s_mult_pippenger(ret: [*c]blst_p1, points: [*c]const [*c]const blst_p1_affine, npoints: usize, scalars: [*c]const [*c]const byte, nbits: usize, scratch: [*c]limb_t) void;
pub extern fn blst_p1s_tile_pippenger(ret: [*c]blst_p1, points: [*c]const [*c]const blst_p1_affine, npoints: usize, scalars: [*c]const [*c]const byte, nbits: usize, scratch: [*c]limb_t, bit0: usize, window: usize) void;
pub extern fn blst_p2s_to_affine(dst: [*c]blst_p2_affine, points: [*c]const [*c]const blst_p2, npoints: usize) void;
pub extern fn blst_p2s_add(ret: [*c]blst_p2, points: [*c]const [*c]const blst_p2_affine, npoints: usize) void;
pub extern fn blst_p2s_mult_wbits_precompute_sizeof(wbits: usize, npoints: usize) usize;
pub extern fn blst_p2s_mult_wbits_precompute(table: [*c]blst_p2_affine, wbits: usize, points: [*c]const [*c]const blst_p2_affine, npoints: usize) void;
pub extern fn blst_p2s_mult_wbits_scratch_sizeof(npoints: usize) usize;
pub extern fn blst_p2s_mult_wbits(ret: [*c]blst_p2, table: [*c]const blst_p2_affine, wbits: usize, npoints: usize, scalars: [*c]const [*c]const byte, nbits: usize, scratch: [*c]limb_t) void;
pub extern fn blst_p2s_mult_pippenger_scratch_sizeof(npoints: usize) usize;
pub extern fn blst_p2s_mult_pippenger(ret: [*c]blst_p2, points: [*c]const [*c]const blst_p2_affine, npoints: usize, scalars: [*c]const [*c]const byte, nbits: usize, scratch: [*c]limb_t) void;
pub extern fn blst_p2s_tile_pippenger(ret: [*c]blst_p2, points: [*c]const [*c]const blst_p2_affine, npoints: usize, scalars: [*c]const [*c]const byte, nbits: usize, scratch: [*c]limb_t, bit0: usize, window: usize) void;
pub extern fn blst_map_to_g1(out: [*c]blst_p1, u: [*c]const blst_fp, v: [*c]const blst_fp) void;
pub extern fn blst_map_to_g2(out: [*c]blst_p2, u: [*c]const blst_fp2, v: [*c]const blst_fp2) void;
pub extern fn blst_encode_to_g1(out: [*c]blst_p1, msg: [*c]const byte, msg_len: usize, DST: [*c]const byte, DST_len: usize, aug: [*c]const byte, aug_len: usize) void;
pub extern fn blst_hash_to_g1(out: [*c]blst_p1, msg: [*c]const byte, msg_len: usize, DST: [*c]const byte, DST_len: usize, aug: [*c]const byte, aug_len: usize) void;
pub extern fn blst_encode_to_g2(out: [*c]blst_p2, msg: [*c]const byte, msg_len: usize, DST: [*c]const byte, DST_len: usize, aug: [*c]const byte, aug_len: usize) void;
pub extern fn blst_hash_to_g2(out: [*c]blst_p2, msg: [*c]const byte, msg_len: usize, DST: [*c]const byte, DST_len: usize, aug: [*c]const byte, aug_len: usize) void;
pub extern fn blst_p1_serialize(out: [*c]byte, in: [*c]const blst_p1) void;
pub extern fn blst_p1_compress(out: [*c]byte, in: [*c]const blst_p1) void;
pub extern fn blst_p1_affine_serialize(out: [*c]byte, in: [*c]const blst_p1_affine) void;
pub extern fn blst_p1_affine_compress(out: [*c]byte, in: [*c]const blst_p1_affine) void;
pub extern fn blst_p1_uncompress(out: [*c]blst_p1_affine, in: [*c]const byte) BLST_ERROR;
pub extern fn blst_p1_deserialize(out: [*c]blst_p1_affine, in: [*c]const byte) BLST_ERROR;
pub extern fn blst_p2_serialize(out: [*c]byte, in: [*c]const blst_p2) void;
pub extern fn blst_p2_compress(out: [*c]byte, in: [*c]const blst_p2) void;
pub extern fn blst_p2_affine_serialize(out: [*c]byte, in: [*c]const blst_p2_affine) void;
pub extern fn blst_p2_affine_compress(out: [*c]byte, in: [*c]const blst_p2_affine) void;
pub extern fn blst_p2_uncompress(out: [*c]blst_p2_affine, in: [*c]const byte) BLST_ERROR;
pub extern fn blst_p2_deserialize(out: [*c]blst_p2_affine, in: [*c]const byte) BLST_ERROR;
pub extern fn blst_keygen(out_SK: [*c]blst_scalar, IKM: [*c]const byte, IKM_len: usize, info: [*c]const byte, info_len: usize) void;
pub extern fn blst_sk_to_pk_in_g1(out_pk: [*c]blst_p1, SK: [*c]const blst_scalar) void;
pub extern fn blst_sign_pk_in_g1(out_sig: [*c]blst_p2, hash: [*c]const blst_p2, SK: [*c]const blst_scalar) void;
pub extern fn blst_sk_to_pk_in_g2(out_pk: [*c]blst_p2, SK: [*c]const blst_scalar) void;
pub extern fn blst_sign_pk_in_g2(out_sig: [*c]blst_p1, hash: [*c]const blst_p1, SK: [*c]const blst_scalar) void;
pub extern fn blst_miller_loop(ret: [*c]blst_fp12, Q: [*c]const blst_p2_affine, P: [*c]const blst_p1_affine) void;
pub extern fn blst_miller_loop_n(ret: [*c]blst_fp12, Qs: [*c]const [*c]const blst_p2_affine, Ps: [*c]const [*c]const blst_p1_affine, n: usize) void;
pub extern fn blst_final_exp(ret: [*c]blst_fp12, f: [*c]const blst_fp12) void;
pub extern fn blst_precompute_lines(Qlines: [*c]blst_fp6, Q: [*c]const blst_p2_affine) void;
pub extern fn blst_miller_loop_lines(ret: [*c]blst_fp12, Qlines: [*c]const blst_fp6, P: [*c]const blst_p1_affine) void;
pub extern fn blst_fp12_finalverify(gt1: [*c]const blst_fp12, gt2: [*c]const blst_fp12) bool;
pub const struct_blst_opaque = opaque {};
pub const blst_pairing = struct_blst_opaque;
pub extern fn blst_pairing_sizeof() usize;
pub extern fn blst_pairing_init(new_ctx: ?*blst_pairing, hash_or_encode: bool, DST: [*c]const byte, DST_len: usize) void;
pub extern fn blst_pairing_get_dst(ctx: ?*const blst_pairing) [*c]const byte;
pub extern fn blst_pairing_commit(ctx: ?*blst_pairing) void;
pub extern fn blst_pairing_aggregate_pk_in_g2(ctx: ?*blst_pairing, PK: [*c]const blst_p2_affine, signature: [*c]const blst_p1_affine, msg: [*c]const byte, msg_len: usize, aug: [*c]const byte, aug_len: usize) BLST_ERROR;
pub extern fn blst_pairing_chk_n_aggr_pk_in_g2(ctx: ?*blst_pairing, PK: [*c]const blst_p2_affine, pk_grpchk: bool, signature: [*c]const blst_p1_affine, sig_grpchk: bool, msg: [*c]const byte, msg_len: usize, aug: [*c]const byte, aug_len: usize) BLST_ERROR;
pub extern fn blst_pairing_mul_n_aggregate_pk_in_g2(ctx: ?*blst_pairing, PK: [*c]const blst_p2_affine, sig: [*c]const blst_p1_affine, scalar: [*c]const byte, nbits: usize, msg: [*c]const byte, msg_len: usize, aug: [*c]const byte, aug_len: usize) BLST_ERROR;
pub extern fn blst_pairing_chk_n_mul_n_aggr_pk_in_g2(ctx: ?*blst_pairing, PK: [*c]const blst_p2_affine, pk_grpchk: bool, sig: [*c]const blst_p1_affine, sig_grpchk: bool, scalar: [*c]const byte, nbits: usize, msg: [*c]const byte, msg_len: usize, aug: [*c]const byte, aug_len: usize) BLST_ERROR;
pub extern fn blst_pairing_aggregate_pk_in_g1(ctx: ?*blst_pairing, PK: [*c]const blst_p1_affine, signature: [*c]const blst_p2_affine, msg: [*c]const byte, msg_len: usize, aug: [*c]const byte, aug_len: usize) BLST_ERROR;
pub extern fn blst_pairing_chk_n_aggr_pk_in_g1(ctx: ?*blst_pairing, PK: [*c]const blst_p1_affine, pk_grpchk: bool, signature: [*c]const blst_p2_affine, sig_grpchk: bool, msg: [*c]const byte, msg_len: usize, aug: [*c]const byte, aug_len: usize) BLST_ERROR;
pub extern fn blst_pairing_mul_n_aggregate_pk_in_g1(ctx: ?*blst_pairing, PK: [*c]const blst_p1_affine, sig: [*c]const blst_p2_affine, scalar: [*c]const byte, nbits: usize, msg: [*c]const byte, msg_len: usize, aug: [*c]const byte, aug_len: usize) BLST_ERROR;
pub extern fn blst_pairing_chk_n_mul_n_aggr_pk_in_g1(ctx: ?*blst_pairing, PK: [*c]const blst_p1_affine, pk_grpchk: bool, sig: [*c]const blst_p2_affine, sig_grpchk: bool, scalar: [*c]const byte, nbits: usize, msg: [*c]const byte, msg_len: usize, aug: [*c]const byte, aug_len: usize) BLST_ERROR;
pub extern fn blst_pairing_merge(ctx: ?*blst_pairing, ctx1: ?*const blst_pairing) BLST_ERROR;
pub extern fn blst_pairing_finalverify(ctx: ?*const blst_pairing, gtsig: [*c]const blst_fp12) bool;
pub extern fn blst_aggregate_in_g1(out: [*c]blst_p1, in: [*c]const blst_p1, zwire: [*c]const byte) BLST_ERROR;
pub extern fn blst_aggregate_in_g2(out: [*c]blst_p2, in: [*c]const blst_p2, zwire: [*c]const byte) BLST_ERROR;
pub extern fn blst_aggregated_in_g1(out: [*c]blst_fp12, signature: [*c]const blst_p1_affine) void;
pub extern fn blst_aggregated_in_g2(out: [*c]blst_fp12, signature: [*c]const blst_p2_affine) void;
pub extern fn blst_core_verify_pk_in_g1(pk: [*c]const blst_p1_affine, signature: [*c]const blst_p2_affine, hash_or_encode: bool, msg: [*c]const byte, msg_len: usize, DST: [*c]const byte, DST_len: usize, aug: [*c]const byte, aug_len: usize) BLST_ERROR;
pub extern fn blst_core_verify_pk_in_g2(pk: [*c]const blst_p2_affine, signature: [*c]const blst_p1_affine, hash_or_encode: bool, msg: [*c]const byte, msg_len: usize, DST: [*c]const byte, DST_len: usize, aug: [*c]const byte, aug_len: usize) BLST_ERROR;
pub extern const BLS12_381_G1: blst_p1_affine;
pub extern const BLS12_381_NEG_G1: blst_p1_affine;
pub extern const BLS12_381_G2: blst_p2_affine;
pub extern const BLS12_381_NEG_G2: blst_p2_affine;
pub extern fn blst_fr_ct_bfly(x0: [*c]blst_fr, x1: [*c]blst_fr, twiddle: [*c]const blst_fr) void;
pub extern fn blst_fr_gs_bfly(x0: [*c]blst_fr, x1: [*c]blst_fr, twiddle: [*c]const blst_fr) void;
pub extern fn blst_fr_to(ret: [*c]blst_fr, a: [*c]const blst_fr) void;
pub extern fn blst_fr_from(ret: [*c]blst_fr, a: [*c]const blst_fr) void;
pub extern fn blst_fp_to(ret: [*c]blst_fp, a: [*c]const blst_fp) void;
pub extern fn blst_fp_from(ret: [*c]blst_fp, a: [*c]const blst_fp) void;
pub extern fn blst_fp_is_square(a: [*c]const blst_fp) bool;
pub extern fn blst_fp2_is_square(a: [*c]const blst_fp2) bool;
pub extern fn blst_p1_from_jacobian(out: [*c]blst_p1, in: [*c]const blst_p1) void;
pub extern fn blst_p2_from_jacobian(out: [*c]blst_p2, in: [*c]const blst_p2) void;
pub extern fn blst_sk_to_pk2_in_g1(out: [*c]byte, out_pk: [*c]blst_p1_affine, SK: [*c]const blst_scalar) void;
pub extern fn blst_sign_pk2_in_g1(out: [*c]byte, out_sig: [*c]blst_p2_affine, hash: [*c]const blst_p2, SK: [*c]const blst_scalar) void;
pub extern fn blst_sk_to_pk2_in_g2(out: [*c]byte, out_pk: [*c]blst_p2_affine, SK: [*c]const blst_scalar) void;
pub extern fn blst_sign_pk2_in_g2(out: [*c]byte, out_sig: [*c]blst_p1_affine, hash: [*c]const blst_p1, SK: [*c]const blst_scalar) void;
pub const blst_uniq = struct_blst_opaque;
pub extern fn blst_uniq_sizeof(n_nodes: usize) usize;
pub extern fn blst_uniq_init(tree: ?*blst_uniq) void;
pub extern fn blst_uniq_test(tree: ?*blst_uniq, msg: [*c]const byte, len: usize) bool;
pub extern fn blst_expand_message_xmd(out: [*c]byte, out_len: usize, msg: [*c]const byte, msg_len: usize, DST: [*c]const byte, DST_len: usize) void;
pub extern fn blst_p1_unchecked_mult(out: [*c]blst_p1, p: [*c]const blst_p1, scalar: [*c]const byte, nbits: usize) void;
pub extern fn blst_p2_unchecked_mult(out: [*c]blst_p2, p: [*c]const blst_p2, scalar: [*c]const byte, nbits: usize) void;
pub extern fn blst_pairing_raw_aggregate(ctx: ?*blst_pairing, q: [*c]const blst_p2_affine, p: [*c]const blst_p1_affine) void;
pub extern fn blst_pairing_as_fp12(ctx: ?*blst_pairing) [*c]blst_fp12;
pub extern fn blst_bendian_from_fp12(out: [*c]byte, a: [*c]const blst_fp12) void;
pub extern fn blst_keygen_v3(out_SK: [*c]blst_scalar, IKM: [*c]const byte, IKM_len: usize, info: [*c]const byte, info_len: usize) void;
pub extern fn blst_keygen_v4_5(out_SK: [*c]blst_scalar, IKM: [*c]const byte, IKM_len: usize, salt: [*c]const byte, salt_len: usize, info: [*c]const byte, info_len: usize) void;
pub extern fn blst_keygen_v5(out_SK: [*c]blst_scalar, IKM: [*c]const byte, IKM_len: usize, salt: [*c]const byte, salt_len: usize, info: [*c]const byte, info_len: usize) void;
pub extern fn blst_derive_master_eip2333(out_SK: [*c]blst_scalar, IKM: [*c]const byte, IKM_len: usize) void;
pub extern fn blst_derive_child_eip2333(out_SK: [*c]blst_scalar, SK: [*c]const blst_scalar, child_index: u32) void;
pub extern fn blst_scalar_from_hexascii(out: [*c]blst_scalar, hex: [*c]const byte) void;
pub extern fn blst_fr_from_hexascii(ret: [*c]blst_fr, hex: [*c]const byte) void;
pub extern fn blst_fp_from_hexascii(ret: [*c]blst_fp, hex: [*c]const byte) void;
pub extern fn blst_p1_sizeof() usize;
pub extern fn blst_p1_affine_sizeof() usize;
pub extern fn blst_p2_sizeof() usize;
pub extern fn blst_p2_affine_sizeof() usize;
pub extern fn blst_fp12_sizeof() usize;
pub extern fn blst_fp_from_le_bytes(ret: [*c]blst_fp, in: [*c]const byte, len: usize) void;
pub extern fn blst_fp_from_be_bytes(ret: [*c]blst_fp, in: [*c]const byte, len: usize) void;
pub extern fn blst_sha256(out: [*c]byte, msg: [*c]const byte, msg_len: usize) void;
