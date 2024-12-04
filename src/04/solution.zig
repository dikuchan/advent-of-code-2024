const std = @import("std");

const Error = error{};

pub fn @"1"(in: []const u8, _: std.mem.Allocator) Error!u64 {
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
    const board = Board.init(in);
    for (0..board.X) |x| {
        for (0..board.Y) |y| {
            for (directions) |direction| {
                if (find(board, x, y, "XMAS", direction)) {
                    answer += 1;
                }
            }
        }
    }
    return answer;
}

pub fn @"2"(in: []const u8, _: std.mem.Allocator) Error!u64 {
    var answer: u64 = 0;
    const board = Board.init(in);
    for (0..board.X) |x| {
        for (0..board.Y) |y| {
            if (findMAS(board, x, y, .@"135", .@"315") and findMAS(board, x, y, .@"45", .@"225")) {
                answer += 1;
            }
        }
    }
    return answer;
}

const Board = struct {
    X: usize,
    Y: usize,
    data: []const u8,

    fn init(data: []const u8) Board {
        var X: usize = 0;
        var Y: usize = 0;
        for (0.., data) |i, c| {
            if (c == '\n') {
                if (X == 0) {
                    X = i;
                }
                Y += 1;
            }
        }
        return .{
            .X = X,
            .Y = Y,
            .data = data,
        };
    }

    fn get(board: Board, ix: isize, iy: isize) ?u8 {
        if (ix < 0 or iy < 0) {
            return null;
        }
        const x: usize = @intCast(ix);
        const y: usize = @intCast(iy);
        if (x >= board.X or y >= board.Y) {
            return null;
        }
        return board.data[x + (board.X + 1) * y];
    }
};

const Direction = union(enum) {
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
    board: Board,
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
        if (board.get(ix + dx, iy + dy) != c) {
            return false;
        }
    }
    return true;
}

fn findMAS(
    board: Board,
    x: usize,
    y: usize,
    p: Direction,
    q: Direction,
) bool {
    if (find(board, x, y, "AM", p) and find(board, x, y, "AS", q)) {
        return true;
    }
    if (find(board, x, y, "AS", p) and find(board, x, y, "AM", q)) {
        return true;
    }
    return false;
}

test {
    const in = @embedFile("in_test.txt");
    const allocator = std.testing.allocator;

    try std.testing.expectEqual(18, try @"1"(in, allocator));
    try std.testing.expectEqual(9, try @"2"(in, allocator));
}
