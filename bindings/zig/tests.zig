const std = @import("std");
const blst = @import("blst");

test "sign/verify" {
    const password = [_]u8{'*'} ** 32;

    var SK = blst.SecretKey{};
    SK.keygen(&password, null);
    defer SK.deinit();

    const msg = "assertion";
    const DST = "MY-DST";

    // on the "sender" side...

    const pk_for_wire  = blst.P1.public_key(&SK).serialize();
    const sig_for_wire = blst.P2.hash_to(msg, DST, &pk_for_wire).sign_with(&SK).serialize();

    // ... and now on the "receiver" side...

    const sig = try blst.P2_Affine.from(&sig_for_wire);
    const pk  = try blst.P1_Affine.from(&pk_for_wire);

    const ret = sig.core_verify(&pk, true, msg, DST, &pk_for_wire);

    try std.testing.expectEqual(ret, blst.ERROR.SUCCESS);

    std.debug.print("OK\n", .{});
}
