const std = @import("std");

const Grid = @import("../Grid.zig");

pub fn @"1"(in: []const u8) !u64 {
    const grid = Grid.init(in);
    var seen = [_][grid.Y]bool{
        [_]bool{false} ** grid.Y,
    } ** grid.X;
    var guard = findGuard(grid);

    var answer: u64 = 0;
    while (guard.step(grid, -1, -1)) {
        if (!seen[guard.x][guard.y]) {
            answer += 1;
        }
        seen[guard.x][guard.y] = true;
    }
    return answer;
}

pub fn @"2"(in: []const u8) !u64 {
    const grid = Grid.init(in);
    const guard = findGuard(grid);

    var answer: u64 = 0;
    for (0..grid.X) |x| {
        for (0..grid.Y) |y| {
            if (guard.x == x and guard.y == y) {
                continue;
            }
            if (grid.get(x, y).? == obstacle) {
                continue;
            }
            if (checkLoop(grid, guard, x, y)) {
                answer += 1;
            }
        }
    }
    return answer;
}

fn checkLoop(grid: Grid, i: Guard, ex: usize, ey: usize) bool {
    var guard = i;
    var seen = [_][grid.Y][4]bool{
        [_][4]bool{
            [_]bool{false} ** 4,
        } ** grid.Y,
    } ** grid.X;
    while (guard.step(grid, ex, ey)) {
        const direction: usize = @intFromEnum(guard.direction);
        if (seen[guard.x][guard.y][direction]) {
            return true;
        }
        seen[guard.x][guard.y][direction] = true;
    }
    return false;
}

const obstacle = '#';

fn findGuard(grid: Grid) Guard {
    for (0..grid.X) |x| {
        for (0..grid.Y) |y| {
            switch (grid.get(x, y).?) {
                '<' => return .{ .x = x, .y = y, .direction = .left },
                '^' => return .{ .x = x, .y = y, .direction = .up },
                '>' => return .{ .x = x, .y = y, .direction = .right },
                'v' => return .{ .x = x, .y = y, .direction = .down },
                else => continue,
            }
        }
    }
}

const Directon = enum {
    left,
    up,
    right,
    down,
};

const Guard = struct {
    const Self = @This();

    x: isize,
    y: isize,
    direction: Directon,

    fn stepForward(self: *Self) void {
        switch (self.direction) {
            .left => self.x -= 1,
            .up => self.y -= 1,
            .right => self.x += 1,
            .down => self.y += 1,
        }
    }

    fn stepBack(self: *Self) void {
        switch (self.direction) {
            .left => self.x += 1,
            .up => self.y += 1,
            .right => self.x -= 1,
            .down => self.y -= 1,
        }
    }

    fn rotate(self: *Self) void {
        self.direction = switch (self.direction) {
            .left => .up,
            .up => .right,
            .right => .down,
            .down => .left,
        };
    }

    fn step(self: *Self, grid: Grid, ex: isize, ey: isize) bool {
        self.stepForward();
        if (grid.get(self.x, self.y)) |c| {
            if (c == obstacle or (self.x == ex and self.y == ey)) {
                self.stepBack();
                self.rotate();
            }
            return true;
        } else {
            return false;
        }
    }
};

test {
    const in = @embedFile("in_test.txt");

    comptime {
        @setEvalBranchQuota(100_000);
        try std.testing.expectEqual(41, try @"1"(in));
        try std.testing.expectEqual(6, try @"2"(in));
    }
}
