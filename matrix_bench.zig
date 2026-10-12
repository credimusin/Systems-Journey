const std = @import("std");

const N: u32 = 2048;


fn sumRowMajor(matrix: []const [N]i32) i64 {
    var sum: i64 = 0;
    var i: usize = 0;

    while (i < N) : (i += 1) {
        var j: usize = 0;
        while (j < N) : (j += 1) {
            sum += matrix[i][j];
        }
    }

    return sum;
}

fn sumColMajor(matrix: []const [N]i32) i64 {
    var sum: i64 = 0;
    var j: usize = 0;

    while (j < N) : (j += 1) {
        var i: usize = 0;
        while (i < N) : (i += 1) {
            sum += matrix[i][j];
        }
    }

    return sum;
}

fn getNanoSeconsds() i128 {
    var ts: std.posix.timespec = undefined;
    _ = std.posix.system.clock_gettime(.MONOTONIC, &ts);
    return @as(i128, ts.sec) * std.time.ns_per_s + ts.nsec;
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const matrix = try allocator.alloc([N]i32, N);
    defer allocator.free(matrix);

    for (matrix) |*row| {
        @memset(row, 1);
    }

    const start_row = getNanoSeconsds();
    const sum_row = sumRowMajor(matrix);
    const end_row = getNanoSeconsds();
    const time_row_ms = @as(f64, @floatFromInt(end_row - start_row)) / 1_000_000.0;

    const start_col = getNanoSeconsds();
    const sum_col = sumColMajor(matrix);
    const end_col = getNanoSeconsds();
    const time_col_ms = @as(f64, @floatFromInt(end_col - start_col)) / 1_000_000.0;
    
    std.debug.print("Row-major  : {d:.2} ms (sum: {d})\n", .{ time_row_ms, sum_row });
    std.debug.print("Col-major  : {d:.2} ms (sum: {d})\n", .{ time_col_ms, sum_col });
}
