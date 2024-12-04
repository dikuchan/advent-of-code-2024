const std = @import("std");

const LineReader = @import("../utils.zig").LineReader;

pub fn @"1"(in: []const u8, allocator: std.mem.Allocator) !u64 {
    var xs = std.ArrayList(i64).init(allocator);
    defer xs.deinit();
    var ys = std.ArrayList(i64).init(allocator);
    defer ys.deinit();

    var reader = LineReader.init(in);
    var buffer: [1024]u8 = undefined;
    while (try reader.readLine(&buffer)) |line| {
        var iter = std.mem.splitSequence(u8, line, "   ");
        const x = try std.fmt.parseInt(i64, iter.next().?, 10);
        try xs.append(x);
        const y = try std.fmt.parseInt(i64, iter.next().?, 10);
        try ys.append(y);
    }

    std.mem.sort(i64, xs.items, {}, comptime std.sort.asc(i64));
    std.mem.sort(i64, ys.items, {}, comptime std.sort.asc(i64));

    std.debug.assert(xs.items.len == ys.items.len);

    var answer: u64 = 0;
    for (xs.items, ys.items) |x, y| {
        answer += @abs(x - y);
    }
    return answer;
}

pub fn @"2"(in: []const u8, allocator: std.mem.Allocator) !u64 {
    var xs = std.ArrayList(u64).init(allocator);
    defer xs.deinit();
    var ys = std.AutoHashMap(u64, u64).init(allocator);
    defer ys.deinit();

    var reader = LineReader.init(in);
    var buffer: [1024]u8 = undefined;
    while (try reader.readLine(&buffer)) |line| {
        var iter = std.mem.splitSequence(u8, line, "   ");
        const x = try std.fmt.parseInt(u64, iter.next().?, 10);
        try xs.append(x);
        const y = try std.fmt.parseInt(u64, iter.next().?, 10);
        const count = ys.get(y) orelse 0;
        try ys.put(y, count + 1);
    }

    var answer: u64 = 0;
    for (xs.items) |x| {
        const count = ys.get(x) orelse 0;
        answer += x * count;
    }
    return answer;
}

test {
    const in = @embedFile("in_test.txt");
    const allocator = std.testing.allocator;

    try std.testing.expect(try @"1"(in, allocator) == 11);
    try std.testing.expect(try @"2"(in, allocator) == 31);
}
