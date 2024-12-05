const std = @import("std");

const Error = error{NoParse};

pub const Parser = struct {
    src: []const u8,
    n: usize,
    pos: usize = 0,

    pub fn init(src: []const u8) Parser {
        return .{
            .src = src,
            .n = src.len,
        };
    }

    pub fn end(p: Parser) bool {
        return p.pos == p.n;
    }

    pub fn peek(p: Parser) ?u8 {
        if (p.end()) {
            return null;
        }
        return p.src[p.pos];
    }

    pub fn seek(p: *Parser, i: usize) void {
        std.debug.assert(i <= p.pos);
        p.pos = i;
    }

    pub fn skip(p: *Parser) void {
        std.debug.assert(p.pos < p.n);
        p.pos += 1;
    }

    pub fn unskip(p: *Parser) void {
        p.pos -= 1;
    }

    pub fn next(p: *Parser) ?u8 {
        if (p.end()) {
            return null;
        }
        defer p.pos += 1;
        return p.src[p.pos];
    }

    pub fn prev(p: *Parser) ?u8 {
        if (p.pos == 0) {
            return null;
        }
        return p.src[p.pos - 1];
    }

    pub fn parseChar(p: *Parser, c: u8) Error!void {
        if (p.src[p.pos] != c) {
            return Error.NoParse;
        }
        p.pos += 1;
    }

    pub fn parseString(p: *Parser, in: []const u8) Error!void {
        for (0.., in) |i, c| {
            const e = p.src[p.pos + i];
            if (c != e) {
                return Error.NoParse;
            }
        }
        p.pos += in.len;
    }

    pub fn parseNumber(p: *Parser) Error!u64 {
        var n: u64 = 0;
        for (0.., p.src[p.pos..]) |i, c| {
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
};
