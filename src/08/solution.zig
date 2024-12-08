const std = @import("std");

const Grid = @import("../Grid.zig");
const Node = Grid.Node;

pub fn @"1"(in: []const u8) !u64 {
    var grid = Grid.init(in);
    var seen = [_][grid.Y]bool{
        [_]bool{false} ** grid.Y,
    } ** grid.X;

    var ix = grid.iter();
    while (ix.next()) |nx| {
        if (nx.c == '.') continue;
        var iy = ix.clone();
        while (iy.next()) |ny| {
            if (ny.c != nx.c) continue;
            if (getAntinode(grid, nx, ny, 1)) |an| {
                seen[an.x][an.y] = true;
            }
            if (getAntinode(grid, ny, nx, 1)) |an| {
                seen[an.x][an.y] = true;
            }
        }
    }

    var answer = 0;
    for (0..grid.X) |x| {
        for (0..grid.Y) |y| {
            if (seen[x][y]) answer += 1;
        }
    }
    return answer;
}

pub fn @"2"(in: []const u8) !u64 {
    var grid = Grid.init(in);
    var seen = [_][grid.Y]bool{
        [_]bool{false} ** grid.Y,
    } ** grid.X;

    var ix = grid.iter();
    while (ix.next()) |nx| {
        if (nx.c == '.') continue;
        var iy = ix.clone();
        while (iy.next()) |ny| {
            if (ny.c != nx.c) continue;
            var i = 0;
            while (getAntinode(grid, nx, ny, i)) |an| : (i += 1) {
                seen[an.x][an.y] = true;
            }
            var j = 0;
            while (getAntinode(grid, ny, nx, j)) |an| : (j += 1) {
                seen[an.x][an.y] = true;
            }
        }
    }

    var answer = 0;
    for (0..grid.X) |x| {
        for (0..grid.Y) |y| {
            if (seen[x][y]) answer += 1;
        }
    }
    return answer;
}

fn getAntinode(grid: Grid, a: Node, b: Node, distance: isize) ?Node {
    const cx = a.x + distance * (a.x - b.x);
    const cy = a.y + distance * (a.y - b.y);
    if (grid.get(cx, cy)) |c| {
        return .{
            .x = cx,
            .y = cy,
            .c = c,
        };
    }
    return null;
}

test {
    const in = @embedFile("in_test.txt");

    comptime {
        @setEvalBranchQuota(100_000);
        try std.testing.expectEqual(14, try @"1"(in));
        try std.testing.expectEqual(34, try @"2"(in));
    }
}
