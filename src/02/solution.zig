const std = @import("std");

const Parser = @import("../parser.zig").Parser;

pub fn @"1"(in: []const u8) !u64 {
    var parser = Parser.init(in);
    var answer: u64 = 0;
    while (!parser.eof()) {
        var xs = [_]u64{0} ** try parser.getNumberLineLen(" ");
        parser.parseNumberLine(&xs, " ") catch break;
        if (check(&xs)) {
            answer += 1;
        }
    }
    return answer;
}

pub fn @"2"(in: []const u8) !u64 {
    var parser = Parser.init(in);
    var answer: u64 = 0;
    while (!parser.eof()) {
        const n = try parser.getNumberLineLen(" ");
        var xs = [_]u64{0} ** n;
        parser.parseNumberLine(&xs, " ") catch break;
        for (0..n) |i| {
            var ys = [_]u64{0} ** (n - 1);
            var k: usize = 0;
            for (0..n) |j| {
                if (i != j) {
                    ys[k] = xs[j];
                    k += 1;
                }
            }
            if (check(&ys)) {
                answer += 1;
                break;
            }
        }
    }
    return answer;
}

fn check(xs: []u64) bool {
    var ds = [_]i64{0} ** (xs.len - 1);
    for (0..xs.len - 1) |i| {
        const ai: i64 = @intCast(xs[i]);
        const bi: i64 = @intCast(xs[i + 1]);
        ds[i] = bi - ai;
    }
    if (checkBounds(&ds, 1, 3)) {
        return true;
    }
    if (checkBounds(&ds, -3, -1)) {
        return true;
    }
    return false;
}

fn checkBounds(ds: []const i64, lower: i64, upper: i64) bool {
    for (ds) |d| {
        if (d < lower or d > upper) {
            return false;
        }
    }
    return true;
}

test {
    const in = @embedFile("in_test.txt");

    comptime {
        @setEvalBranchQuota(100_000);
        try std.testing.expectEqual(2, try @"1"(in));
        try std.testing.expectEqual(4, try @"2"(in));
    }
}
