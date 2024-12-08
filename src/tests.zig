pub const task_01 = @import("./01/solution.zig");
pub const task_02 = @import("./02/solution.zig");
pub const task_03 = @import("./03/solution.zig");
pub const task_04 = @import("./04/solution.zig");
pub const task_05 = @import("./05/solution.zig");
pub const task_06 = @import("./06/solution.zig");
pub const task_07 = @import("./07/solution.zig");
pub const task_08 = @import("./08/solution.zig");

test {
    @import("std").testing.refAllDecls(@This());
}
