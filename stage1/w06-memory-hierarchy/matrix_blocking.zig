const std = @import("std");

// В математике умножение матриц C = A × B устроено так: чтобы получить
// число на пересечении i строки и j столбца, мы берем i строку
// матрицы A, умножаем ее поэлементно на j столбец матрицы B и всё
// складываем:
//           N-1
// C[i][j] =  ∑  A[i][k] · B[k][j]
//           k=0

const N: usize = 512;
const BLOCK: usize = 32;
const Matrix = [N][N]f64;

fn getNanoSec() i128 {
    var ts: std.posix.timespec = undefined;
    _ = std.posix.system.clock_gettime(.MONOTONIC, &ts);
    return @as(i128, ts.sec) * std.time.ns_per_s + ts.nsec;
}

fn multiplyBlocked(c: *Matrix, a: *const Matrix, b: *const Matrix) void {
    var i_b: usize = 0;
    // нарезаем гигантскую матрицу на маленькие квадраты
    // 32 × 32 элемента, которые целиком влезают на стол
    // процессора (в кэш L1).
    // Размер плитки 32 × 32 чисел f64 = 1024 × 8 = 𝟖 КБ.
    // Три таких плитки (A, B и C) занимают 24 КБ.
    // Кэш L1 на твоем процессоре обычно 32 КБ или 48 КБ. Все три кусочка
    // полностью помещаются в L1 и крутятся там с нулевой задержкой.
    while (i_b < N) : (i_b += BLOCK) {
        var j_b: usize = 0;
        while (j_b < N) : (j_b += BLOCK) {
            var k_b: usize = 0;
            while (k_b < N) : ( k_b += BLOCK) {
                var i = i_b;
                while (i < i_b + BLOCK) : (i += 1) {
                    var j = j_b;
                    while (j < j_b + BLOCK) : (j += 1) {
                        var sum: f64 = 0.0;
                        var k = k_b;
                        while (k < k_b + BLOCK) : ( k += 1) {
                            sum += a[i][j] * b[k][j];
                        }
                        c[i][j] += sum;
                    }
                }
            }
        }
    }
}

fn multiplyNaive(c: *Matrix, a: *const Matrix, b: *const Matrix) void {
    var i: usize = 0;
    // i - перебирает строки матрицы A (от 0 до N - 1)
    // j - перебирает столбцы матрицы B (от 0 до N - 1)
    // k - бежит внутри строки A и столбца B, накапливая сумму
    while (i < N) : (i += 1) {
        var j: usize = 0;
        while (j < N) : (j += 1) {
            var sum: f64 = 0.0;
            var k: usize = 0;
            while (k < N) : ( k += 1) {
                sum += a[i][k] * b[k][j];
            }
            c[i][j] = sum;
        }
    }
}

// Запустить без оптимизации -O ReleaseFast 
pub fn main() !void {
    const  allocator = std.heap.page_allocator;

    // Три матрицы по 2 МБ весят суммарно 6 МБ. Стек программы в Linux обычно
    // 8 МБ - три такие матрицы в стеке могут вызвать Segmentation fault.
    // Поэтому выделяем их в куче (heap) через аллокатор
    
    const a = try allocator.create(Matrix);
    defer allocator.destroy(a);

    const b = try allocator.create(Matrix);
    defer allocator.destroy(b);

    const c = try allocator.create(Matrix);
    defer allocator.destroy(c);

    for (0..N) |i| {
        for (0..N) |j| {
            a[i][j] = 1.0;
            b[i][j] = 1.0;
            c[i][j] = 0.0;
        }
    }

    const start = getNanoSec();
    multiplyNaive(c, a, b);
    const end = getNanoSec();

    const time_ms = @as(f64, @floatFromInt(end - start)) / 1_000_000.0;

    std.debug.print("Naive multipy:    {d:.2}ms (c[0][0] = {d:.1})\n", .{time_ms, c[0][0]});

    // Обнуляем матрицу перед вторым замером.
    for (0..N) |i| {
        @memset(&c[i], 0.0);
    }

    const start_b = getNanoSec();
    multiplyBlocked(c, a, b);
    const end_b = getNanoSec();

    const time_b_ms = @as(f64, @floatFromInt(end_b - start_b)) / 1_000_000.0;

    std.debug.print("Blocked multiply: {d:.2}ms (c[0][0] = {d:.1})\n ", .{time_b_ms, c[0][0]});
}
