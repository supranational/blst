package blst

// #cgo CFLAGS: -I${SRCDIR}/.. -I${SRCDIR}/../../build -I${SRCDIR}/../../src -D__BLST_CGO__ -fno-builtin-memcpy -fno-builtin-memset
// #cgo amd64 CFLAGS: -D__ADX__ -mno-avx
// #cgo mips64 mips64le ppc64 ppc64le riscv64 s390x CFLAGS: -D__BLST_NO_ASM__
// #include "blst.h"
import "C"

// P2Mult implements a "sign" function that multiplies a point
// on G2 with the given scalar to get another point on G2.
func P2Mult(q *P2, s *Scalar) *P2Affine {
	sig := new(P2Affine)
	C.blst_sign_pk2_in_g1(nil, sig, q, s)
	return sig
}

// ScalarMult multiplies two scalar values.
func ScalarMult(a, b *Scalar) *Scalar {
	ret := new(Scalar)
	C.blst_sk_mul_n_check(ret, a, b)
	return ret
}

// ScalarAdd adds two scalar values.
func ScalarAdd(a, b *Scalar) *Scalar {
	ret := new(Scalar)
	C.blst_sk_add_n_check(ret, a, b)
	return ret
}
