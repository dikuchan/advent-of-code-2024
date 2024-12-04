const std = @import("std");

const common = @import("../common.zig");

pub fn @"1"(in: []const u8) common.Error!u64 {
    var answer: u64 = 0;
    var position: usize = 0;
    while (true) {
        if (position >= in.len) {
            break;
        }
        if (parseOperation(in, position)) |r| {
            answer += r.value;
            position = r.position;
        } else |_| {
            position += 1;
        }
    }
    return answer;
}

pub fn @"2"(in: []const u8) common.Error!u64 {
    var answer: u64 = 0;
    var enabled = true;
    var position: usize = 0;
    while (true) {
        if (position >= in.len) {
            break;
        }
        if (parseOperation(in, position)) |r| {
            if (enabled) {
                answer += r.value;
            }
            position = r.position;
        } else |_| {
            if (common.parseIdentifier(in, position, "do()")) |r| {
                enabled = true;
                position = r;
            } else |_| {
                if (common.parseIdentifier(in, position, "don't()")) |r| {
                    enabled = false;
                    position = r;
                } else |_| {
                    position += 1;
                }
            }
        }
    }
    return answer;
}

fn parseOperation(s: []const u8, iposition: usize) common.Error!common.Parsed(u64) {
    var position = iposition;
    position = try common.parseIdentifier(s, position, "mul(");
    const x = try common.parseNumber(s, position);
    position = try common.parseIdentifier(s, x.position, ",");
    const y = try common.parseNumber(s, position);
    position = try common.parseIdentifier(s, y.position, ")");
    return .{
        .value = x.value * y.value,
        .position = position,
    };
}

test "1" {
    const in = @embedFile("in_test_01.txt");
    try comptime std.testing.expectEqual(161, try @"1"(in));
}

test "2" {
    const in = @embedFile("in_test_02.txt");
    try comptime std.testing.expectEqual(48, try @"2"(in));
}
