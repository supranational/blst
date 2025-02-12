/*
 * Copyright Supranational LLC
 * Licensed under the Apache License, Version 2.0, see LICENSE for details.
 * SPDX-License-Identifier: Apache-2.0
 */

package blst

import (
	"bytes"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"io"
	"os"
	"strconv"
	"strings"
	"testing"
)

func decodeP1(m map[string]interface{}) *P1Affine {
	x, err := hex.DecodeString(m["x"].(string)[2:])
	if err != nil {
		fmt.Println(err)
		return nil
	}
	y, err := hex.DecodeString(m["y"].(string)[2:])
	if err != nil {
		fmt.Println(err)
		return nil
	}
	var p1 P1Affine
	p1.Deserialize(append(x, y...))
	return &p1
}

func jsonG1HashToCurve(t *testing.T, fname string) {
	t.Helper()
	vfile, err := os.Open(fname)
	if err != nil {
		t.Skipf("%.16s... not found", fname)
	}
	buf, err := io.ReadAll(vfile)
	if err != nil {
		t.Error(err.Error())
	}

	var vectors map[string]interface{}
	err = json.Unmarshal(buf, &vectors)
	if err != nil {
		t.Error(err.Error())
	}

	dst := []byte(vectors["dst"].(string))
	hash_or_encode := vectors["randomOracle"].(bool)

	vectorsArr, ok := vectors["vectors"].([]interface{})
	if !ok {
		t.Error("Could not cast vectors to an array")
	}

	for _, v := range vectorsArr {
		testMap, ok := v.(map[string]interface{})
		if !ok {
			t.Errorf("Could not cast vector to map")
		}

		msg := []byte(testMap["msg"].(string))
		p1Expected := decodeP1(testMap["P"].(map[string]interface{}))
		var p1Hashed *P1Affine
		if hash_or_encode {
			p1Hashed = HashToG1(msg, dst).ToAffine()
		} else {
			p1Hashed = EncodeToG1(msg, dst).ToAffine()
		}

		if !p1Hashed.Equals(p1Expected) {
			t.Errorf("hashed != expected")
		}
	}
}

func TestG1HashToCurve(t *testing.T) {
	t.Parallel()
	jsonG1HashToCurve(t, "../vectors/hash_to_curve/BLS12381G1_XMD_SHA-256_SSWU_RO_.json")
	jsonG1HashToCurve(t, "../vectors/hash_to_curve/BLS12381G1_XMD_SHA-256_SSWU_NU_.json")
}

func decodeP2(m map[string]interface{}) *P2Affine {
	xArr := strings.Split(m["x"].(string), ",")
	x0, err := hex.DecodeString(xArr[0][2:])
	if err != nil {
		fmt.Println(err)
		return nil
	}
	x1, err := hex.DecodeString(xArr[1][2:])
	if err != nil {
		fmt.Println(err)
		return nil
	}
	yArr := strings.Split(m["y"].(string), ",")
	y0, err := hex.DecodeString(yArr[0][2:])
	if err != nil {
		fmt.Println(err)
		return nil
	}
	y1, err := hex.DecodeString(yArr[1][2:])
	if err != nil {
		fmt.Println(err)
		return nil
	}
	var p2 P2Affine
	p2.Deserialize(append(x1, append(x0, append(y1, y0...)...)...))
	return &p2
}

func jsonG2HashToCurve(t *testing.T, fname string) {
	t.Helper()
	vfile, err := os.Open(fname)
	if err != nil {
		t.Skipf("%.16s... not found", fname)
	}
	buf, err := io.ReadAll(vfile)
	if err != nil {
		t.Error(err.Error())
	}

	var vectors map[string]interface{}
	err = json.Unmarshal(buf, &vectors)
	if err != nil {
		t.Error(err.Error())
	}

	dst := []byte(vectors["dst"].(string))
	hash_or_encode := vectors["randomOracle"].(bool)

	vectorsArr, ok := vectors["vectors"].([]interface{})
	if !ok {
		t.Error("Could not cast vectors to an array")
	}

	for _, v := range vectorsArr {
		testMap, ok := v.(map[string]interface{})
		if !ok {
			t.Errorf("Could not cast vector to map")
		}

		msg := []byte(testMap["msg"].(string))
		p2Expected := decodeP2(testMap["P"].(map[string]interface{}))
		var p2Hashed *P2Affine
		if hash_or_encode {
			p2Hashed = HashToG2(msg, dst).ToAffine()
		} else {
			p2Hashed = EncodeToG2(msg, dst).ToAffine()
		}

		if !p2Hashed.Equals(p2Expected) {
			t.Errorf("hashed != expected")
		}
	}
}

func TestG2HashToCurve(t *testing.T) {
	t.Parallel()
	jsonG2HashToCurve(t, "../vectors/hash_to_curve/BLS12381G2_XMD_SHA-256_SSWU_RO_.json")
	jsonG2HashToCurve(t, "../vectors/hash_to_curve/BLS12381G2_XMD_SHA-256_SSWU_NU_.json")
}

func jsonExpandMessageXmd(t *testing.T, fname string) {
	t.Helper()
	vfile, err := os.Open(fname)
	if err != nil {
		t.Skipf("%.16s... not found", fname)
	}
	buf, err := io.ReadAll(vfile)
	if err != nil {
		t.Error(err.Error())
	}

	var vectors map[string]interface{}
	err = json.Unmarshal(buf, &vectors)
	if err != nil {
		t.Error(err.Error())
	}

	DST := []byte(vectors["DST"].(string))

	tests, ok := vectors["tests"].([]interface{})
	if !ok {
		t.Error("Could not cast 'tests' to an array")
	}

	for _, v := range tests {
		test, ok := v.(map[string]interface{})
		if !ok {
			t.Error("Could not map 'tests[]' element")
		}

		len_in_bytes, err := strconv.ParseInt(test["len_in_bytes"].(string), 0, 0)
		if err != nil {
			t.Error(err.Error())
		}
		msg := []byte(test["msg"].(string))
		expected, err := hex.DecodeString(test["uniform_bytes"].(string))
		if err != nil {
			t.Error(err.Error())
		}

		hashed := expandMessageXmd(msg, DST, int(len_in_bytes))
		if !bytes.Equal(hashed, expected) {
			t.Error("hashed != expected")
		}
	}
}

func TestExpandMessageXmd(t *testing.T) {
	t.Parallel()
	jsonExpandMessageXmd(t, "../vectors/hash_to_curve/expand_message_xmd_SHA256_256.json")
	jsonExpandMessageXmd(t, "../vectors/hash_to_curve/expand_message_xmd_SHA256_38.json")
}
