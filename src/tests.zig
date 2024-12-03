pub const @"01" = @import("./01/solution.zig");
pub const @"02" = @import("./02/solution.zig");
pub const @"03" = @import("./03/solution.zig");

test {
    @import("std").testing.refAllDecls(@This());
}
