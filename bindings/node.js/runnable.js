'use strict';

console.log("testing...");

const blst = require("blst");

var msg = "assertion";          // this what we're signing
var DST = "MY-DST";             // domain separation tag

var SK = new blst.SecretKey();
SK.keygen("*".repeat(32));

////////////////////////////////////////////////////////////////////////
// generate public key and signature

var pk = new blst.P1(SK);
var pk_for_wire = pk.serialize();

var sig = new blst.P2();
var sig_for_wire = sig.hash_to(msg, DST, pk_for_wire)
                      .sign_with(SK)
                      .serialize();

////////////////////////////////////////////////////////////////////////
// at this point 'pk_for_wire', 'sig_for_wire' and 'msg' are
// "sent over network," so now on "receiver" side

sig = new blst.P2_Affine(sig_for_wire);
pk  = new blst.P1_Affine(pk_for_wire);

if (!pk.in_group()) throw "disaster";   // vet the public key

var ctx = new blst.Pairing(true, DST);
ctx.aggregate(pk, sig, msg, pk_for_wire);
ctx.commit();
if (!ctx.finalverify()) throw "disaster";

var r_1 = Buffer.from("73eda753299d7d483339d80809a1d805" +
                      "53bda402fffe5bfeffffffff00000000", "hex").reverse();
try {   // (r-1) + 1 = 0 (mod r)
    new blst.Scalar(r_1).add(new blst.Scalar(Buffer.from([1])));
    throw "disaster";
} catch (e) {
    if (e.message !== "BLST_ERROR: bad scalar") throw "disaster";
}

console.log("OK");

function toHexString(buffer) {
    var s = '', h = '0123456789abcdef';
    (new Uint8Array(buffer)).forEach((v) => { s += h[v >> 4] + h[v & 15]; });
    return s;
}
