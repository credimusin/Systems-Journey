const std = @import("std");
const c = @import("c");

pub fn main() void {
    const result = c.add(2, 3);
    std.debug.print("{d}\n", .{result});
}
