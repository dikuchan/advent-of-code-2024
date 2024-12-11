const std = @import("std");

const Parser = @import("../Parser.zig");

const Map = StaticMap(u64, u64, 0, 100_003);

pub fn @"1"(in: []const u8) !u64 {
    return solve(in, 25);
}

fn solve(in: []const u8, n: u64) u64 {
    var parser = Parser.init(in);
    var answer: u64 = 0;
    var dp = Map.init();
    while (true) {
        const stone = parser.parseNumber() catch break;
        answer += countN(&dp, stone, n);
        parser.parseChar(' ') catch break;
    }
    return answer;
}

fn countN(dp: *Map, stone: u64, n: u64) u64 {
    if (n == 0) return 1;
    const dpr = dp.get(.{ stone, n });
    if (dpr != 0) {
        return dpr;
    }
    var r: u64 = 0;
    const nd = countDigits(stone);
    if (stone == 0) {
        r = countN(dp, 1, n - 1);
    } else if (nd % 2 == 0) {
        const d = std.math.pow(u64, 10, nd / 2);
        r = countN(dp, stone / d, n - 1) + countN(dp, stone % d, n - 1);
    } else {
        r = countN(dp, stone * 2024, n - 1);
    }
    dp.set(.{ stone, n }, r);
    return r;
}

fn countDigits(n: u64) u64 {
    if (n == 0) return 0;
    return std.math.log10_int(n) + 1;
}

// TODO: Add buckets.
fn StaticMap(comptime K: type, comptime V: type, default: V, comptime size: usize) type {
    return struct {
        const Self = @This();

        data: [size]V,

        fn init() Self {
            return .{
                .data = [_]V{default} ** size,
            };
        }

        fn set(self: *Self, ks: anytype, v: V) void {
            var hash: K = 0;
            for (ks) |k| {
                hash = hashCombine(hash, k);
            }
            self.data[hash % size] = v;
        }

        fn get(self: Self, ks: anytype) V {
            var hash: K = 0;
            for (ks) |k| {
                hash = hashCombine(hash, k);
            }
            return self.data[hash % size];
        }

        fn hashCombine(seed: K, x: K) u64 {
            return seed ^ x + 0x9e3779b9 + (seed << 6) + (seed >> 2);
        }
    };
}

test {
    const in = @embedFile("in_test.txt");

    comptime {
        @setEvalBranchQuota(100_000_000);

        try std.testing.expectEqual(22, solve(in, 6));
        try std.testing.expectEqual(55312, solve(in, 25));
    }
}
