const std = @import("std");

const Parser = @import("../Parser.zig");

pub fn @"1"(in: []const u8) !u64 {
    return solve(in, check);
}

pub fn @"2"(in: []const u8) !u64 {
    return solve(in, checkConcat);
}

fn solve(in: []const u8, checker: fn (u64, u64, []u64) bool) !u64 {
    var parser = Parser.init(in);
    var answer: u64 = 0;
    while (!parser.eof()) {
        const r = try parser.parseNumber();
        try parser.parseChar(':');
        try parser.parseChar(' ');
        var xs = [_]u64{0} ** try parser.getNumberLineLen(" ");
        parser.parseNumberLine(&xs, " ") catch break;
        if (checker(r, 0, &xs)) {
            answer += r;
        }
    }
    return answer;
}

fn check(r: u64, x: u64, xs: []u64) bool {
    if (xs.len == 0) {
        return r == x;
    }
    return check(r, x + xs[0], xs[1..]) or check(r, x * xs[0], xs[1..]);
}

fn checkConcat(r: u64, x: u64, xs: []u64) bool {
    if (xs.len == 0) {
        return r == x;
    }
    return checkConcat(r, x + xs[0], xs[1..]) or checkConcat(r, x * xs[0], xs[1..]) or checkConcat(r, concat(x, xs[0]), xs[1..]);
}

fn concat(x: u64, y: u64) u64 {
    const b: usize = std.math.log10_int(y) + 1;
    const e = std.math.powi(usize, 10, b) catch unreachable;
    return x * e + y;
}

test {
    const in = @embedFile("in_test.txt");

    comptime {
        @setEvalBranchQuota(100_000);
        try std.testing.expectEqual(3749, try @"1"(in));
        try std.testing.expectEqual(11387, try @"2"(in));
    }
}
