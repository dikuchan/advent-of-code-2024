const std = @import("std");

const common = @import("../common.zig");
const Parser = @import("../parser.zig").Parser;

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
    var lowers = common.array(u64, rn, 0);
    var uppers = common.array(u64, rn, 0);

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
    outer: while (parser.peek() != '\n') {
        var upd = common.array(u64, 32, 0);
        var i: usize = 0;
        while (parser.peek() != '\n') : (i += 1) {
            upd[i] = parser.parseNumber() catch break :outer;
            parser.parseChar(',') catch break;
        }
        answer += checker(upd[0 .. i + 1], rd);
        try parser.parseChar('\n');
    }
    return answer;
}

fn check(upd: []const u64, rd: Map) u64 {
    for (0.., upd) |i, upper| {
        const r = rd[upper];
        for (0..i) |j| {
            const lower = upd[j];
            if (!r[lower]) {
                return 0;
            }
        }
    }
    return upd[@divFloor(upd.len, 2)];
}

fn checkOrFix(upd: []u64, rd: Map) u64 {
    if (check(upd, rd) != 0) {
        return 0;
    }
    std.mem.sort(u64, upd, rd, compare);
    return upd[@divFloor(upd.len, 2)];
}

pub fn compare(rd: Map, a: u64, b: u64) bool {
    if (rd[a][b]) {
        return true;
    }
    return false;
}

test {
    const in = @embedFile("in_test.txt");

    comptime {
        @setEvalBranchQuota(100_000);
        try std.testing.expectEqual(143, try @"1"(in));
        try std.testing.expectEqual(123, try @"2"(in));
    }
}
