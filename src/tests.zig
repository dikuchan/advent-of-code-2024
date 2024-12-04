pub const task_01 = @import("./01/solution.zig");
pub const task_02 = @import("./02/solution.zig");
pub const task_03 = @import("./03/solution.zig");
pub const task_04 = @import("./04/solution.zig");

test {
    @import("std").testing.refAllDecls(@This());
}
