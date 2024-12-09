const std = @import("std");

const task_n = @import("options").task_n;

pub fn main() !void {
    comptime {
        const answer = switch (task_n) {
            1 => solve(@import("./01/solution.zig")),
            2 => solve(@import("./02/solution.zig")),
            3 => solve(@import("./03/solution.zig")),
            4 => solve(@import("./04/solution.zig")),
            5 => solve(@import("./05/solution.zig")),
            6 => solve(@import("./06/solution.zig")),
            7 => solve(@import("./07/solution.zig")),
            8 => solve(@import("./08/solution.zig")),
            9 => solve(@import("./09/solution.zig")),
            else => @compileError("no such task"),
        };
        @compileLog(
            std.fmt.comptimePrint("Answer 1: {d}", .{answer.@"1"}),
        );
        @compileLog(
            std.fmt.comptimePrint("Answer 2: {d}", .{answer.@"2"}),
        );
    }
}

const Answer = struct {
    @"1": u64,
    @"2": u64,
};

fn solve(comptime task: anytype) Answer {
    @setEvalBranchQuota(1_000_000_000);

    const in = @embedFile(std.fmt.comptimePrint("./{d:0>2}/in.txt", .{task_n}));
    return .{
        .@"1" = task.@"1"(in) catch unreachable,
        .@"2" = task.@"2"(in) catch unreachable,
    };
}
