const std = @import("std");

const Error = error{
    BufferTooSmall,
};

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
            return Error.BufferTooSmall;
        }

        @memcpy(buffer[0..line_length], self.s[self.position..i]);
        buffer[line_length] = 0;

        self.position = i + 1;

        return buffer[0..line_length];
    }
};
