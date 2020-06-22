# blst

The `blst` crate provides a rust interface to the blst BLS12-381 signature library.

## Build
The build process uses [bindgen](https://github.com/rust-lang/rust-bindgen) on the blst.h C header file to automatically create the FFI bindings to blst. Currently [build.rs](https://github.com/supranational/blst/blob/master/bindings/rust/build.rs) also runs the assembly generation scripts and compiles everything into libblst.a within the rust target build area. Alternatively this can be modified to either call the appropriate build script in blst base directory or simply link to a prebuilt libblst.a. As more platforms are tested and feedback collected, this process may change.

Everything can be built and run with the typical cargo commands:

```
cargo test
cargo bench
```

**Note this has primarily been tested on Ubuntu and may require further work for other operating systems.**

## Usage
There are two primary modes of operation that can be chosen based on declaration path:

For minimal-pubkey-size operations:
```
use blst::min_pk::*
```

For minimal-signature-size operations:
```
use blst::min_sig::*
```

There are five structs with inherent implementations that provide the BLS12-381 signature functionality.
```
SecretKey
PublicKey
AggregatePublicKey
Signature
AggregateSignature
```

A simple example for generating a key, signing a message, and verifying the message:
```
let mut ikm = [0u8; 32];
rng.fill_bytes(&mut ikm);

let sk = SecretKey::key_gen(&ikm, &[]).unwrap();
let pk = sk.sk_to_pk();

let dst = b"BLS_SIG_BLS12381G2_XMD:SHA-256_SSWU_RO_NUL_";
let msg = b"blst is such a blast";
let sig = sk.sign(msg, dst, &[]);

let err = sig.verify(msg, dst, &[], &pk);
assert_eq!(err, BLST_ERROR::BLST_SUCCESS);
```

See the tests in src/lib.rs and benchmarks in benches/blst_benches.rs for further examples of usage.
