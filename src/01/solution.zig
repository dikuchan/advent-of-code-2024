const std = @import("std");

const Parser = @import("../parser.zig").Parser;

pub fn @"1"(in: []const u8) !u64 {
    var parser = Parser.init(in);

    const n = count(&parser, '\n');

    var xs = [_]u64{0} ** n;
    var ys = [_]u64{0} ** n;

    try parse(&parser, n, &xs, &ys);

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

pub fn @"2"(in: []const u8) !u64 {
    var parser = Parser.init(in);

    const n = count(&parser, '\n');

    var xs = [_]u64{0} ** n;
    var ys = [_]u64{0} ** n;

    try parse(&parser, n, &xs, &ys);

    var z = 0;
    for (ys) |y| {
        if (y > z) {
            z = y;
        }
    }
    var cs = [_]u64{0} ** (z + 1);
    for (ys) |y| {
        cs[y] += 1;
    }

    var answer = 0;
    for (xs) |x| {
        answer += x * cs[x];
    }
    return answer;
}

fn parse(parser: *Parser, n: usize, xs: []u64, ys: []u64) !void {
    for (0..n) |i| {
        xs[i] = try parser.parseNumber();
        try parser.parseString("   ");
        ys[i] = try parser.parseNumber();
        try parser.parseChar('\n');
    }
}

fn count(parser: *Parser, c: u8) usize {
    var n: usize = 0;
    while (parser.next()) |e| {
        if (e == c) {
            n += 1;
        }
    }
    parser.seek(0);
    return n;
}

test {
    const in = @embedFile("in_test.txt");

    comptime {
        try std.testing.expectEqual(11, try @"1"(in));
        try std.testing.expectEqual(31, try @"2"(in));
    }
}
