package blst_test

import (
	"math/rand"
	"testing"

	blst "github.com/photon-storage/blst/bindings/go"
)

// Demonstration of PoR construction using blst primitives.

var dst = []byte("BLS_SIG_BLS12381G2_XMD:SHA-256_SSWU_RO_POR_")

func scalar(t *testing.T, nbytes int) *blst.Scalar {
	var v [32]byte
	_, err := rand.Read(v[:])
	if err != nil {
		t.Error(err)
	}
	// Set higher bytes to zero based on nbytes.
	for i := 0; i < 32-nbytes; i++ {
		v[0] = 0
	}
	return new(blst.Scalar).FromBEndian(v[:])
}

func genKeys(t *testing.T) (*blst.SecretKey, *blst.P1Affine) {
	var ikm [32]byte
	_, err := rand.Read(ikm[:])
	if err != nil {
		t.Error(err)
	}
	sk := blst.KeyGen(ikm[:])
	pk := new(blst.P1Affine).From(sk)
	return sk, pk
}

func toP2(aff *blst.P2Affine) *blst.P2 {
	p2 := new(blst.P2)
	p2.FromAffine(aff)
	return p2
}

func TestScalarMultOnce(t *testing.T) {
	sk, pk := genKeys(t)
	u := blst.HashToG2([]byte("u"), dst)
	// sig = u^sk
	sig := blst.P2Mult(u, sk)

	// e(u^sk, g1) = e(u, pk)
	a := blst.Fp12MillerLoop(sig, blst.P1Generator().ToAffine())
	b := blst.Fp12MillerLoop(u.ToAffine(), pk)
	if !blst.Fp12FinalVerify(a, b) {
		t.Error("pairing verification failure")
	}
}

func TestScalarMultTwice(t *testing.T) {
	sk, pk := genKeys(t)
	u := blst.HashToG2([]byte("u"), dst)
	v := scalar(t, 32)
	// sig = u^sk
	sig := blst.P2Mult(u, sk)
	// sigma = u^(sk+v)
	sigma := blst.P2Mult(toP2(sig), v)

	// e(u^(sk+v), g1) = e(u^v, pk)
	a := blst.Fp12MillerLoop(sigma, blst.P1Generator().ToAffine())
	b := blst.Fp12MillerLoop(blst.P2Mult(u, v), pk)
	if !blst.Fp12FinalVerify(a, b) {
		t.Error("pairing verification failure")
	}
}

func TestScalarMultTwiceSum(t *testing.T) {
	sk, pk := genKeys(t)
	u0 := blst.HashToG2([]byte("u0"), dst)
	u1 := blst.HashToG2([]byte("u1"), dst)
	v0 := scalar(t, 32)
	v1 := scalar(t, 32)
	// sig = u^sk
	sig0 := blst.P2Mult(u0, sk)
	sig1 := blst.P2Mult(u1, sk)
	// sigma = u^(sk+v)
	sigma0 := blst.P2Mult(toP2(sig0), v0)
	sigma1 := blst.P2Mult(toP2(sig1), v1)
	// sigma = sigma0 * sigma1
	sigma := blst.P2AffinesAdd([]*blst.P2Affine{
		sigma0,
		sigma1,
	})
	// sum = u0^v0 * u1^v1
	sum := blst.P2AffinesAdd([]*blst.P2Affine{
		blst.P2Mult(u0, v0),
		blst.P2Mult(u1, v1),
	})

	// e(u0^(sk+v0) * u1^(sk+v1), g1) = e(u0^v0 * u1^v1, pk)
	a := blst.Fp12MillerLoop(sigma.ToAffine(), blst.P1Generator().ToAffine())
	b := blst.Fp12MillerLoop(sum.ToAffine(), pk)
	if !blst.Fp12FinalVerify(a, b) {
		t.Error("pairing verification failure")
	}
}

func TestScalarAdd(t *testing.T) {
	u := blst.HashToG2([]byte("u"), dst)
	// 31 bytes to avoid addition overflow
	a := scalar(t, 31)
	b := scalar(t, 31)
	c := blst.ScalarAdd(a, b)

	// expected = u^a * u^b
	expected := blst.P2AffinesAdd([]*blst.P2Affine{
		blst.P2Mult(u, a),
		blst.P2Mult(u, b),
	}).ToAffine()
	// got = u^(a+b)
	got := blst.P2Mult(u, c)
	if !expected.Equals(got) {
		t.Error("scalar addition failure")
	}
}

