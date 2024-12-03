const std = @import("std");

const Error = error{
    NoParse,
};

const IN: []const u8 = @embedFile("in.txt");

pub const Solution = struct {
    pub fn @"1"(_: std.mem.Allocator) !i64 {
        var answer: i64 = 0;
        var position: usize = 0;
        while (true) {
            if (position >= IN.len) {
                break;
            }
            if (parseOperation(IN, position)) |r| {
                answer += r.value;
                position = r.position;
            } else |_| {
                // TODO: Skip more.
                position += 1;
            }
        }
        return answer;
    }

    pub fn @"2"(_: std.mem.Allocator) !i64 {
        var answer: i64 = 0;
        var enabled = true;
        var position: usize = 0;
        while (true) {
            if (position >= IN.len) {
                break;
            }
            if (parseOperation(IN, position)) |r| {
                if (enabled) {
                    answer += r.value;
                }
                position = r.position;
            } else |_| {
                if (parseIdentifier(IN, position, "do()")) |r| {
                    enabled = true;
                    position = r;
                } else |_| {
                    if (parseIdentifier(IN, position, "don't()")) |r| {
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

const ParsedNumber = Parsed(i64);
const ParsedOperation = Parsed(i64);

fn parseIdentifier(s: []const u8, position: usize, id: []const u8) Error!usize {
    for (0.., id) |i, c| {
        const e = s[position + i];
        if (c != e) {
            return Error.NoParse;
        }
    }
    return position + id.len;
}

fn parseNumber(s: []const u8, position: usize) Error!ParsedNumber {
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

fn parseOperation(s: []const u8, iposition: usize) Error!ParsedOperation {
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
