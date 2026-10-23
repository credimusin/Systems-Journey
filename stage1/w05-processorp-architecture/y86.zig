const std = @import("std");

// Converting raw machine code bytes (Little-Endian) into a formal
// Instruction structure (opcode, registers rA:rB, and offset valC). 

// How the processor pipeline manages data dependencies between
// consecutive instructions

pub const Register = enum(u4) {
    rax = 0,
    rcx = 1,
    rdx = 2,
    rbx = 3,
    rsp = 4,
    rbp = 5,
    rsi = 6,
    rdi = 7,
    r8 = 8,
    r9 = 9,
    r10 = 10,
    r11 = 11,
    r12 = 12,
    r13 = 13,
    r14 = 14,
    none = 15,
};

pub const OpCode = enum(u4) {
    halt = 0,
    nop = 1,
    rrmovq = 2,
    irmovq = 3,
    rmmovq = 4,
    mrmovq = 5,
    alu = 6,
    jmp = 7,
    call = 8,
    ret = 9,
    pushq = 10,
    popq = 11,
};

pub const AluOp = enum(u4) {
    add = 0,
    sub = 1,
    and_op = 2,
    xor_op = 3,
};

pub const Condition = enum(u4) {
    always = 0,
    le = 1,
    l = 2,
    e = 3,
    ne = 4,
    ge = 5,
    g = 6,
};

pub const Instruction = struct {
    opcode: OpCode,
    ifun: u4,
    ra: Register,
    rb: Register,
    val_c: u64,
    size: usize,
};

pub const HazardAction = enum {
    normal,
    forward_from_execute,
    forward_from_memory,
    stall_load_use,
};

pub const DecodeError = error {
    InvalidOpcode,
    InvalidRegister,
    BufferTooShort,
};

pub fn decode(bytes: []const u8) DecodeError!Instruction {
    if (bytes.len == 0) return DecodeError.BufferTooShort;

    const icode_raw: u4 = @truncate(bytes[0] >> 4);
    const ifun_raw: u4 = @truncate(bytes[0] & 0x0F);

    const opcode = std.enums.fromInt(OpCode, icode_raw) orelse return DecodeError.InvalidOpcode;
    
    var instr = Instruction {
        .opcode = opcode,
        .ifun = ifun_raw,
        .ra = .none,
        .rb = .none,
        .val_c = 0,
        .size = 1,
    };

    switch (opcode) {
        .halt, .nop, .ret => {
            instr.size = 1;
        },
        .rrmovq, .alu => {
            if (bytes.len < 2) return DecodeError.BufferTooShort;
            instr.ra = std.enums.fromInt(Register, @as(u4, @truncate(bytes[1] >> 4))) orelse return DecodeError.InvalidRegister;
            instr.rb = std.enums.fromInt(Register, @as(u4, @truncate(bytes[1] & 0x0F))) orelse return DecodeError.InvalidRegister;
            instr.size = 2;
        },
        .irmovq, .rmmovq, .mrmovq => {
            if (bytes.len < 10) return DecodeError.BufferTooShort;
            instr.ra = std.enums.fromInt(Register, @as(u4, @truncate(bytes[1] >> 4))) orelse return DecodeError.InvalidRegister;
            instr.rb = std.enums.fromInt(Register, @as(u4, @truncate(bytes[1] & 0x0F))) orelse return DecodeError.InvalidRegister;
            instr.val_c = std.mem.readInt(u64, bytes[2..10], .little);
            instr.size = 10;
        },
        .jmp, .call => {
            if (bytes.len < 9) return DecodeError.BufferTooShort;
            instr.val_c = std.mem.readInt(u64, bytes[1..9], .little);
            instr.size = 9;
        },
        .pushq, .popq => {
            if (bytes.len < 2) return DecodeError.BufferTooShort;
            instr.ra = std.enums.fromInt(Register, @as(u4, @truncate(bytes[1] >> 4))) orelse return DecodeError.InvalidRegister;
            instr.rb = std.enums.fromInt(Register, @as(u4, @truncate(bytes[1] & 0x0F))) orelse return DecodeError.InvalidRegister;
            instr.size = 2;
        },
    }
    return instr;
}

pub fn detectHazard(
    current: Instruction,
    prev_in_exec: ?Instruction,
    prev_in_mem: ?Instruction,
) HazardAction {
        if (prev_in_exec) |prev| {
            if (prev.opcode == .mrmovq or prev.opcode == .popq) {
                const dest_reg = prev.ra;
                if (dest_reg != .none) {
                    if (current.ra == dest_reg or current.rb == dest_reg) {
                        return .stall_load_use;
                    }
                }
            }
        }
        if (prev_in_exec) |prev| {
            const dest_reg = if (prev.opcode == .irmovq or prev.opcode == .rrmovq or prev.opcode == .alu) prev.rb else .none;
            if (dest_reg != .none and (current.ra == dest_reg or current.rb == dest_reg)) {
                return .forward_from_execute;
            }
        }
        if (prev_in_mem) |prev| {
            const dest_reg = if (prev.opcode == .mrmovq) prev.ra else prev.rb;
            if (dest_reg != .none and (current.ra == dest_reg or current.rb == dest_reg)) {
                return .forward_from_memory;
            } 
        }
        return .normal;
    }

pub fn main() !void {
    const instr_irmovq = try decode(&[_]u8{ 0x30, 0xF0, 10, 0, 0, 0, 0, 0, 0, 0 }); 
    const instr_addq = try decode(&[_]u8{ 0x60, 0x03 }); 

    // If the instruction currently in the Execute stage
    // has already calculated a value in the ALU (irmovq/alu),
    // and the next instruction needs that value immediately,
    // the processor forwards it directly via a dedicated path (forward_from_execute),
    //  without waiting for it to be written to the register file.

    const hazard1 = detectHazard(
        instr_addq, 
        instr_irmovq, 
        null, 
    );

    std.debug.print("Case 1 (irmovq -> addq): {s}\n", .{@tagName(hazard1)});
    const instr_mrmovq = try decode(&[_]u8{ 0x50, 0x04, 0, 0, 0, 0, 0, 0, 0, 0 }); 

    // If an instruction only reads data from memory (e.g., `mrmovq`),
    // that data is not yet physically available at the Execute stage.
    // It is impossible to forward data "from the future."
    // Consequently, the processor is forced to freeze the pipeline
    // for one clock cycle (a stall_load_use or bubble).

    const hazard2 = detectHazard(
        instr_addq, 
        instr_mrmovq, 
        null, 
    );
    std.debug.print("Case 2 (mrmovq -> addq): {s}\n", .{@tagName(hazard2)});
}
