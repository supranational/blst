# blst for [Zig](https://ziglang.org/)

The object-oriented interface is modeled after [C++ interface](../blst.hpp), but for the moment of this writing is a subset of it, sufficient to produce and verify individual and aggregated signatures. See [tests.zig](tests.zig) for usage examples. C symbols are available with `blst.c.` prefix instead of `blst_`, e.g. `blst_pairing_sizeof` is accessible as `blst.c.pairing_sizeof`.

## Adding dependency to your project

Execute
```
zig fetch --save git+https://github.com/dot-asm/blst#zig-bindings
```
and add an equivalent of the following line to your build.zig prior to `b.installArtifact(exe)`:
```
exe.root_module.addImport("blst", b.dependency("blst", .{}).module("blst"));
```
You should now be able to `@import("blst")` in your application code. The abovementioned fetch command can be used to update the git reference.
