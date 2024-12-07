const std = @import("std");

const Parser = @import("../Parser.zig");

const N = 100;

const Map = [N][N]bool;

pub fn @"1"(in: []const u8) !u64 {
    return @"12"(in, check);
}

pub fn @"2"(in: []const u8) !u64 {
    return @"12"(in, checkOrFix);
}

fn @"12"(in: []const u8, checker: fn ([]u64, Map) u64) !u64 {
    var parser = Parser.init(in);

    var rn: usize = 0;
    while (parser.peek()) |c| {
        if (c == '\n') {
            if (parser.prev() == '\n') {
                break;
            }
            rn += 1;
        }
        parser.skip();
    }

    var lowers = [_]u64{0} ** rn;
    var uppers = [_]u64{0} ** rn;

    parser.seek(0);

    for (0..rn) |i| {
        lowers[i] = try parser.parseNumber();
        try parser.parseChar('|');
        uppers[i] = try parser.parseNumber();
        try parser.parseChar('\n');
    }
    try parser.parseChar('\n');

    var rd = [_][N]bool{
        [_]bool{false} ** N,
    } ** N;
    for (0..rn) |i| {
        const lower = lowers[i];
        const upper = uppers[i];
        (&rd[upper])[lower] = true;
    }

    var answer: u64 = 0;
    while (!parser.eof()) {
        var xs = [_]u64{0} ** try parser.getNumberLineLen(",");
        parser.parseNumberLine(&xs, ",") catch break;
        answer += checker(&xs, rd);
    }
    return answer;
}

fn check(xs: []const u64, rd: Map) u64 {
    for (0.., xs) |i, upper| {
        const r = rd[upper];
        for (0..i) |j| {
            const lower = xs[j];
            if (!r[lower]) {
                return 0;
            }
        }
    }
    return xs[@divFloor(xs.len, 2)];
}

fn checkOrFix(xs: []u64, rd: Map) u64 {
    if (check(xs, rd) != 0) {
        return 0;
    }
    std.mem.sort(u64, xs, rd, compare);
    return xs[@divFloor(xs.len, 2)];
}

pub fn compare(rd: Map, a: u64, b: u64) bool {
    return rd[a][b];
}

test {
    const in = @embedFile("in_test.txt");

    comptime {
        @setEvalBranchQuota(100_000);
        try std.testing.expectEqual(143, try @"1"(in));
        try std.testing.expectEqual(123, try @"2"(in));
    }
}
