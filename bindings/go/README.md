# blst [![Lint Status](https://github.com/supranational/blst/workflows/golang-lint/badge.svg)](https://github.com/supranational/blst/actions/workflows/golang-lint.yml)

The `blst` package provides a Go interface to the blst BLS12-381 signature library.

## Build
The build process consists of two steps, code generation followed by compilation.

```
./generate.py # Optional - only required if making code changes
go build
go test
```

The generate.py script is used to generate both min-pk and min-sig variants of the binding from a common code base. It consumes the `*.tgo` files along with `blst_minpk_test.go` and produces `blst.go` and `blst_minsig_test.go`. The .tgo files can treated as if they were .go files, including the use of gofmt and goimports. The generate script will filter out extra imports while processing and automatically run goimports on the final blst.go file.

After running generate.py, <nobr>`go build`</nobr> and <nobr>`go test`</nobr> can be run as usual. Cgo will compile `cgo_server.c`, which includes the required C implementation files, and `cgo_assembly.S`, which includes appropriate pre-generated assembly code for the platform.

#### Caveats

If the test or target application crashes with an "illegal instruction" exception [after copying to an older system], rebuild with `CGO_CFLAGS` environment variable set to <nobr>`-O2 -D__BLST_PORTABLE__`</nobr>. Don't forget <nobr>`-O2`</nobr>!

On Windows the C compiler invoked by cgo, one denoted in `go env CC` output, has to target [MinGW](https://www.mingw-w64.org/). Verify with `<go-env-CC-output> -dM -E -x c nul: | findstr "MINGW64"`.

If you're cross-compiling, you have to set `CC` environment variable to the target C cross-compiler and `CGO_ENABLED` to 1. For example, to compile the test program for ARM:
```
env GOARCH=arm CC=arm-linux-gnueabi-gcc CGO_ENABLED=1 go test -c
```

## Usage
There are two primary modes of operation that can be chosen based on type definitions in the application.

For minimal-pubkey-size operations:
```
type PublicKey = blst.P1Affine
type Signature = blst.P2Affine
type AggregateSignature = blst.P2Aggregate
type AggregatePublicKey = blst.P1Aggregate
```

For minimal-signature-size operations:
```
type PublicKey = blst.P2Affine
type Signature = blst.P1Affine
type AggregateSignature = blst.P1Aggregate
type AggregatePublicKey = blst.P2Aggregate
```

## Core Types and Methods

### Basic Types
- `SecretKey` - Represents a BLS private key (32 bytes)
- `P1Affine` - Represents a public key in G1 (minimal-pubkey-size mode)
- `P2Affine` - Represents a signature in G2 (minimal-pubkey-size mode)
- `P1Aggregate` - For aggregating multiple public keys
- `P2Aggregate` - For aggregating multiple signatures

### Key Methods

#### SecretKey Methods
- `KeyGen(ikm []byte) *SecretKey` - Generate a secret key from input key material
- `Serialize() []byte` - Serialize the secret key to bytes
- `Deserialize(data []byte) *SecretKey` - Deserialize secret key from bytes
- `Zeroize()` - Securely zero out the secret key

#### PublicKey (P1Affine) Methods
- `From(sk *SecretKey) *P1Affine` - Derive public key from secret key
- `Compress() []byte` - Compress public key to 48 bytes
- `Uncompress(data []byte) *P1Affine` - Decompress public key from bytes
- `Serialize() []byte` - Serialize public key to bytes
- `Deserialize(data []byte) *P1Affine` - Deserialize public key from bytes
- `Equals(other *P1Affine) bool` - Check if two public keys are equal

#### Signature (P2Affine) Methods
- `Sign(sk *SecretKey, msg []byte, dst []byte, ...interface{}) *P2Affine` - Sign a message
- `Verify(sigCheck bool, pk *P1Affine, msgCheck bool, msg []byte, dst []byte, ...interface{}) bool` - Verify a signature
- `VerifyCompressed(sig []byte, sigCheck bool, pk []byte, msgCheck bool, msg []byte, dst []byte, ...interface{}) bool` - Verify using compressed inputs
- `Compress() []byte` - Compress signature to 96 bytes
- `Uncompress(data []byte) *P2Affine` - Decompress signature from bytes
- `AggregateVerify(sigCheck bool, pks []*P1Affine, msgCheck bool, msgs [][]byte, dst []byte) bool` - Verify multiple signatures
- `AggregateVerifyCompressed(sig []byte, sigCheck bool, pks [][]byte, msgCheck bool, msgs [][]byte, dst []byte) bool` - Verify using compressed inputs
- `FastAggregateVerify(sigCheck bool, pks []*P1Affine, msg []byte, dst []byte) bool` - Fast verify for same message
- `MultipleAggregateVerify(sigs []*P2Affine, sigCheck bool, pks []*P1Affine, msgCheck bool, msgs [][]byte, dst []byte, randFn func(*Scalar), randBits int) bool` - Verify multiple aggregated signatures
- `BatchUncompress(compressedSigs [][]byte) []*P2Affine` - Efficiently uncompress multiple signatures

#### Aggregate Types
- `P1Aggregate.Aggregate(pks []*P1Affine, check bool)` - Aggregate multiple public keys
- `P2Aggregate.Aggregate(sigs []*P2Affine, check bool)` - Aggregate multiple signatures
- `P2Aggregate.AggregateCompressed(compressedSigs [][]byte, check bool)` - Aggregate compressed signatures
- `P1Aggregate.ToAffine() *P1Affine` - Convert aggregate to affine form
- `P2Aggregate.ToAffine() *P2Affine` - Convert aggregate to affine form

#### Utility Functions
- `HashToG1(msg []byte, dst []byte) *P1` - Hash message to G1 point
- `HashToG2(msg []byte, dst []byte) *P2` - Hash message to G2 point
- `P1Generator() *P1` - Get G1 generator point
- `P2Generator() *P2` - Get G2 generator point
- `SetMaxProcs(procs int)` - Set maximum number of threads for parallel operations

A complete example for generating a key, signing a message, and verifying the message:
```
package main

import (
	"crypto/rand"
	"fmt"

	blst "github.com/supranational/blst/bindings/go"
)

type PublicKey = blst.P1Affine
type Signature = blst.P2Affine
type AggregateSignature = blst.P2Aggregate
type AggregatePublicKey = blst.P1Aggregate

func main() {
	var ikm [32]byte
	_, _ = rand.Read(ikm[:])
	sk := blst.KeyGen(ikm[:])
	pk := new(PublicKey).From(sk)

	var dst = []byte("BLS_SIG_BLS12381G2_XMD:SHA-256_SSWU_RO_NUL_")
	msg := []byte("hello foo")
	sig := new(Signature).Sign(sk, msg, dst)

	if !sig.Verify(true, pk, true, msg, dst) {
		fmt.Println("ERROR: Invalid!")
	} else {
		fmt.Println("Valid!")
	}
}
```

See the tests for further examples of usage.
