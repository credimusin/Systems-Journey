const std = @import("std");

fn swap (x: *i32, y: *i32) void {
    const tmp: i32 = y.*;
    y.* = x.*;
    x.* = tmp;
}

pub fn main() void {
    var x: i32 = 10;
    var y: i32 = 99;
    
    std.debug.print("Before swap: x = {d}; y = {d}\n", .{ x, y });

    swap(&x, &y);

    std.debug.print("After swap:  x = {d}; y = {d}\n", .{ x, y });
}
