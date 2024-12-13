const std = @import("std");

const Parser = @import("../Parser.zig");

const Error = error{
    End,
};

pub fn @"1"(in: []const u8) !u64 {
    return solve(in, 0);
}

pub fn @"2"(in: []const u8) !u64 {
    return solve(in, 10_000_000_000_000);
}

fn solve(in: []const u8, s: u64) !u64 {
    var parser = Parser.init(in);
    var answer = 0;
    while (true) {
        const c = parseConfiguration(&parser) catch break;
        const px = c.px + s;
        const py = c.py + s;
        const d = @abs(c.ax * c.by - c.bx * c.ay);
        const da = @abs(px * c.by - c.bx * py);
        const db = @abs(c.ax * py - px * c.ay);
        if (da % d == 0 and db % d == 0) {
            answer += 3 * (da / d) + db / d;
        }
    }
    return answer;
}

const Configuration = struct {
    ax: i64,
    ay: i64,
    bx: i64,
    by: i64,
    px: i64,
    py: i64,
};

fn parseConfiguration(parser: *Parser) !Configuration {
    const a = try parseButton(parser, 'A');
    try parser.parseChar('\n');
    const b = try parseButton(parser, 'B');
    try parser.parseChar('\n');
    const p = try parsePrize(parser);
    try parser.parseChar('\n');
    if (parser.end()) return Error.End;
    try parser.parseChar('\n');
    return .{
        .ax = @intCast(a.x),
        .ay = @intCast(a.y),
        .bx = @intCast(b.x),
        .by = @intCast(b.y),
        .px = @intCast(p.x),
        .py = @intCast(p.y),
    };
}

fn parseButton(parser: *Parser, c: u8) !struct { x: u64, y: u64 } {
    try parser.parseString("Button ");
    try parser.parseChar(c);
    try parser.parseString(": X+");
    const x = try parser.parseNumber();
    try parser.parseString(", Y+");
    const y = try parser.parseNumber();
    return .{ .x = x, .y = y };
}

fn parsePrize(parser: *Parser) !struct { x: u64, y: u64 } {
    try parser.parseString("Prize: X=");
    const x = try parser.parseNumber();
    try parser.parseString(", Y=");
    const y = try parser.parseNumber();
    return .{ .x = x, .y = y };
}

test {
    const in = @embedFile("in_test.txt");

    comptime {
        try std.testing.expectEqual(480, @"1"(in));
    }
}
