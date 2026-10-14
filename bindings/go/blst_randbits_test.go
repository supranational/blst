// Copyright Supranational LLC
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

package blst

import (
	"testing"
)

// A negative randBits must not slip past the bit-length guard in
// PairingMulNAggregatePkInG{1,2}. randBits is a signed int handed to C as
// C.size_t(randBits); a negative value wraps to a huge size_t that would
// reach POINTonE{1,2}_mult_w5 and read far past the 32-byte rand scalar.
// The guard turns that into an immediate panic instead.
func TestPairingMulNAggregateNegativeRandBits(t *testing.T) {
	t.Parallel()
	dst := []byte("BLS_SIG_BLS12381G2_XMD:SHA-256_SSWU_RO_NUL_")
	msg := []byte("blst is a blast!!")

	expectPanic := func(name string, fn func()) {
		defer func() {
			if recover() == nil {
				t.Errorf("%s: expected panic on negative randBits", name)
			}
		}()
		fn()
	}

	expectPanic("PkInG1", func() {
		PairingMulNAggregatePkInG1(PairingCtx(true, dst),
			new(P1Affine), false, new(P2Affine), false,
			new(Scalar), -1, msg)
	})
	expectPanic("PkInG2", func() {
		PairingMulNAggregatePkInG2(PairingCtx(true, dst),
			new(P2Affine), false, new(P1Affine), false,
			new(Scalar), -1, msg)
	})
}
