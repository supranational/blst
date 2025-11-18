#!/usr/bin/env python3

import os
import sys
import subprocess
import re

here = re.split(r'/(?=[^/]*$)', sys.argv[0])
if len(here) > 1:
    os.chdir(here[0])


def newer(*files):
    assert len(files) > 1
    rh = files[-1]
    if not os.path.exists(rh):
        return True
    for lh in files[:-1]:
        if os.stat(lh).st_mtime > os.stat(rh).st_mtime:
            return True
    return False


if newer("../blst.h", "c.zig"):
    print("generating c.zig...") or sys.stdout.flush()
    ret = subprocess.run(["zig", "translate-c", "../blst.h", "-D__BLST_ZIG__"],
                         capture_output=True, text=True)
    with open("c.zig", "w") as fd:
        print("// automatically generated with 'zig translate-c'", file=fd)
        for line in ret.stdout.splitlines():
            if "no file" in line:
                break
            elif not line.startswith("pub const _"):
                print(line, file=fd)

print("generating root.zig...") or sys.stdout.flush()
root_zig = """
const std = @import("std");

pub const c = @import("c.zig");

pub const Error = error {
    BAD_ENCODING,
    POINT_NOT_ON_CURVE,
    POINT_NOT_IN_GROUP,
    AGGR_TYPE_MISMATCH,
    VERIFY_FAIL,
    PK_IS_INFINITY,
    BAD_SCALAR,
    Unknown,
};

pub const ERROR = enum(c.BLST_ERROR) {
    SUCCESS            = c.BLST_SUCCESS,
    BAD_ENCODING       = c.BLST_BAD_ENCODING,
    POINT_NOT_ON_CURVE = c.BLST_POINT_NOT_ON_CURVE,
    POINT_NOT_IN_GROUP = c.BLST_POINT_NOT_IN_GROUP,
    AGGR_TYPE_MISMATCH = c.BLST_AGGR_TYPE_MISMATCH,
    VERIFY_FAIL        = c.BLST_VERIFY_FAIL,
    PK_IS_INFINITY     = c.BLST_PK_IS_INFINITY,
    BAD_SCALAR         = c.BLST_BAD_SCALAR,

    pub fn as_error(self: ERROR) Error {
        return switch (self) {
            .BAD_ENCODING       => Error.BAD_ENCODING,
            .POINT_NOT_ON_CURVE => Error.POINT_NOT_ON_CURVE,
            .POINT_NOT_IN_GROUP => Error.POINT_NOT_IN_GROUP,
            .AGGR_TYPE_MISMATCH => Error.AGGR_TYPE_MISMATCH,
            .VERIFY_FAIL        => Error.VERIFY_FAIL,
            .PK_IS_INFINITY     => Error.PK_IS_INFINITY,
            .BAD_SCALAR         => Error.BAD_SCALAR,
            else                => Error.Unknown,
        };
    }
};

pub const SecretKey = struct {
    key: c.blst_scalar = c.blst_scalar{},

    pub fn keygen(self: *SecretKey, IKM: []const u8, info: ?[]const u8) void {
        const opt = info orelse &[_]u8{};
        c.blst_keygen(&self.key, @ptrCast(IKM), IKM.len,
                                 @ptrCast(opt), opt.len);
    }

    pub fn deinit(self: *SecretKey) void {
        self.key = c.blst_scalar{};
    }
};

pub const PT = c.blst_fp12;

pub const Pairing = struct {
    ctx: []u64 = &[_]u64{},
    allocator: std.mem.Allocator,

    pub fn init(hash_or_encode: bool, DST: []const u8,
                allocator: std.mem.Allocator) !Pairing {
        const nlimbs = (c.blst_pairing_sizeof() + @sizeOf(u64) - 1) / @sizeOf(u64);
        const buffer = try allocator.alloc(u64, nlimbs);

        c.blst_pairing_init(@ptrCast(buffer), hash_or_encode, &DST[0], DST.len);

        return Pairing{
            .ctx = buffer,
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *Pairing) void {
        self.allocator.free(self.ctx);
        self.ctx = &[_]u64{};
    }

    pub fn aggregate(self: *Pairing, pk: anytype, sig: anytype,
                     msg: []const u8, aug: ?[]const u8) ERROR {
        const opt = aug orelse &[_]u8{};
        var err: c.BLST_ERROR = undefined;

        switch (@TypeOf(pk)) {
            *const P1_Affine, *P1_Affine => {
                const sigp : [*c]const c.blst_p2_affine = switch (@TypeOf(sig)) {
                    @TypeOf(null) => null,
                    else => &sig.point,
                };
                err = c.blst_pairing_aggregate_pk_in_g1(@ptrCast(self.ctx),
                                                        &pk.point, sigp,
                                                        @ptrCast(msg), msg.len,
                                                        @ptrCast(opt), opt.len);
            },
            *const P2_Affine, *P2_Affine => {
                const sigp : [*c]const c.blst_p1_affine = switch (@TypeOf(sig)) {
                    @TypeOf(null) => null,
                    else => &sig.point,
                };
                err = c.blst_pairing_aggregate_pk_in_g2(@ptrCast(self.ctx),
                                                        &pk.point, sigp,
                                                        @ptrCast(msg), msg.len,
                                                        @ptrCast(opt), opt.len);
            },
            else => |T| @compileError("expected type '*const blst.P1_Affine' "
                                      ++ "or '*const blst.P2_Affine', found '"
                                      ++ @typeName(T) ++ "'"),
        }

        return @as(ERROR, @enumFromInt(err));
    }

    pub fn commit(self: *Pairing) void {
        c.blst_pairing_commit(@ptrCast(self.ctx));
    }

    pub fn merge(self: *Pairing, second: *const Pairing) ERROR {
        return c.blst_pairing_merge(@ptrCast(self.ctx), @ptrCast(second.ctx));
    }

    pub fn finalverify(self: *Pairing, optional: ?*const PT) bool {
        return c.blst_pairing_finalverify(@ptrCast(self.ctx), optional);
    }

    pub fn raw_aggregate(self: *Pairing, q: *const P2_Affine,
                                         p: *const P1_Affine) void {
        c.blst_pairing_raw_aggregate(@ptrCast(self.ctx), q, p);
    }

    pub fn as_fp12(self: *Pairing) *const PT {
        return c.blst_pairing_as_fp12(@ptrCast(self.ctx));
    }
};

const FP_BYTES = 384/8;
pub const P1_COMPRESS_BYTES  = FP_BYTES;
pub const P1_SERIALIZE_BYTES = FP_BYTES*2;
pub const P2_COMPRESS_BYTES  = FP_BYTES*2;
pub const P2_SERIALIZE_BYTES = FP_BYTES*4;
"""
p1_zig = """
pub const P1_Affine = struct {
    point : c.blst_p1_affine = c.blst_p1_affine{},

    pub fn from(in: anytype) !P1_Affine {
        switch (@TypeOf(in)) {
            *const P1,
            *P1  => return in.to_affine(),
            P1   => @compileError("expected type '*const blst.P1', found 'blst.P1'"),
            else => |T| {
                switch (@typeInfo(T)) {
                    .pointer => { const s: []const u8 = in; _ = s; },
                    else     => @compileError("expected type '[]const u8', found '" ++ @typeName(T) ++ "'"),
                }

                var ret : P1_Affine = undefined;
                const err = ret.deserialize(in);
                return if (err == .SUCCESS) ret else err.as_error();
            },
        }
        unreachable;
    }

    pub fn deserialize(self: *P1_Affine, in: []const u8) ERROR {
        if (in.len == 0) {
            return .BAD_ENCODING;
        }
        const expected = @as(usize, if (in[0]&0x80 != 0) P1_COMPRESS_BYTES
                                    else                 P1_SERIALIZE_BYTES);
        if (in.len != expected) {
            return .BAD_ENCODING;
        }
        const err = c.blst_p1_deserialize(&self.point, &in[0]);
        return @as(ERROR, @enumFromInt(err));
    }

    pub fn serialize(self: *const P1_Affine) [P1_SERIALIZE_BYTES]u8 {
        var ret : [P1_SERIALIZE_BYTES]u8 = undefined;
        c.blst_p1_affine_serialize(&ret[0], &self.point);
        return ret;
    }

    pub fn compress(self: *const P1_Affine) [P1_COMPRESS_BYTES]u8 {
        var ret : [P1_COMPRESS_BYTES]u8 = undefined;
        c.blst_p1_affine_compress(&ret[0], &self.point);
        return ret;
    }

    pub fn dup(self: *const P1_Affine) P1_Affine {
        return P1_Affine {
            .point = self.point,
        };
    }

    pub fn on_curve(self: *const P1_Affine) bool {
        return c.blst_p1_affine_on_curve(&self.point);
    }

    pub fn in_group(self: *const P1_Affine) bool {
        return c.blst_p1_affine_in_group(&self.point);
    }

    pub fn is_inf(self: *const P1_Affine) bool {
        return c.blst_p1_affine_is_inf(&self.point);
    }

    pub fn is_equal(self: *const P1_Affine, p: *const P1_Affine) bool {
        return c.blst_p1_affine_is_equal(&self.point, &p.point);
    }

    pub fn core_verify(self: *const P1_Affine, pk: *const P2_Affine,
                       hash_or_encode: bool, msg: []const u8, DST: []const u8,
                       aug: ?[]const u8) ERROR {
        const opt = aug orelse &[_]u8{};
        const err = c.blst_core_verify_pk_in_g2(&pk.point, &self.point,
                                                hash_or_encode,
                                                @ptrCast(msg), msg.len,
                                                @ptrCast(DST), DST.len,
                                                @ptrCast(opt), opt.len);
        return @as(ERROR, @enumFromInt(err));
    }

    pub fn generator() P1_Affine {
        return P1_Affine {
            .point = c.blst_p1_affine_generator().*,
        };
    }

    pub fn to_jacobian(self: *const P1_Affine) P1 {
        var ret : P1 = undefined;
        c.blst_p1_from_affine(&ret.point, &self.point);
        return ret;
    }
};

pub const P1 = struct {
    point : c.blst_p1 = c.blst_p1{},

    pub fn from(in: anytype) !P1 {
        switch (@TypeOf(in)) {
            *const SecretKey,
            *SecretKey  => return P1.public_key(in),
            SecretKey   => @compileError("expected type '*const blst.SecretKey', found 'blst.SecretKey'"),
            *const P1_Affine,
            *P1_Affine  => return in.to_jacobian(),
            P1_Affine   => @compileError("expected type '*const blst.P1_Affine', found 'blst.P1_Affine'"),
            else        => |T| {
                switch (@typeInfo(T)) {
                    .pointer => { const s: []const u8 = in; _ = s; },
                    else     => @compileError("expected type '[]const u8', found '" ++ @typeName(T) ++ "'"),
                }

                var ret : P1 = undefined;
                const err = ret.deserialize(in);
                return if (err == .SUCCESS) ret else err.as_error();
            },
        }
        unreachable;
    }

    pub fn deserialize(self: *P1, in: []const u8) ERROR {
        if (in.len == 0) {
            return .BAD_ENCODING;
        }
        const expected = @as(usize, if (in[0]&0x80 != 0) P1_COMPRESS_BYTES
                                    else                 P1_SERIALIZE_BYTES);
        if (in.len != expected) {
            return .BAD_ENCODING;
        }
        const err = c.blst_p1_deserialize(@ptrCast(&self.point), &in[0]);
        if (err == c.BLST_SUCCESS) {
            c.blst_p1_from_affine(&self.point, @ptrCast(&self.point));
        }
        return @as(ERROR, @enumFromInt(err));
    }

    pub fn serialize(self: *const P1) [P1_SERIALIZE_BYTES]u8 {
        var ret : [P1_SERIALIZE_BYTES]u8 = undefined;
        c.blst_p1_serialize(&ret[0], &self.point);
        return ret;
    }

    pub fn compress(self: *const P1) [P1_COMPRESS_BYTES]u8 {
        var ret : [P1_COMPRESS_BYTES]u8 = undefined;
        c.blst_p1_compress(&ret[0], &self.point);
        return ret;
    }

    pub fn public_key(sk: *const SecretKey) P1 {
        var ret : P1 = undefined;
        c.blst_sk_to_pk_in_g1(&ret.point, &sk.key);
        return ret;
    }

    pub fn dup(self: *const P1) P1 {
        return self.*;
    }

    pub fn on_curve(self: *const P1) bool {
        return c.blst_p1_on_curve(&self.point);
    }

    pub fn in_group(self: *const P1) bool {
        return c.blst_p1_in_group(&self.point);
    }

    pub fn is_inf(self: *const P1) bool {
        return c.blst_p1_is_inf(&self.point);
    }

    pub fn is_equal(self: *const P1, p: *const P1) bool {
        return c.blst_p1_is_equal(&self.point, &p.point);
    }

    pub fn aggregate(self: *P1, p: *const P1_Affine) !void {
        if (!c.blst_p1_affine_in_g1(p)) {
            return Error.POINT_NOT_IN_GROUP;
        }
        c.blst_p1_add_or_double_affine(&self.point, &self.point, &p.point);
    }

    pub fn hash_to(msg: []const u8, DST: []const u8, aug: ?[]const u8) P1 {
        const opt = aug orelse &[_]u8{};
        var ret : P1 = undefined;

        c.blst_hash_to_g1(&ret.point, @ptrCast(msg), msg.len,
                                      @ptrCast(DST), DST.len,
                                      @ptrCast(opt), opt.len);
        return ret;
    }

    pub fn encode_to(msg: []const u8, DST: []const u8, aug: ?[]const u8) P1 {
        const opt = aug orelse &[_]u8{};
        var ret : P1 = undefined;

        c.blst_encode_to_g1(&ret.point, @ptrCast(msg), msg.len,
                                        @ptrCast(DST), DST.len,
                                        @ptrCast(opt), opt.len);
        return ret;
    }

    pub fn sign_with(self: *const P1, sk: *const SecretKey) *P1 {
        c.blst_sign_pk_in_g2(@constCast(&self.point), &self.point, &sk.key);
        return @constCast(self);
    }

    pub fn to_affine(self: *const P1) P1_Affine {
        var ret : P1_Affine = undefined;
        c.blst_p1_to_affine(&ret.point, &self.point);
        return ret;
    }

    pub fn generator() P1 {
        return P1 {
            .point = c.blst_p1_generator().*,
        };
    }
};
"""


