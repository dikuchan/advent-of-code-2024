const Grid = @This();

X: usize,
Y: usize,
data: []const u8,

pub fn init(data: []const u8) Grid {
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

pub fn get(grid: Grid, ix: isize, iy: isize) ?u8 {
    if (ix < 0 or iy < 0) {
        return null;
    }
    const x: usize = @intCast(ix);
    const y: usize = @intCast(iy);
    if (x >= grid.X or y >= grid.Y) {
        return null;
    }
    return grid.data[x + (grid.X + 1) * y];
}

pub fn iter(grid: Grid) Iterator {
    return .{
        .grid = &grid,
        .x = 0,
        .y = 0,
    };
}

pub const Node = struct {
    x: isize,
    y: isize,
    c: u8,
};

pub const Iterator = struct {
    grid: *const Grid,
    x: isize,
    y: isize,

    pub fn next(i: *Iterator) ?Node {
        defer {
            i.x += 1;
            if (i.x >= i.grid.X) {
                i.x = 0;
                i.y += 1;
            }
        }
        if (i.grid.get(i.x, i.y)) |c| {
            return .{
                .x = i.x,
                .y = i.y,
                .c = c,
            };
        }
        return null;
    }

    pub fn clone(i: Iterator) Iterator {
        return .{
            .grid = i.grid,
            .x = i.x,
            .y = i.y,
        };
    }
};
