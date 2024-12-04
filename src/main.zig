const std = @import("std");

const task_n = @import("options").task_n;

pub fn main() !void {
    const answer = comptime blk: {
        try switch (task_n) {
            1 => break :blk try solve(@import("./01/solution.zig")),
            3 => break :blk try solve(@import("./03/solution.zig")),
            4 => break :blk try solve(@import("./04/solution.zig")),
            else => @compileError("no such task"),
        };
    };
    answer.print();
}

const Answer = struct {
    @"1": u64,
    @"2": u64,

    fn print(answer: Answer) void {
        std.debug.print(
            "1: {d}\n2: {d}\n",
            .{
                .@"1" = answer.@"1",
                .@"2" = answer.@"2",
            },
        );
    }
};

fn solve(comptime task: anytype) !Answer {
    @setEvalBranchQuota(100_000_000);

    const in = @embedFile(std.fmt.comptimePrint(
        "./{d:0>2}/in.txt",
        .{ .task_n = task_n },
    ));

    return Answer{
        .@"1" = try task.@"1"(in),
        .@"2" = try task.@"2"(in),
    };
}