def xchg_1vs2(matchobj):
    if matchobj.group(2) == '1':
        return matchobj.group(1) + '2'
    else:
        return matchobj.group(1) + '1'


with open("blst.zig", "w") as fd:
    print("//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!", file=fd)
    print("// DO NOT EDIT THIS FILE!!!",                         file=fd)
    print("// The file is auto-generated by " + here[-1],        file=fd)
    print("//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!", file=fd)
    print(root_zig,                                              file=fd)
    print(p1_zig,                                                file=fd)
    print(re.sub(r'((?<!f)[pgPG\*])([12])', xchg_1vs2, p1_zig),  file=fd)

print("generating build.zig.zon...") or sys.stdout.flush()
os.chdir("../..")
zon = """.{
    .name = .blst,
    .version = "0.3.16",
    .minimum_zig_version = "0.14.0",
    .paths = .{
        "build.zig",
        "build.zig.zon",
        "bindings/zig",
        "src",
        "build",
    },
"""
with open("build.zig.zon", "w") as fd:
    print(zon, end='', file=fd)
    print("}", file=fd)

ret = subprocess.run(["zig", "build"], capture_output=True, text=True)
match = re.search(r'suggested value:\s*(\w+)', ret.stderr)
if match:
    with open("build.zig.zon", "w") as fd:
        print(zon, end='', file=fd)
        print("    .fingerprint = {},".format(match.group(1)), file=fd)
        print("}", file=fd)
else:
    print("don't know what to do")
