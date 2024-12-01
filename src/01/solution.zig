const std = @import("std");

const PATH = "in.txt";

pub fn task_1(allocator: std.mem.Allocator, file: std.fs.File) !u64 {
    var xs = std.ArrayList(i64).init(allocator);
    defer xs.deinit();
    var ys = std.ArrayList(i64).init(allocator);
    defer ys.deinit();

    var reader = std.io.bufferedReader(file.reader());
    var buffer: [1024]u8 = undefined;
    while (try reader.reader().readUntilDelimiterOrEof(&buffer, '\n')) |line| {
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

pub fn task_2(allocator: std.mem.Allocator, file: std.fs.File) !u64 {
    var xs = std.ArrayList(u64).init(allocator);
    defer xs.deinit();
    var ys = std.AutoHashMap(u64, u64).init(allocator);
    defer ys.deinit();

    var reader = std.io.bufferedReader(file.reader());
    var buffer: [1024]u8 = undefined;
    while (try reader.reader().readUntilDelimiterOrEof(&buffer, '\n')) |line| {
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

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const status = gpa.deinit();
        std.debug.assert(status == .ok);
    }

    var file = try std.fs.cwd().openFile(PATH, .{});
    defer file.close();

    const answer_1 = try task_1(allocator, file);
    std.debug.print("Answer 1: {d}\n", .{ .answer = answer_1 });

    try file.seekTo(0);

    const answer_2 = try task_2(allocator, file);
    std.debug.print("Answer 2: {d}\n", .{ .answer = answer_2 });
}
