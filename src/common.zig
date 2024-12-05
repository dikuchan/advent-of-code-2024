const std = @import("std");

pub fn array(comptime T: type, comptime size: usize, comptime default: T) [size]T {
    var data: [size]T = undefined;
    @memset(&data, default);
    return data;
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

pub const ParseError = error{
    End,
    NoParse,
};

pub const Parser = struct {
    s: []const u8,
    n: usize,
    pos: usize = 0,

    pub fn init(s: []const u8) Parser {
        return .{
            .s = s,
            .n = s.len,
        };
    }

    pub fn peek(p: Parser) ?u8 {
        if (p.end()) {
            return null;
        }
        return p.s[p.pos];
    }

    pub fn seek(p: *Parser, i: usize) ParseError!void {
        if (i >= p.n) {
            return ParseError.End;
        }
        p.pos = i;
    }

    pub fn skip(p: *Parser) void {
        p.pos += 1;
    }

    pub fn next(p: *Parser) ?u8 {
        if (p.end()) {
            return null;
        }
        defer p.pos += 1;
        return p.s[p.pos];
    }

    pub fn prev(p: *Parser) ?u8 {
        if (p.pos == 0) {
            return null;
        }
        return p.s[p.pos - 1];
    }

    pub fn parseChar(p: *Parser, c: u8) ParseError!void {
        if (p.s[p.pos] != c) {
            return ParseError.NoParse;
        }
        p.pos += 1;
    }

    pub fn parseString(p: *Parser, s: []const u8) ParseError!void {
        for (0.., s) |i, c| {
            const e = s[p.pos + i];
            if (c != e) {
                return Error.NoParse;
            }
        }
        p.pos += s.len;
    }

    pub fn parseNumber(p: *Parser) ParseError!u64 {
        var n: u64 = 0;
        for (0.., p.s[p.pos..]) |i, c| {
            if (c >= '0' and c <= '9') {
                n *= 10;
                n += c - '0';
            } else {
                if (i == 0) {
                    return Error.NoParse;
                }
                p.pos += i;
                return n;
            }
        }
        return Error.NoParse;
    }

    pub fn end(p: Parser) bool {
        return p.pos == p.n;
    }
};
