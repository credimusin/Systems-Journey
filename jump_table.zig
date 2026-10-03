export fn comp_switch(x: u32, val: u32) u32 {
    return switch (x) {
        100 => val + 10,
        101 => val * 25,
        102 => val ^ 42,
        103 => val - 99,
        104 => val * 1337 - 1,
        105 => val / 3 + 2026,
        else => 0,
    };
}
