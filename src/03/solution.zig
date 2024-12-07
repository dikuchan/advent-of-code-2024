const std = @import("std");

const Parser = @import("../Parser.zig");

pub fn @"1"(in: []const u8) !u64 {
    var parser = Parser.init(in);
    var answer: u64 = 0;
    while (!parser.end()) {
        answer += parseOperation(&parser) catch {
            parser.skip();
            continue;
        };
    }
    return answer;
}

pub fn @"2"(in: []const u8) !u64 {
    var parser = Parser.init(in);
    var enabled = true;
    var answer: u64 = 0;
    while (!parser.end()) {
        if (parseOperation(&parser)) |x| {
            if (enabled) {
                answer += x;
            }
        } else |_| {
            if (parser.parseString("do()")) {
                enabled = true;
            } else |_| {
                if (parser.parseString("don't()")) {
                    enabled = false;
                } else |_| {
                    parser.skip();
                    continue;
                }
            }
        }
    }
    return answer;
}

fn parseOperation(parser: *Parser) !u64 {
    try parser.parseString("mul(");
    const x = try parser.parseNumber();
    try parser.parseChar(',');
    const y = try parser.parseNumber();
    try parser.parseChar(')');
    return x * y;
}

test "1" {
    const in = @embedFile("in_test_01.txt");
    try comptime std.testing.expectEqual(161, try @"1"(in));
}

test "2" {
    const in = @embedFile("in_test_02.txt");
    try comptime std.testing.expectEqual(48, try @"2"(in));
}
