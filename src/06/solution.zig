const std = @import("std");

const Grid = @import("../Grid.zig");

const N = 100;

pub fn @"1"(in: []const u8) !u64 {
    const grid = Grid.init(in);
    var guard = findGuard(grid);
    var seen = StaticSet(u64, N * grid.X * grid.Y).init();
    var answer: u64 = 0;
    while (guard.step(grid, -1, -1)) {
        if (!seen.contains(.{ guard.x, guard.y })) {
            answer += 1;
        }
        seen.add(.{ guard.x, guard.y });
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
    var seen = StaticSet(u64, N * grid.X * grid.Y).init();
    while (guard.step(grid, ex, ey)) {
        if (seen.contains(.{ guard.x, guard.y, @intFromEnum(guard.direction) })) {
            return true;
        }
        seen.add(.{ guard.x, guard.y, @intFromEnum(guard.direction) });
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

    fn goForward(self: *Self) void {
        switch (self.direction) {
            .left => self.x -= 1,
            .up => self.y -= 1,
            .right => self.x += 1,
            .down => self.y += 1,
        }
    }

    fn goBack(self: *Self) void {
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
        self.goForward();
        if (grid.get(self.x, self.y)) |c| {
            if (c == obstacle or (self.x == ex and self.y == ey)) {
                self.goBack();
                self.rotate();
            }
            return true;
        } else {
            return false;
        }
    }
};

fn StaticSet(comptime T: type, comptime size: usize) type {
    return struct {
        const Self = @This();

        data: [size]bool = [_]bool{false} ** size,

        fn init() Self {
            return .{};
        }

        fn add(self: *Self, xs: anytype) void {
            var hash: T = 0;
            for (xs) |x| {
                hash = hashCombine(hash, x);
            }
            self.data[hash % size] = true;
        }

        fn contains(self: Self, xs: anytype) bool {
            var hash: T = 0;
            for (xs) |x| {
                hash = hashCombine(hash, x);
            }
            return self.data[hash % size];
        }

        fn hashCombine(seed: T, x: T) u64 {
            return seed ^ x + 0x9e3779b9 + (seed << 6) + (seed >> 2);
        }
    };
}

test {
    const in = @embedFile("in_test.txt");

    comptime {
        @setEvalBranchQuota(100_000);
        try std.testing.expectEqual(41, try @"1"(in));
        try std.testing.expectEqual(6, try @"2"(in));
    }
}
