const Self = @This();

X: usize,
Y: usize,
data: []const u8,

pub fn init(data: []const u8) Self {
    var X: usize = 0;
    var Y: usize = 0;
    for (0.., data) |i, c| {
        if (c == '\n') {
            if (X == 0) {
                X = i;
            }
            Y += 1;
        }
    }
    return .{
        .X = X,
        .Y = Y,
        .data = data,
    };
}

pub fn get(self: Self, ix: isize, iy: isize) ?u8 {
    if (ix < 0 or iy < 0) {
        return null;
    }
    const x: usize = @intCast(ix);
    const y: usize = @intCast(iy);
    if (x >= self.X or y >= self.Y) {
        return null;
    }
    return self.data[x + (self.X + 1) * y];
}
