const std = @import("std");

pub fn array(comptime T: type, comptime n: usize) [n]T {
    var arr: [n]T = undefined;
    @memset(&arr, 0);
    return arr;
}

pub fn countLines(s: []const u8) usize {
    var n: usize = 0;
    for (s) |c| {
        if (c == '\n') {
            n += 1;
        }
    }
    return n;
}

pub const Error = error{
    NoParse,
    InvalidBuffer,
};

pub fn Parsed(comptime T: type) type {
    return struct {
        value: T,
        position: usize,
    };
}

pub fn parseNumber(s: []const u8, position: usize) Error!Parsed(u64) {
    var n: u64 = 0;
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

pub fn parseIdentifier(s: []const u8, position: usize, id: []const u8) Error!usize {
    for (0.., id) |i, c| {
        const e = s[position + i];
        if (c != e) {
            return Error.NoParse;
        }
    }
    return position + id.len;
}

pub fn Map(comptime T: type) type {
    return struct {
        const Self = @This();

        data: []T,

        pub fn init(size: usize) Map {
            return .{
                .data = array(T, size),
            };
        }

        pub fn get(self: Self, key: usize) T {
            return self.data[key];
        }

        pub fn set(self: *Self, key: usize, value: T) void {
            self.data[key] = value;
        }
    };
}

pub const LineReader = struct {
    const Self = @This();

    position: usize = 0,
    s: []const u8,
    delimiter: u8 = '\n',

    pub fn init(s: []const u8) LineReader {
        return LineReader{
            .s = s,
        };
    }

    pub fn readLine(self: *Self, buffer: []u8) Error!?[]const u8 {
        if (self.position >= self.s.len) {
            return null;
        }

        var i: usize = self.position;
        while (i < self.s.len and self.s[i] != self.delimiter) : (i += 1) {}

        const line_length = i - self.position;
        if (line_length > buffer.len) {
            return Error.InvalidBuffer;
        }

        @memcpy(buffer[0..line_length], self.s[self.position..i]);
        buffer[line_length] = 0;

        self.position = i + 1;

        return buffer[0..line_length];
    }
};
