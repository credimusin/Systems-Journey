const print = @import("std").debug.print;

pub fn main () void {
    const a: u4 = 0b1010;
    const b: u4 = 0b1100;

    const left: u4 = ~(a & b);
    const right: u4 = ~a | ~b;

    print("~(a & b): {}\n", .{left});
    print("~a | ~b:  {}\n", .{right});
    print("Equels:   {}\n", .{left == right});
}