func TestPoRConstruction(t *testing.T) {
	sk, pk := genKeys(t)

	// File chunks:
	// 2 blocks,
	// 3 sectors per block
	// 32 bytes per sector
	m00 := scalar(t, 32)
	m01 := scalar(t, 32)
	m02 := scalar(t, 32)
	m10 := scalar(t, 32)
	m11 := scalar(t, 32)
	m12 := scalar(t, 32)

	// Random elements from G2, one per sector.
	u0 := blst.HashToG2([]byte("u0"), dst)
	u1 := blst.HashToG2([]byte("u1"), dst)
	u2 := blst.HashToG2([]byte("u2"), dst)

	// Block signatures
	// sigma[i] = H(i) * u0^m[i,0] * u1^m[i,1] * u2^m[i,2]
	sigma0 := blst.P2Mult(
		blst.P2AffinesAdd([]*blst.P2Affine{
			blst.HashToG2([]byte("block0"), dst).ToAffine(),
			blst.P2Mult(u0, m00),
			blst.P2Mult(u1, m01),
			blst.P2Mult(u2, m02),
		}),
		sk,
	)
	sigma1 := blst.P2Mult(
		blst.P2AffinesAdd([]*blst.P2Affine{
			blst.HashToG2([]byte("block1"), dst).ToAffine(),
			blst.P2Mult(u0, m10),
			blst.P2Mult(u1, m11),
			blst.P2Mult(u2, m12),
		}),
		sk,
	)

	// Random elements selected for challenge
	// One per challenged block.
	v0 := scalar(t, 32)
	v1 := scalar(t, 32)

	// Proofs: one per sector
	// mu[j] = v0*m[0,j] + v1*m[1,j]
	// proof[j] = u0^mu0 = u0^(v0*m[0,j]) * u0^(v1*m[1,j])
	proof0 := blst.P2AffinesAdd([]*blst.P2Affine{
		blst.P2Mult(toP2(blst.P2Mult(u0, v0)), m00),
		blst.P2Mult(toP2(blst.P2Mult(u0, v1)), m10),
	})
	proof1 := blst.P2AffinesAdd([]*blst.P2Affine{
		blst.P2Mult(toP2(blst.P2Mult(u1, v0)), m01),
		blst.P2Mult(toP2(blst.P2Mult(u1, v1)), m11),
	})
	proof2 := blst.P2AffinesAdd([]*blst.P2Affine{
		blst.P2Mult(toP2(blst.P2Mult(u2, v0)), m02),
		blst.P2Mult(toP2(blst.P2Mult(u2, v1)), m12),
	})

	// sigma = sigma0^v0 * sigma1^v1
	sigma := blst.P2AffinesAdd([]*blst.P2Affine{
		blst.P2Mult(toP2(sigma0), v0),
		blst.P2Mult(toP2(sigma1), v1),
	})

	// e(sigma0^v0 * sigma1^v1, g1) = e(H(0) * H(1) * proof0 * proof1 * proof2, pk)
	a := blst.Fp12MillerLoop(sigma.ToAffine(), blst.P1Generator().ToAffine())
	b := blst.Fp12MillerLoop(blst.P2AffinesAdd([]*blst.P2Affine{
		blst.P2Mult(blst.HashToG2([]byte("block0"), dst), v0),
		blst.P2Mult(blst.HashToG2([]byte("block1"), dst), v1),
		proof0.ToAffine(),
		proof1.ToAffine(),
		proof2.ToAffine(),
	}).ToAffine(), pk)
	if !blst.Fp12FinalVerify(a, b) {
		t.Error("pairing verification failure")
	}
}

func TestPorWithPublicVerification(t *testing.T) {
	sk, pk := genKeys(t)

	// File chunks:
	// 2 blocks,
	// 3 sectors per block
	// 24 bytes per sector to avoid scale multiplication overflow.
	m00 := scalar(t, 24)
	m01 := scalar(t, 24)
	m02 := scalar(t, 24)
	m10 := scalar(t, 24)
	m11 := scalar(t, 24)
	m12 := scalar(t, 24)

	// Random elements from G2, one per sector.
	u0 := blst.HashToG2([]byte("u0"), dst)
	u1 := blst.HashToG2([]byte("u1"), dst)
	u2 := blst.HashToG2([]byte("u2"), dst)

	// Block signatures
	// sigma[i] = H(i) * u0^m[i,0] * u1^m[i,1] * u2^m[i,2]
	sigma0 := blst.P2Mult(
		blst.P2AffinesAdd([]*blst.P2Affine{
			blst.HashToG2([]byte("block0"), dst).ToAffine(),
			blst.P2Mult(u0, m00),
			blst.P2Mult(u1, m01),
			blst.P2Mult(u2, m02),
		}),
		sk,
	)
	sigma1 := blst.P2Mult(
		blst.P2AffinesAdd([]*blst.P2Affine{
			blst.HashToG2([]byte("block1"), dst).ToAffine(),
			blst.P2Mult(u0, m10),
			blst.P2Mult(u1, m11),
			blst.P2Mult(u2, m12),
		}),
		sk,
	)

	// Random elements selected for challenge
	// One per challenged block.
	// 7 bytes to avoid overflow when calculating proofing mu's
	v0 := scalar(t, 7)
	v1 := scalar(t, 7)

	// Scalar dot-product calculated by proofer.
	mu0 := blst.ScalarAdd(
		blst.ScalarMult(v0, m00),
		blst.ScalarMult(v1, m10),
	)
	mu1 := blst.ScalarAdd(
		blst.ScalarMult(v0, m01),
		blst.ScalarMult(v1, m11),
	)
	mu2 := blst.ScalarAdd(
		blst.ScalarMult(v0, m02),
		blst.ScalarMult(v1, m12),
	)

	// sigma = sigma0^v0 * sigma1^v1
	sigma := blst.P2AffinesAdd([]*blst.P2Affine{
		blst.P2Mult(toP2(sigma0), v0),
		blst.P2Mult(toP2(sigma1), v1),
	})

	// e(sigma0^v0 * sigma1^v1, g1) = e(H(0) * H(1) * u0^mu0 * u1^mu1 * u2^mu2, pk)
	a := blst.Fp12MillerLoop(sigma.ToAffine(), blst.P1Generator().ToAffine())
	b := blst.Fp12MillerLoop(blst.P2AffinesAdd([]*blst.P2Affine{
		blst.P2Mult(blst.HashToG2([]byte("block0"), dst), v0),
		blst.P2Mult(blst.HashToG2([]byte("block1"), dst), v1),
		blst.P2Mult(u0, mu0),
		blst.P2Mult(u1, mu1),
		blst.P2Mult(u2, mu2),
	}).ToAffine(), pk)
	if !blst.Fp12FinalVerify(a, b) {
		t.Error("pairing verification failure")
	}
}
