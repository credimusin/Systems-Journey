const std = @import("std");

// A clear example of how you can run computations on 4 parallel ALUs
// to see the difference in calculation performance/results.

const N = 65536;
const ITERATIONS = 1000;

fn sum1x1(data: []const f64) f64 {
    var sum: f64 = 0.0;
    for (data) |x| {
        sum += x;
    }
    return sum;
}

fn sum2x2(data: []const f64) f64 {
    var sum0: f64 = 0.0;
    var sum1: f64 = 0.0;
    var i: usize = 0;

    while (i < data.len) : (i += 2) {
        sum0 += data[i];
        sum1 += data[i + 1];
    }

    return sum0 + sum1;
}

fn sum4x4(data: []const f64) f64 {
   var sum0: f64 = 0.0; 
   var sum1: f64 = 0.0; 
   var sum2: f64 = 0.0; 
   var sum3: f64 = 0.0; 
   var i: usize = 0;

   while (i < data.len) : (i += 4) {
       sum0 += data[i];
       sum1 += data[i + 1];
       sum2 += data[i + 2];
       sum3 += data[i + 3];
   }

   return sum0 + sum1 + sum2 + sum3;
}

fn getNanoSec() i128 {
    var ts: std.posix.timespec = undefined;
    _ = std.posix.system.clock_gettime(.MONOTONIC, &ts);
    return @as(i128, ts.sec) * std.time.ns_per_s + ts.nsec;
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const data = try allocator.alloc(f64, N);
    defer allocator.free(data);

    @memset(data, 1.0);

    _ = sum1x1(data);

    const t0 = getNanoSec();
    var res1: f64 = 0;
    for (0..ITERATIONS) |_| {
        res1 += sum1x1(data);
    }
    const dt1_ms = @as(f64, @floatFromInt(getNanoSec() - t0)) / 1_000_000.0;

    const t1 = getNanoSec();
    var res2: f64 = 0;
    for (0..ITERATIONS) |_| {
        res2 += sum2x2(data);
    }
    const dt2_ms = @as(f64, @floatFromInt(getNanoSec() - t1)) / 1_000_000.0;

    const t4 = getNanoSec();
    var res4: f64 = 0;
    for (0..ITERATIONS) |_| {
        res4 += sum4x4(data);
    }
    const dt4_ms = @as(f64, @floatFromInt(getNanoSec() - t4)) / 1_000_000.0;

    std.debug.print("1x1 : {d:.2} ms (res = {d:.0})\n", .{dt1_ms, res1});
    std.debug.print("2x2 : {d:.2} ms (res = {d:.0})\n", .{dt2_ms, res2});
    std.debug.print("4x4 : {d:.2} ms (res = {d:.0})\n", .{dt4_ms, res4});
}
