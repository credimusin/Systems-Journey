export fn sum_arr(ptr: [*]const u32, len: usize) u32 {
    var sum: u32 = 0;
    var i: usize = 0;

    while (i < len) : (i += 1) {
        sum += ptr[i];
    }

    return sum;
}
