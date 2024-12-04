const std = @import("std");

const task_01 = @import("./01/solution.zig");
const task_02 = @import("./02/solution.zig");
const task_03 = @import("./03/solution.zig");

const in_01 = @embedFile("./01/in.txt");
const in_02 = @embedFile("./02/in.txt");
const in_03 = @embedFile("./03/in.txt");

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
        1 => solve(task_01, in_01, allocator),
        2 => solve(task_02, in_02, allocator),
        3 => solve(task_03, in_03, allocator),
        else => unreachable,
    };
}

fn solve(comptime task: anytype, in: []const u8, allocator: std.mem.Allocator) !void {
    std.debug.print(
        "Answer 1: {d}\n",
        .{
            .answer = try task.@"1"(in, allocator),
        },
    );
    std.debug.print(
        "Answer 2: {d}\n",
        .{
            .answer = try task.@"2"(in, allocator),
        },
    );
}
