const std = @import("std");

const Grid = @import("../Grid.zig");

pub fn @"1"(in: []const u8) !u64 {
    var answer: u64 = 0;
    const directions = [_]Direction{
        .@"0",
        .@"45",
        .@"90",
        .@"135",
        .@"180",
        .@"225",
        .@"270",
        .@"315",
    };
    const grid = Grid.init(in);
    for (0..grid.X) |x| {
        for (0..grid.Y) |y| {
            for (directions) |direction| {
                if (find(grid, x, y, "XMAS", direction)) {
                    answer += 1;
                }
            }
        }
    }
    return answer;
}

pub fn @"2"(in: []const u8) !u64 {
    var answer: u64 = 0;
    const grid = Grid.init(in);
    for (0..grid.X) |x| {
        for (0..grid.Y) |y| {
            if (findMAS(grid, x, y, .@"135", .@"315") and findMAS(grid, x, y, .@"45", .@"225")) {
                answer += 1;
            }
        }
    }
    return answer;
}

const Direction = enum {
    @"0",
    @"45",
    @"90",
    @"135",
    @"180",
    @"225",
    @"270",
    @"315",
};

fn find(
    grid: Grid,
    x: usize,
    y: usize,
    word: []const u8,
    direction: Direction,
) bool {
    const d: struct {
        dx: isize = 0,
        dy: isize = 0,
    } = switch (direction) {
        .@"0" => .{ .dy = 1 },
        .@"45" => .{ .dx = 1, .dy = 1 },
        .@"90" => .{ .dx = 1 },
        .@"135" => .{ .dx = 1, .dy = -1 },
        .@"180" => .{ .dy = -1 },
        .@"225" => .{ .dx = -1, .dy = -1 },
        .@"270" => .{ .dx = -1 },
        .@"315" => .{ .dx = -1, .dy = 1 },
    };
    for (0.., word) |i, c| {
        const dx = @as(isize, @intCast(i)) * d.dx;
        const dy = @as(isize, @intCast(i)) * d.dy;
        const ix: isize = @intCast(x);
        const iy: isize = @intCast(y);
        if (grid.get(ix + dx, iy + dy) != c) {
            return false;
        }
    }
    return true;
}

fn findMAS(
    grid: Grid,
    x: usize,
    y: usize,
    p: Direction,
    q: Direction,
) bool {
    if (find(grid, x, y, "AM", p) and find(grid, x, y, "AS", q)) {
        return true;
    }
    if (find(grid, x, y, "AS", p) and find(grid, x, y, "AM", q)) {
        return true;
    }
    return false;
}

test {
    const in = @embedFile("in_test.txt");

    comptime {
        @setEvalBranchQuota(10_000);
        try std.testing.expectEqual(18, try @"1"(in));
        try std.testing.expectEqual(9, try @"2"(in));
    }
}
