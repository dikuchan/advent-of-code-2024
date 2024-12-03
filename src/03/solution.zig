const std = @import("std");

pub const IN: []const u8 = @embedFile("in.txt");

pub const Solver = struct {
    in: []const u8,

    pub fn init(in: []const u8) Solver {
        return .{
            .in = in,
        };
    }

    pub fn @"1"(self: Solver, _: std.mem.Allocator) anyerror!i64 {
        var answer: i64 = 0;
        var position: usize = 0;
        while (true) {
            if (position >= self.in.len) {
                break;
            }
            if (parseOperation(self.in, position)) |r| {
                answer += r.value;
                position = r.position;
            } else |_| {
                position += 1;
            }
        }
        return answer;
    }

    pub fn @"2"(self: Solver, _: std.mem.Allocator) anyerror!i64 {
        var answer: i64 = 0;
        var enabled = true;
        var position: usize = 0;
        while (true) {
            if (position >= self.in.len) {
                break;
            }
            if (parseOperation(self.in, position)) |r| {
                if (enabled) {
                    answer += r.value;
                }
                position = r.position;
            } else |_| {
                if (parseIdentifier(self.in, position, "do()")) |r| {
                    enabled = true;
                    position = r;
                } else |_| {
                    if (parseIdentifier(self.in, position, "don't()")) |r| {
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
};

fn Parsed(comptime T: type) type {
    return struct {
        value: T,
        position: usize,
    };
}

const Error = error{
    NoParse,
};

fn parseIdentifier(s: []const u8, position: usize, id: []const u8) Error!usize {
    for (0.., id) |i, c| {
        const e = s[position + i];
        if (c != e) {
            return Error.NoParse;
        }
    }
    return position + id.len;
}

fn parseNumber(s: []const u8, position: usize) Error!Parsed(i64) {
    var n: i64 = 0;
    for (0.., s[position..]) |i, c| {
        if (c >= '0' and c <= '9') {
            n *= 10;
            n += c - '0';
        } else {
            if (i == 0) {
                return Error.NoParse;
            }
            return .{
                .value = n,
                .position = position + i,
            };
        }
    }
    return Error.NoParse;
}

fn parseOperation(s: []const u8, iposition: usize) Error!Parsed(i64) {
    var position = iposition;
    position = try parseIdentifier(s, position, "mul(");
    const x = try parseNumber(s, position);
    position = x.position;
    position = try parseIdentifier(s, position, ",");
    const y = try parseNumber(s, position);
    position = y.position;
    position = try parseIdentifier(s, position, ")");
    return .{
        .value = x.value * y.value,
        .position = position,
    };
}

test "01" {
    const IN_TEST = @embedFile("in_test_01.txt");
    var solver = Solver.init(IN_TEST);

    const allocator = std.testing.allocator;

    try std.testing.expect(try solver.@"1"(allocator) == 161);
}

test "02" {
    const IN_TEST = @embedFile("in_test_02.txt");
    var solver = Solver.init(IN_TEST);

    const allocator = std.testing.allocator;

    try std.testing.expect(try solver.@"2"(allocator) == 48);
}
