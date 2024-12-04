const std = @import("std");

const LineReader = @import("../utils.zig").LineReader;

pub fn @"1"(in: []const u8, allocator: std.mem.Allocator) !u64 {
    var answer: u64 = 0;
    var reader = LineReader.init(in);
    var buffer: [1024]u8 = undefined;
    while (try reader.readLine(&buffer)) |line| {
        var iter = std.mem.splitSequence(u8, line, " ");
        var xs = std.ArrayList(i64).init(allocator);
        defer xs.deinit();
        while (iter.next()) |s| {
            const x = try std.fmt.parseInt(i64, s, 10);
            try xs.append(x);
        }
        if (try check(allocator, xs.items)) {
            answer += 1;
        }
    }
    return answer;
}

pub fn @"2"(in: []const u8, allocator: std.mem.Allocator) !u64 {
    var answer: u64 = 0;
    var reader = LineReader.init(in);
    var buffer: [1024]u8 = undefined;
    while (try reader.readLine(&buffer)) |line| {
        var iter = std.mem.splitSequence(u8, line, " ");
        var xs = std.ArrayList(i64).init(allocator);
        defer xs.deinit();
        while (iter.next()) |s| {
            const x = try std.fmt.parseInt(i64, s, 10);
            try xs.append(x);
        }
        for (0..xs.items.len) |i| {
            var ys = std.ArrayList(i64).init(allocator);
            defer ys.deinit();
            for (0.., xs.items) |j, x| {
                if (i != j) {
                    try ys.append(x);
                }
            }
            if (try check(allocator, ys.items)) {
                answer += 1;
                break;
            }
        }
    }
    return answer;
}

fn check_bounds(xs: []const i64, lower: i64, upper: i64) bool {
    for (xs) |x| {
        if (x < lower or x > upper) {
            return false;
        }
    }
    return true;
}

fn check(allocator: std.mem.Allocator, xs: []const i64) !bool {
    std.debug.assert(xs.len > 0);

    var z = xs[0];
    var deltas = std.ArrayList(i64).init(allocator);
    defer deltas.deinit();

    for (xs[1..]) |x| {
        try deltas.append(x - z);
        z = x;
    }

    if (check_bounds(deltas.items, 1, 3)) {
        return true;
    }
    if (check_bounds(deltas.items, -3, -1)) {
        return true;
    }
    return false;
}

test {
    const in = @embedFile("in_test.txt");
    const allocator = std.testing.allocator;

    try std.testing.expect(try @"1"(in, allocator) == 2);
    try std.testing.expect(try @"2"(in, allocator) == 4);
}
