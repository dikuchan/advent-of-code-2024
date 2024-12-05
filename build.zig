const std = @import("std");

pub fn build(b: *std.Build) void {
    const exe = b.addExecutable(.{
        .name = "aoc",
        .root_source_file = b.path("src/main.zig"),
        .target = b.host,
    });

    const options = b.addOptions();
    options.addOption(
        u32,
        "task_n",
        b.option(u32, "task", "Task number") orelse 0,
    );
    exe.root_module.addOptions("options", options);

    b.installArtifact(exe);

    const tests = b.addTest(.{
        .root_source_file = b.path("src/tests.zig"),
        .target = b.host,
    });
    const run_tests = b.addRunArtifact(tests);

    const run_tests_step = b.step("test", "Run tests");
    run_tests_step.dependOn(&run_tests.step);
}
