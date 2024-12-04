const std = @import("std");

const common = @import("../common.zig");

pub fn @"1"(in: []const u8) common.Error!u64 {
    const n = common.countLines(in);

    var xs = common.array(u64, n);
    var ys = common.array(u64, n);

    try parseIn(in, n, &xs, &ys);

    std.mem.sort(u64, &xs, {}, std.sort.asc(u64));
    std.mem.sort(u64, &ys, {}, std.sort.asc(u64));

    var answer = 0;
    for (xs, ys) |x, y| {
        if (x > y) {
            answer += x - y;
        } else {
            answer += y - x;
        }
    }
    return answer;
}

pub fn @"2"(in: []const u8) common.Error!u64 {
    const n = common.countLines(in);

    var xs = common.array(u64, n);
    var ys = common.array(u64, n);

    try parseIn(in, n, &xs, &ys);

    var max = 0;
    for (ys) |y| {
        if (y > max) {
            max = y;
        }
    }
    var counts = common.array(u64, max + 1);
    for (ys) |y| {
        counts[y] += 1;
    }

    var answer = 0;
    for (xs) |x| {
        const count = counts[x];
        answer += x * count;
    }
    return answer;
}

fn parseIn(s: []const u8, n: usize, xs: []u64, ys: []u64) common.Error!void {
    var position = 0;
    for (0..n) |i| {
        const x = try common.parseNumber(s, position);
        xs[i] = x.value;
        position = try common.parseIdentifier(s, x.position, "   ");
        const y = try common.parseNumber(s, position);
        ys[i] = y.value;
        position = try common.parseIdentifier(s, y.position, "\n");
    }
}

test {
    const in = @embedFile("in_test.txt");

    comptime {
        try std.testing.expectEqual(11, try @"1"(in));
        try std.testing.expectEqual(31, try @"2"(in));
    }
}
