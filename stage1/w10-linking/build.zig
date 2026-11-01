const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const math_lib = b.addLibrary(.{
        .name = "math",
        .linkage = .static,
        .root_module = b.createModule(.{
            .root_source_file = b.path("math.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    const exec = b.addExecutable(.{
        .name = "app",
        .root_module = b.createModule(.{
            .root_source_file = b.path("main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    const translate_c = b.addTranslateC(.{
        .root_source_file = b.path("math.h"),
        .target = target,
        .optimize = optimize,
    });

    exec.root_module.addImport("c", translate_c.createModule());
    exec.root_module.linkLibrary(math_lib);

    b.installArtifact(exec);
}
