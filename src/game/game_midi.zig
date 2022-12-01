const std = @import("std");
const rtmidi = @import("../midi/rtmidi.zig");
const midi = @import("../midi/midi.zig");

pub fn MIDIMessageCallback(comptime A: type) type {
    return *const fn (midi.MidiMessage, *A) void;
}

pub fn CallbackAndData(comptime A: type) type {
    return struct {
        callback: MIDIMessageCallback(A),
        dataPtr: *A,
    };
}

// This is supposed to be the glue code between the MIDI library and the game.
// If we use some other midi library in the future, this file will need to be
// adjusted, but hopefully not the game logic.
pub fn GameMidi(comptime A: type) type {
    return struct {
        const Self = @This();
        const rtMidiCallback = mkRtMidiCallback(A);
        callbackAndData: ?CallbackAndData(A),
        in: ?rtmidi.RtMidiInPtr,
        pub fn init(allocator: *std.mem.Allocator, callback: MIDIMessageCallback(A), data: *A) !Self {
            const apis = try rtmidi.getCompiledAPIs(allocator);
            defer allocator.free(apis);
            var in: rtmidi.RtMidiInPtr = null;
            for (apis) |api| {
                in = try rtmidi.newMIDIIn(api, "Game Input", 1024);
                rtmidi.ignoreTypes(in, true, true, true);
                const count = rtmidi.getPortCount(in);
                if (count == 0) {
                    std.debug.print("No MIDI device found\n", .{});
                } else {
                    rtmidi.openPort(in, 0, "Game Input Port");
                    const cbData = CallbackAndData(A){
                        .callback = callback,
                        .dataPtr = data,
                    };
                    var self = Self{ .in = in, .callbackAndData = cbData };
                    return self;
                }
            }
            return Self{ .in = null, .callbackAndData = null };
        }
        pub fn registerCallback(self: *Self) void {
            if (self.in) |in| {
                if (self.callbackAndData) |_| {
                    rtmidi.setCallback(
                        in,
                        rtMidiCallback,
                        &self.callbackAndData,
                    );
                }
            }
        }
    };
}

fn mkRtMidiCallback(comptime A: type) rtmidi.RtMidiCallback {
    return (struct {
        fn f(_: f64, message: [*c]const u8, size: usize, userData: ?*anyopaque) callconv(.C) void {
            var callbackAndData = @ptrCast(
                *CallbackAndData(A),
                @alignCast(
                    @alignOf(*CallbackAndData(A)),
                    userData.?,
                ),
            );
            const callback = callbackAndData.*.callback;
            const dataPtr = callbackAndData.*.dataPtr;
            var slice = message[0..size];
            const maybeMsg = midi.decodeMessage(slice);
            if (maybeMsg) |msg| callback(msg, dataPtr);
        }
    }).f;
}
