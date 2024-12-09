const std = @import("std");

const Parser = @import("../Parser.zig");

pub fn @"1"(in: []const u8) !u64 {
    var parser = Parser.init(in);
    const size = in.len - 1;
    var parsed: [size * 10]i64 = [_]i64{0} ** (size * 10);

    var p: usize = 0;
    var q: usize = 0;
    while (true) : (p += 1) {
        const n = parser.parseDigit() catch break;
        var c: i64 = undefined;
        if (p % 2 == 0) {
            c = @divTrunc(p, 2);
        } else {
            c = FREE;
        }
        for (0..n) |r| parsed[q + r] = c;
        q += n;
    }
    var s = parsed[0..q];

    var j = q - 1;
    for (0..q) |i| {
        if (i >= j) break;
        if (s[i] != FREE) continue;
        while (s[j] == FREE) {
            j -= 1;
        }
        if (i >= j) break;
        s[i] = s[j];
        s[j] = FREE;
    }

    return checksum(s);
}

pub fn @"2"(in: []const u8) !u64 {
    const size = in.len - 1;
    var parsed: [size * 10]i64 = [_]i64{0} ** (size * 10);
    var used: [size]Block = [_]Block{
        .{ .id = 0, .begin = 0, .end = 0 },
    } ** size;
    var free: [size]Block = [_]Block{
        .{ .id = 0, .begin = 0, .end = 0 },
    } ** size;

    var parser = Parser.init(in);
    var p: usize = 0;
    var q: usize = 0;
    while (true) : (p += 1) {
        const n = parser.parseDigit() catch break;
        if (p % 2 == 0) {
            for (0..n) |r| parsed[q + r] = @divTrunc(p, 2);
            used[p] = .{
                .id = @divTrunc(p, 2),
                .begin = q,
                .end = q + n - 1,
            };
        } else {
            for (0..n) |r| parsed[q + r] = FREE;
            free[p] = .{
                .id = FREE,
                .begin = q,
                .end = q + n - 1,
            };
        }
        q += n;
    }
    var s = parsed[0..q];

    for (0..p) |i| {
        for (0.., free) |j, freeb| {
            const usedb = used[p - i - 1];
            if (freeb.size() < usedb.size()) continue;
            if (freeb.begin > usedb.begin) continue;
            for (0..usedb.size()) |k| {
                s[freeb.begin + k] = usedb.id;
                s[usedb.begin + k] = FREE;
            }
            free[j] = .{
                .id = FREE,
                .begin = freeb.begin + usedb.size(),
                .end = freeb.end,
            };
            break;
        }
    }

    return checksum(s);
}

const FREE = -1;

fn checksum(s: []const i64) u64 {
    var r = 0;
    for (0.., s) |i, c| {
        if (c == FREE) continue;
        r += i * c;
    }
    return r;
}

const Block = struct {
    id: i64,
    begin: isize,
    end: isize,

    fn size(b: Block) isize {
        return b.end - b.begin + 1;
    }
};

test {
    const in = @embedFile("in_test.txt");

    comptime {
        @setEvalBranchQuota(100_000);
        try std.testing.expectEqual(1928, try @"1"(in));
        try std.testing.expectEqual(2858, try @"2"(in));
    }
}
