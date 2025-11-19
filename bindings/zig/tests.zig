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

    const pk_for_wire  = (try blst.P1.from(&SK)).serialize();
    const sig_for_wire = blst.P2.hash_to(msg, DST, &pk_for_wire).sign_with(&SK).serialize();

    // ... and now on the "receiver" side...

    const sig = try blst.P2_Affine.from(&sig_for_wire);
    const pk  = try blst.P1_Affine.from(&pk_for_wire);

    const ret = sig.core_verify(&pk, true, msg, DST, &pk_for_wire);

    try std.testing.expectEqual(ret, .SUCCESS);

    // ... the same thing through Pairing interface.

    var ctx = try blst.Pairing.init(true, DST, std.testing.allocator);
    defer ctx.deinit();

    try std.testing.expectEqual(ctx.aggregate(&pk, &sig, msg, &pk_for_wire), .SUCCESS);
    ctx.commit();
    try std.testing.expectEqual(ctx.finalverify(null), true);

    std.debug.print("OK\n", .{});
}

test "uniq" {
    const msgs = &[_][]const u8 {
        "three", "two", "one", "three",
    };

    var ctx = try blst.Uniq.init(msgs.len, std.testing.allocator);
    defer ctx.deinit();

    for (msgs, 1..) |msg, next| {
        try std.testing.expectEqual(ctx.is_uniq(msg), next < msgs.len);
    }
}
