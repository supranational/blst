<div align="left">
  <img src=blst_logo_small.png>
</div>

# blst (pronounced 'blast')
A BLS12-381 signature library written in C and assembly focused on performance and security.

## Status
**This library has not yet been audited. Use at your own risk.**

Compliant with IETF draft specifications:
- [IETF BLS Signature V2](https://tools.ietf.org/html/draft-irtf-cfrg-bls-signature)
- [IETF Hash-to-Curve V8](https://tools.ietf.org/html/draft-irtf-cfrg-hash-to-curve)

Support for x86_64 and ARM64

Support for Linux, Mac, and Windows

Explicit bindings for other languages
- Go
- Rust

Bindings for other languages provided using [swig](http://swig.org)
- tested Python

Formal verification will be rolling in to various components of the library over the coming months utilizing [cryptol](https://www.cryptol.net) and [coq](https://coq.inria.fr/)
- Field, curve and bulk signature operations

## API
The blst API is defined in the C header [bindings/blst.h](https://github.com/supranational/blst/blob/master/bindings/blst.h). The API can be categorized as follows with some example operations:
- Field (add, sub, mul, neg, inv, to/from Montgomery)
- Curve (add, double, mul, to/from affine, group check)
- Intermediate (hash to curve, pairing, serdes)
- BLS12-381 signature core (sign, verify, aggregate)

Note there is also an auxiliary header file [bindings/blst_aux.h](https://github.com/supranational/blst/blob/master/bindings/blst_aux.h) that is used as a staging area for experimental interfaces that may or may not get promoted to blst.h.

## Build
The build process is very simple and only requires a C complier. It's integrated into Go and Rust ecosystems, so that respective users would go about as they would with any other external module. Otherwise a binary library would have to be compiled.

### C static library
A static library called libblst.a can be built in current working directory of user's choice.

Linux, Mac, and Windows (in MinGW or Cygwin environments)
```
/some/where/build.sh
```

Windows (Visual C)
```
\some\where\build.bat
```

## Bindings
Bindings to other languages that implement minimal-signature-size and minimal-pubkey-size variants of the BLS signature specification are provided as follows:

### Go [src](https://github.com/supranational/blst/tree/master/bindings/go)
TODO - basic details

For more details see the Go binding [readme](https://github.com/supranational/blst/tree/master/bindings/go/README.md).

### Rust [src](https://github.com/supranational/blst/tree/master/bindings/rust)
[`blst`](https://crates.io/crates/blst) is the Rust binding crate.

To use min-pk version:
```
use blst::min_pk::*;
```

To use min-sig version:
```
use blst::min_sig::*;
```

For more details see the Rust binding [readme](https://github.com/supranational/blst/tree/master/bindings/rust/README.md).

### Others
TODO - example swig build/usage

## General notes on implementation
The goal of the blst library is to provide a foundational component for applications and other libraries that require high performance and formally verified BLS12-381 operations. With that in mind some decisions are made to maximize the public good beyond BLS12-381. For example the field operations are optimized for general 384-bit usage as opposed to tuned specifically for the 381-bit BLS12-381 curve parameters. With the formal verification of these foundational components, we believe they can provide a reliable building block for other curves that would like high performance and an extra element of security.

Library deliberately abstains from dealing with memory management and multi-threading with rationale that these ultimately belong in language-specific bindings. Another responsibility that is left to application is random number generation. All this in the name of ultimate run-time neutrality, which makes integration into more stringent environments like Intel SGX or ARM TrustZone trivial.

The assembly code is wrapped into Perl scripts which output an assembly file based on the [ABI](https://en.wikipedia.org/wiki/Application_binary_interface) and operating system. In the `build` directory there are pre-build assembly files for elf, mingw64, masm, and macosx. See [build.sh](https://github.com/supranational/blst/blob/master/build.sh) or [refresh.sh](https://github.com/supranational/blst/blob/master/build/refresh.sh) for usage. This method allows for simple reuse of optimized assembly across various platforms with minimal effort.

Serialization formatting is implemented according to [Appendix A. BLS12-381](https://tools.ietf.org/html/draft-irtf-cfrg-bls-signature-02#appendix-A) of the IETF spec that calls for using the [ZCash definition](https://github.com/zkcrypto/pairing/blob/master/src/bls12_381/README.md#serialization).

## Performance
Currently both the Go and Rust bindings provide benchmarks for a variety of signature related operations.

## License
The blst library is licensed under the [Apache License Version 2.0](LICENSE) software license.
