const std = @import("std");

const task_01 = @import("./01/solution.zig");
const task_02 = @import("./02/solution.zig");
const task_03 = @import("./03/solution.zig");
const task_04 = @import("./04/solution.zig");

const in_01 = @embedFile("./01/in.txt");
const in_02 = @embedFile("./02/in.txt");
const in_03 = @embedFile("./03/in.txt");
const in_04 = @embedFile("./04/in.txt");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const status = gpa.deinit();
        std.debug.assert(status == .ok);
    }

    var args = try std.process.argsWithAllocator(allocator);
    defer args.deinit();
    std.debug.assert(args.skip());

    const task_n = try std.fmt.parseInt(
        u16,
        args.next() orelse unreachable,
        10,
    );

    try switch (task_n) {
        1 => solveAlloc(allocator, task_01, in_01),
        2 => solveAlloc(allocator, task_02, in_02),
        3 => solve(task_03, in_03, false),
        4 => solve(task_04, in_04, false),
        else => unreachable,
    };
}

fn solve(comptime task: anytype, comptime in: []const u8, comptime in_comptime: bool) !void {
    if (in_comptime) {
        @setEvalBranchQuota(1_000_000);
        print(1, comptime try task.@"1"(in));
        print(2, comptime try task.@"2"(in));
    } else {
        print(1, try task.@"1"(in));
        print(2, try task.@"2"(in));
    }
}

fn solveAlloc(allocator: std.mem.Allocator, comptime task: anytype, in: []const u8) !void {
    print(1, try task.@"1"(allocator, in));
    print(2, try task.@"2"(allocator, in));
}

fn print(comptime n: comptime_int, answer: u64) void {
    std.debug.print(
        "Answer {d}: {d}\n",
        .{
            .n = n,
            .answer = answer,
        },
    );
}
