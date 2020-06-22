# blst

The `blst` package provides a rust interface to the blst BLS12-381 signature library.

## Build
The build process consists of two steps, code generation followed by compilation.

```
./generate.py # Optional - only required if making code changes
go build
go test
```

The generate.py script is used to generate both min-pk and min-sig variants of the binding from a common code base. It consumes the `*.tgo` files along with `blst_minpk_test.go` and produces `blst.go` and `blst_minsig_test.go`. The .tgo files can treated as if they were .go files, including the use of gofmt and goimports. The generate script will filter out extra imports while processing and automatically run goimports on the final blst.go file.

After running generate.py, `go build` and `go test` can be run as usual. Cgo will compile `server.c`, which includes the required C implementation files, and `assembly.S`, which includes approprate pre-generated assembly code for the platform. To compile on Windows one has to have MinGW gcc on the %PATH%.

## Usage
There are two primary modes of operation that can be chosen based on type definitions in the application.

For minimal-pubkey-size operations:
```
type PublicKey = P1Affine
type Signature = P2Affine
type AggregateSignature = P2Aggregate
type AggregatePublicKey = P1Aggregate
```

For minimal-signature-size operations:
```
type PublicKey = P2Affine
type Signature = P1Affine
type AggregateSignature = P1Aggregate
type AggregatePublicKey = P2Aggregate
```

TODO - structures and possibly methods

A simple example for generating a key, signing a message, and verifying the message:
```
var ikm [32]byte
_, _ := rand.Read(ikm[:])
sk := KeyGen(ikm[:])
pk := new(PublicKey).From(sk)

var dst = []byte("BLS_SIG_BLS12381G2_XMD:SHA-256_SSWU_RO_NUL_")
msg := []byte("hello foo")
sig := new(Signature).Sign(sk, msg, dst)

if !sig.Verify(pk, msg, dst) {
    t.Errorf("verify sig0")
}
```

See the tests for further examples of usage.
