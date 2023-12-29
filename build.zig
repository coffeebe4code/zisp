const std = @import("std");

const Source = struct { []const u8, []const u8, []const []const u8 };
const sources = [_]Source{
    .{ "token", "libs/token/root.zig", &.{} },
    .{ "ast", "libs/ast/root.zig", &.{ "token", "span" } },
    .{ "span", "libs/span/root.zig", &.{"token"} },
    .{ "lexer", "libs/lexer/root.zig", &.{ "token", "span" } },
};

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});
    const exe = b.addExecutable(.{
        .name = "zisp",
        .root_source_file = .{ .path = "src/zisp.zig" },
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(exe);

    const mods = blk: {
        var map = std.StringHashMap(*std.Build.Module).init(b.allocator);
        try map.ensureTotalCapacity(sources.len);
        for (sources) |src| {
            const name, const path, _ = src;
            const mod = b.createModule(.{ .source_file = .{ .path = path } });
            map.putAssumeCapacity(name, mod);
        }

        for (sources) |src| {
            const name, _, const deps = src;
            const mod = map.get(name).?;
            for (deps) |dep_name| {
                try mod.dependencies.put(dep_name, map.get(dep_name).?);
            }
        }

        break :blk map;
    };

    const test_all = b.step("test", "Run all tests");
    for (sources) |src| {
        const name, const path, const deps = src;

        const mod_test = b.addTest(.{
            .name = name,
            .root_source_file = .{ .path = path },
            .target = target,
            .optimize = optimize,
        });

        for (deps) |dep_name| {
            const mod = mods.get(dep_name).?;
            mod_test.addModule(dep_name, mod);
        }

        const run_unit_tests = b.addRunArtifact(mod_test);
        test_all.dependOn(&run_unit_tests.step);
    }
}
