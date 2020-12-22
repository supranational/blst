export interface Blst {
  SecretKey: SecretKeyConstructor;
  P1_Affine: P1_AffineConstructor;
  P2_Affine: P2_AffineConstructor;
  P1: P1Constructor;
  P2: P2Constructor;
  PT: PTConstructor;
  Pairing: PairingConstructor;
}

// blst.hpp types

type bool = boolean;
type size_t = number;
type app__string_view = string | Uint8Array;
type DST = string;
type byte = Uint8Array;

// SecretKey

export interface SecretKeyConstructor {
  new (): SecretKey;
}

export interface SecretKey {
  keygen(IKM: app__string_view, info?: string): void;
  from_bendian(bytes: byte): void;
  from_lendian(bytes: byte): void;
  to_bendian(): byte;
  to_lendian(): byte;
}

// P1

export interface P1_AffineConstructor {
  new (): P1_Affine;
  new (bytes: byte): P1_Affine;
  new (jacobian: P1): P1_Affine;
}

export interface P1_Affine {
  to_jacobian(): P1;
  serialize(): byte;
  compress(): byte;
  on_curve(): bool;
  in_group(): bool;
  is_inf(): bool;
  core_verify(
    pk: P2_Affine,
    hash_or_encode: bool,
    msg: app__string_view,
    DST?: DST,
    aug?: app__string_view
  ): BLST_ERROR;
}

export interface P1Constructor {
  new (): P1;
  new (sk: SecretKey): P1;
  new (bytes: byte): P1;
  new (affine: P1_Affine): P1;
  generator(): P1;
}

export interface P1 {
  to_affine(): P1_Affine;
  serialize(): byte;
  compress(): byte;
  is_inf(): bool;
  aggregate(affine: P1_Affine): void;
  sign_with(sk: SecretKey): this;
  hash_to(msg: app__string_view, DST?: DST, aug?: app__string_view): this;
  encode_to(msg: app__string_view, DST?: DST, aug?: app__string_view): this;
  cneg(flag: bool): this;
  add(a: this): this;
  add(a: P1_Affine): this;
  dbl(): this;
}

// P2

export interface P2_AffineConstructor {
  new (): P2_Affine;
  new (bytes: byte): P2_Affine;
  new (jacobian: P2): P2_Affine;
}

export interface P2_Affine {
  to_jacobian(): P2;
  serialize(): byte;
  compress(): byte;
  on_curve(): bool;
  in_group(): bool;
  is_inf(): bool;
  core_verify(
    pk: P1_Affine,
    hash_or_encode: bool,
    msg: app__string_view,
    DST?: DST,
    aug?: app__string_view
  ): BLST_ERROR;
}

export interface P2Constructor {
  new (): P2;
  new (sk: SecretKey): P2;
  new (bytes: byte): P2;
  new (affine: P2_Affine): P2;
  generator(): P2;
}

export interface P2 {
  to_affine(): P2_Affine;
  serialize(): byte;
  compress(): byte;
  is_inf(): bool;
  aggregate(affine: P2_Affine): void;
  sign_with(sk: SecretKey): this;
  hash_to(msg: app__string_view, DST?: DST, aug?: app__string_view): this;
  encode_to(msg: app__string_view, DST?: DST, aug?: app__string_view): this;
  cneg(flag: bool): this;
  add(a: this): this;
  add(a: P2_Affine): this;
  dbl(): this;
}

// PT

export interface PTConstructor {
  new (p: P1_Affine): PT;
  new (p: P2_Affine): PT;
}

export interface PT {}

// Pairing

export interface PairingConstructor {
  new (hash_or_encode: bool, DST: DST): Pairing;
}

export interface Pairing {
  aggregate(
    pk: P1_Affine,
    sig: P2_Affine,
    msg: app__string_view,
    aug?: app__string_view
  ): BLST_ERROR;
  aggregate(
    pk: P2_Affine,
    sig: P1_Affine,
    msg: app__string_view,
    aug?: app__string_view
  ): BLST_ERROR;
  mul_n_aggregate(
    pk: P1_Affine,
    sig: P2_Affine,
    scalar: byte,
    nbits: size_t,
    msg: app__string_view,
    aug?: app__string_view
  ): BLST_ERROR;
  mul_n_aggregate(
    pk: P2_Affine,
    sig: P1_Affine,
    scalar: byte,
    nbits: size_t,
    msg: app__string_view,
    aug?: app__string_view
  ): BLST_ERROR;
  commit(): void;
  merge(ctx: Pairing): BLST_ERROR;
  finalverify(sig?: PT): bool;
}

// Misc

export enum BLST_ERROR {
  BLST_SUCCESS = 0,
  BLST_BAD_ENCODING = 1,
  BLST_POINT_NOT_ON_CURVE = 2,
  BLST_POINT_NOT_IN_GROUP = 3,
  BLST_AGGR_TYPE_MISMATCH = 4,
  BLST_VERIFY_FAIL = 5,
  BLST_PK_IS_INFINITY = 6,
}
