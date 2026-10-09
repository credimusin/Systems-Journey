const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.DebugAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var list: std.ArrayList(u32) = .empty;
    defer list.deinit(allocator);

    var i: u32 = 1;
    while (i <= 5) : (i += 1) {
        try list.append(allocator, i * 10);
    }

    std.debug.print("Items: {any}\n", .{list.items});
    std.debug.print("Len: {d}\nCap: {d}\n", .{list.items.len, list.capacity});
}
