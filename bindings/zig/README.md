# blst for [Zig](https://ziglang.org/)

The object-oriented interface is modeled after [C++ interface](../blst.hpp), but for the moment of this writing is a subset of it, sufficient to produce and verify individual signatures.

## Adding dependency to your project

Execute
```
zig fetch --save git+https://github.com/dot-asm/blst#zig-bindings
```
and add an equivalent of the following line to your build.zig prior to `b.installArtifact(exe)`:
```
exe.root_module.addImport("blst", b.dependency("blst", .{}).module("blst"));
```
You should now be able to `@import("blst")` in your application code. The abovementioned fetch command can be used to update the reference.
