const sdl = @import("../sdl.zig").c;
const midi = @import("../midi/midi.zig");
const game_midi = @import("../game/game_midi.zig");
const std = @import("std");
const game_state = @import("../game/game_state.zig");

pub const State = packed struct {
    up: bool = false,
    down: bool = false,
    left: bool = false,
    right: bool = false,
    action: bool = false,
    pause: bool = false,
};

pub const GameInput = struct {
    const Self = @This();
    allocator: *std.mem.Allocator,
    inputState: State,

    pub fn init(allocator: *std.mem.Allocator) !Self {
        var inputState = State{};

        return Self{
            .allocator = allocator,
            .inputState = inputState,
        };
    }

    pub fn deinit(_: *Self) void {}

    pub fn updateInputState(
        self: *Self,
        // gameState: *game_state.GameState,
        midiInputActive: bool,
    ) void {

        // Fallback to computer keyboard input for testing
        if (!midiInputActive) {
            const sdlState: [*c]const u8 = sdl.SDL_GetKeyboardState(null);
            self.inputState.up = sdlState[sdl.SDL_SCANCODE_UP] != 0;
            self.inputState.down = sdlState[sdl.SDL_SCANCODE_DOWN] != 0;
            self.inputState.left = sdlState[sdl.SDL_SCANCODE_LEFT] != 0;
            self.inputState.right = sdlState[sdl.SDL_SCANCODE_RIGHT] != 0;
            self.inputState.action = sdlState[sdl.SDL_SCANCODE_SPACE] != 0;
        }
    }
};

var onMidiMessagePtr: *game_midi.MIDIMessageCallback(*GameInput) = &onMidiMessage;

pub fn onMidiMessage(msg: midi.MidiMessage, gi: *GameInput) void {
    switch (msg) {
        .noteOn => |noteOn| {
            const tone = midi.midiKeyToTone(noteOn.key);
            std.debug.print("MIDI big boy: {s} \n", .{tone.note});
            switch (tone.note) {
                midi.Note.C => gi.inputState.left = true,
                midi.Note.D => gi.inputState.down = true,
                midi.Note.E => gi.inputState.up = true,
                midi.Note.F => gi.inputState.right = true,
                else => {},
            }
        },
        .noteOff => |noteOff| {
            const tone = midi.midiKeyToTone(noteOff.key);
            switch (tone.note) {
                midi.Note.C => gi.inputState.left = false,
                midi.Note.D => gi.inputState.down = false,
                midi.Note.E => gi.inputState.up = false,
                midi.Note.F => gi.inputState.right = false,
                else => {},
            }
        },
    }
}
