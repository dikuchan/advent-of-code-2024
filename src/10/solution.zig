const std = @import("std");

const Grid = @import("../Grid.zig");

pub fn @"1"(in: []const u8) !u64 {
    const grid = Grid.init(in);
    var answer = 0;
    var i = grid.iter();
    while (i.next()) |node| {
        if (node.c != '0') continue;
        var seen = [_]bool{false} ** (grid.X * grid.Y);
        find1(grid, node.x, node.y, &seen);
        answer += count(&seen);
    }
    return answer;
}

pub fn @"2"(in: []const u8) !u64 {
    const grid = Grid.init(in);
    var answer = 0;
    var i = grid.iter();
    while (i.next()) |node| {
        if (node.c != '0') continue;
        answer += find2(grid, node.x, node.y);
    }
    return answer;
}

const directions = [_]struct {
    dx: isize = 0,
    dy: isize = 0,
}{
    .{ .dx = 1 },
    .{ .dx = -1 },
    .{ .dy = 1 },
    .{ .dy = -1 },
};

fn find1(grid: Grid, ix: isize, iy: isize, seen: []bool) void {
    const h = grid.get(ix, iy).?;
    if (h == '9') {
        seen[ix * grid.X + iy] = true;
        return;
    }
    for (directions) |direction| {
        const x = ix + direction.dx;
        const y = iy + direction.dy;
        if (grid.get(x, y)) |nh| {
            if (nh != h + 1) continue;
            find1(grid, x, y, seen);
        }
    }
}

fn count(seen: []const bool) u64 {
    var r = 0;
    for (seen) |c| {
        if (c) r += 1;
    }
    return r;
}

fn find2(grid: Grid, ix: isize, iy: isize) u64 {
    const h = grid.get(ix, iy).?;
    if (h == '9') {
        return 1;
    }
    var r = 0;
    for (directions) |direction| {
        const x = ix + direction.dx;
        const y = iy + direction.dy;
        if (grid.get(x, y)) |nh| {
            if (nh != h + 1) continue;
            r += find2(grid, x, y);
        }
    }
    return r;
}

test {
    const in = @embedFile("in_test.txt");

    comptime {
        @setEvalBranchQuota(100_000);
        try std.testing.expectEqual(36, try @"1"(in));
        try std.testing.expectEqual(81, try @"2"(in));
    }
}
