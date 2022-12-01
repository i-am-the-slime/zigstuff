const c = @cImport({
    @cInclude("rtmidi_c.h");
});
pub const RtMidiApi = c.RtMidiApi;
pub const RtMidiInPtr = c.RtMidiInPtr;
const std = @import("std");
const assert = @import("std").debug.assert;

pub const MaxMessageSize = 64 * 1024;

pub const Message = struct {
    device: c.RtMidiInPtr,
    message: []const u8,
};

pub fn getCompiledAPIs(allocator: *std.mem.Allocator) ![]const RtMidiApi {
    const num_apis = c.rtmidi_get_compiled_api(null, 0);
    const apis = try allocator.alloc(c.RtMidiApi, @intCast(usize, num_apis));
    // defer allocator.free(apis);
    const result = c.rtmidi_get_compiled_api(apis.ptr, @intCast(c_uint, num_apis));
    assert(result >= 0);
    return apis[0..@intCast(usize, num_apis)];
}

pub fn newMIDIIn(api: c.RtMidiApi, name: [*c]const u8, queueSize: u32) !c.RtMidiInPtr {
    const in = c.rtmidi_in_create(api, name, @intCast(c_uint, queueSize));
    if (!in.*.ok) {
        std.debug.print("rtmidi_in_create failed with: {}\n", .{in.*.msg.*});
    }
    return in;
}

pub fn getMessage(in: c.RtMidiInPtr, msg: *[]u8) f64 {
    var result = c.rtmidi_in_get_message(in, msg.*.ptr, &msg.len);
    if (!in.*.ok) {
        std.debug.print("rtmidi_in_get_message failed with: {}\n", .{in.*.msg.*});
    }
    return result;
}

pub const RtMidiCallback = fn (f64, [*c]const u8, usize, ?*anyopaque) callconv(.C) void;

pub fn setCallback(
    in: c.RtMidiInPtr,
    callback: * const RtMidiCallback,
    userData: *anyopaque,
) void {
    c.rtmidi_in_set_callback(in, callback, userData);
}

pub fn openPort(m: c.RtMidiInPtr, port: u32, name: [*c]const u8) void {
    c.rtmidi_open_port(m, @intCast(c_uint, port), name);
}

pub fn getPortCount(ptr: c.RtMidiInPtr) c_uint {
    return c.rtmidi_get_port_count(ptr);
}

pub fn ignoreTypes(m: c.RtMidiInPtr, midiSysex: bool, midiTime: bool, midiSense: bool) void {
    c.rtmidi_in_ignore_types(m, midiSysex, midiTime, midiSense);
}
