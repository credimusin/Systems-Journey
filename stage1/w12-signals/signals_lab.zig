const std = @import("std");
const linux = std.os.linux;

var stop_reqd = std.atomic.Value(bool).init(false);

var handler_calls = std.atomic.Value(u32).init(0);
var reaped_count = std.atomic.Value(u32).init(0);


fn onSignChld(_: linux.SIG) callconv(.c) void {
    _ = handler_calls.fetchAdd(1, .monotonic);

    var status: i32 = 0;
    while (true) {
        const rc = linux.waitpid(-1, &status, linux.W.NOHANG);
        if (linux.errno(rc) != .SUCCESS or rc == 0) break;
        _ = reaped_count.fetchAdd(1, .monotonic);
    }
}


fn onSignal(_: linux.SIG) callconv(.c) void {
    stop_reqd.store(true, .release);
}


pub fn main() !void {

    // Graceful Shutdown 
    const pid = linux.getpid();
    std.debug.print("Process PID: {} started. Waiting for SIGINT...\n", .{pid});
    
    const act = linux.Sigaction {
        .handler = .{ .handler = onSignal },
        .mask = linux.sigemptyset(),
        .flags = linux.SA.RESTART,
    };
    _ = linux.sigaction(.INT, &act, null);

    _ = linux.kill(pid, .INT);

    if (stop_reqd.load(.acquire)) {
        std.debug.print("Caught SIGINT! Shutdown complete.\n", .{});
    } else {
        std.debug.print("Signal was NOT caught!\n", .{});
    }

    // Blocking and collapse SIGCHLD
    const chld_act = linux.Sigaction{
        .handler = .{ .handler = onSignChld },
        .mask = linux.sigemptyset(),
        .flags = linux.SA.RESTART,
    };
    _ = linux.sigaction(.CHLD, &chld_act, null);
    
    var mask = linux.sigemptyset();
    linux.sigaddset(&mask, .CHLD);
    var old_mask = linux.sigemptyset();

    _ = linux.sigprocmask(linux.SIG.BLOCK, &mask, &old_mask);

    for (0..5) |_| {
        const rc = linux.fork();

        if (rc == 0) {
            linux.exit_group(0);
        }
    }

    const req = linux.timespec{ .sec = 0, .nsec = 50_000_000 };
    _ = linux.nanosleep(&req, null);
    _ = linux.sigprocmask(linux.SIG.SETMASK, &old_mask, null);

    std.debug.print("Handler calls: {}\n", .{handler_calls.load(.acquire)});
    std.debug.print("Reaper counts: {}\n", .{reaped_count.load(.acquire)});
}
