const std = @import("std");

const @"01" = @import("./01/solution.zig").Solution;
const @"02" = @import("./02/solution.zig").Solution;
const @"03" = @import("./03/solution.zig").Solution;

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
        1 => solve(allocator, @"01"),
        2 => solve(allocator, @"02"),
        3 => solve(allocator, @"03"),
        else => unreachable,
    };
}

fn solve(allocator: std.mem.Allocator, comptime task: anytype) !void {
    std.debug.print(
        "Answer 1: {d}\n",
        .{
            .answer = try task.@"1"(allocator),
        },
    );
    std.debug.print(
        "Answer 2: {d}\n",
        .{
            .answer = try task.@"2"(allocator),
        },
    );
}
