const std = @import("std");

export fn simdSum(ptr: [*]const f32, len: usize) f32 {
    const slice = ptr[0..len];
    
    const Vec4 = @Vector(4, f32);
    var vec_acc: Vec4 = @splat(0.0);

    const limit = slice.len - (slice.len % 4);

    var i: usize = 0;
    while (i < limit) : (i += 4) {
        const chunk: Vec4 = slice[i..][0..4].*;
        vec_acc += chunk;
    }

    var sum: f32 = @reduce(.Add, vec_acc);
    for (slice[limit..]) |val| {
        sum += val;
    }

    return sum;
}

pub fn main() void {
    const a: f32 = 1.0e20;
    const b: f32 = -1.0e20;
    const c: f32 = 3.14;
    
    // an example of the loss of associativity with float numbers

    const r1 = (a + b) + c; 
    const r2 = a + (b + c);
    // -10^20 + 3.14 = is shifted out beyond the bounds of the register and set to zero

    std.debug.print("(a + b) + c = {}\n", .{r1});
    std.debug.print("a + (b + c) = {}\n", .{r2});

    std.debug.print("\n", .{});

    // hardware SIMD via @Vector

    const nums = [_]f32{ 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0 };

    // The scalar loop performed 10 sequential addss instructions.
    var scalar_sum: f32 = 0.0;
    for (nums) |val| {
        scalar_sum += val;
    }

    // The SIMD function executed just two vaddps vector instructions on 128-bit
    // YMM registers (adding 4 numbers per cycle) and then processed
    // the remaining 2 elements using scalar operations.
    // For arrays containing millions of elements, this results in a 3–4x speedup.
    const vector_sum = simdSum(&nums, nums.len);

    std.debug.print("Scalar: {}\n", .{scalar_sum});
    std.debug.print("SMID:   {}\n", .{vector_sum});
}
