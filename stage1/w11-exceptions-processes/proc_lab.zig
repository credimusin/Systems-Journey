const std = @import("std");

// Manage process: fork, execve, waitpid, zombies.

pub fn main() !void {
    const linux = std.os.linux;
    const pid = linux.getpid();

    std.debug.print("Parent PID: {}\n\n", .{pid});

    // I - fork + exit_group + waitpid

    const first_rc = linux.fork();
    if (linux.errno(first_rc) != .SUCCESS) return error.ForkFailed;

    if (first_rc == 0) {
        linux.exit_group(42);
    }

    const child1_pid: linux.pid_t = @intCast(first_rc);
    var status1: i32 = 0;
    const wait1_rc = linux.waitpid(child1_pid, &status1, 0);
    if (linux.errno(wait1_rc) != .SUCCESS) return error.WaitFailed;

    const status1_u: u32 = @bitCast(status1);
    if (linux.W.IFEXITED(status1_u)) {
        const code = linux.W.EXITSTATUS(status1_u);

        std.debug.print("Child PID: {}\nCode: {}\n\n", .{child1_pid, code});
    }

    // II - execve.

    const second_rc = linux.fork();
    if (linux.errno(second_rc) != .SUCCESS) return error.ForkFailed;

    if (second_rc == 0) {
        const argv = [_:null]?[*:0]const u8{ "/usr/bin/uname", "-a" };
        const envp = [_:null]?[*:0]const u8{};

        const exec_rc = linux.execve("/usr/bin/uname", &argv, &envp);

        std.debug.print(
        "execve failed: {}\n",
        .{linux.errno(exec_rc)});
        linux.exit_group(1);
    }
    
    const child2_pid: linux.pid_t = @intCast(second_rc);
    var status2: i32 = 0;
    const wait2_rc = linux.waitpid(child2_pid, &status2, 0);
    if (linux.errno(wait2_rc) != .SUCCESS) return error.WaitFailed;

    const status2_u: u32 = @bitCast(status2);
    if (linux.W.IFEXITED(status2_u)) {
        const code = linux.W.EXITSTATUS(status2_u);

        std.debug.print("Child PID: {}\nCode: {}\n\n", .{child2_pid, code});
    }
}
