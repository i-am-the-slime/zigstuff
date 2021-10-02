const sdl = @import("../sdl.zig").c;
const midi = @import("../midi/midi.zig");
const game_midi = @import("../game/game_midi.zig");
const std = @import("std");

pub const State = packed struct {
    walkingUp: bool = false,
    walkingDown: bool = false,
    walkingLeft: bool = false,
    walkingRight: bool = false,
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

    pub fn updateInputState(self: *Self) void {
        // Fallback to computer keyboard input for testing
        const sdlState: [*c]const u8 = sdl.SDL_GetKeyboardState(null);
        self.inputState.walkingUp = sdlState[sdl.SDL_SCANCODE_UP] != 0;
        self.inputState.walkingDown = sdlState[sdl.SDL_SCANCODE_DOWN] != 0;
        self.inputState.walkingLeft = sdlState[sdl.SDL_SCANCODE_LEFT] != 0;
        self.inputState.walkingRight = sdlState[sdl.SDL_SCANCODE_RIGHT] != 0;
    }
};

var onMidiMessagePtr: *game_midi.MIDIMessageCallback(*GameInput) = &onMidiMessage;

pub fn onMidiMessage(msg: midi.MidiMessage, gi: *GameInput) void {
    switch (msg) {
        .noteOn => |noteOn| {
            const tone = midi.midiKeyToTone(noteOn.key);
            switch (tone.note) {
                midi.Note.C => gi.inputState.walkingLeft = true,
                midi.Note.D => gi.inputState.walkingDown = true,
                midi.Note.E => gi.inputState.walkingUp = true,
                midi.Note.F => gi.inputState.walkingRight = true,
                else => {},
            }
        },
        .noteOff => |noteOff| {
            const tone = midi.midiKeyToTone(noteOff.key);
            switch (tone.note) {
                midi.Note.C => gi.inputState.walkingLeft = false,
                midi.Note.D => gi.inputState.walkingDown = false,
                midi.Note.E => gi.inputState.walkingUp = false,
                midi.Note.F => gi.inputState.walkingRight = false,
                else => {},
            }
        },
    }
}
