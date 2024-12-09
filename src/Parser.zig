const std = @import("std");

const Error = error{NoParse};

const Self = @This();

src: []const u8,
n: usize,
pos: usize = 0,

pub fn init(src: []const u8) Self {
    return .{
        .src = src,
        .n = src.len,
    };
}

pub fn end(self: Self) bool {
    return self.pos == self.n;
}

pub fn peek(self: Self) ?u8 {
    if (self.end()) {
        return null;
    }
    return self.src[self.pos];
}

pub fn eof(self: Self) bool {
    if (self.peek()) |c| {
        return c == '\n';
    } else {
        return true;
    }
}

pub fn seek(self: *Self, i: usize) void {
    std.debug.assert(i <= self.pos);
    self.pos = i;
}

pub fn skip(self: *Self) void {
    std.debug.assert(self.pos < self.n);
    self.pos += 1;
}

pub fn unskip(self: *Self) void {
    self.pos -= 1;
}

pub fn next(self: *Self) ?u8 {
    if (self.end()) {
        return null;
    }
    defer self.pos += 1;
    return self.src[self.pos];
}

pub fn prev(self: *Self) ?u8 {
    if (self.pos == 0) {
        return null;
    }
    return self.src[self.pos - 1];
}

pub fn parseChar(self: *Self, c: u8) Error!void {
    if (self.src[self.pos] != c) {
        return Error.NoParse;
    }
    self.pos += 1;
}

pub fn parseString(self: *Self, in: []const u8) Error!void {
    for (0.., in) |i, c| {
        const e = self.src[self.pos + i];
        if (c != e) {
            return Error.NoParse;
        }
    }
    self.pos += in.len;
}

pub fn parseDigit(self: *Self) Error!u8 {
    const c = self.src[self.pos];
    if (c >= '0' and c <= '9') {
        self.pos += 1;
        return c - '0';
    }
    return Error.NoParse;
}

pub fn parseNumber(self: *Self) Error!u64 {
    var n: u64 = 0;
    for (0.., self.src[self.pos..]) |i, c| {
        if (c >= '0' and c <= '9') {
            n *= 10;
            n += c - '0';
        } else {
            if (i == 0) {
                return Error.NoParse;
            }
            self.pos += i;
            return n;
        }
    }
    return Error.NoParse;
}

pub fn getNumberLineLen(self: *Self, delimiter: []const u8) Error!usize {
    const begin = self.pos;
    defer self.seek(begin);
    var n: usize = 0;
    while (self.peek() != '\n') {
        _ = try self.parseNumber();
        n += 1;
        self.parseString(delimiter) catch break;
    }
    try self.parseChar('\n');
    return n;
}

pub fn parseNumberLine(self: *Self, xs: []u64, delimiter: []const u8) Error!void {
    const begin = self.pos;
    errdefer self.seek(begin);
    for (0..xs.len) |i| {
        xs[i] = try self.parseNumber();
        self.parseString(delimiter) catch break;
    }
    try self.parseChar('\n');
}
