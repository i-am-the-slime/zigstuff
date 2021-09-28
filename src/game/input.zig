const c = @import("../sdl.zig").c;
const std = @import("std");

pub const State = packed struct {
    walkingUp: bool = false,
    walkingDown: bool = false,
    walkingLeft: bool = false,
    walkingRight: bool = false,
};

pub const EventArray = [10:null]?*c.SDL_Event;

pub fn updateInputState(events: *const EventArray, inputState: *State) void {
    var i: u8 = 0;
    var event = events[i];
    while (event != null) {
        switch (event.?.@"type") {
            c.SDL_KEYDOWN => switch (event.?.key.keysym.sym) {
                c.SDLK_UP => inputState.walkingUp = true,
                c.SDLK_DOWN => inputState.walkingDown = true,
                c.SDLK_LEFT => inputState.walkingLeft = true,
                c.SDLK_RIGHT => inputState.walkingRight = true,
                else => {},
            },
            c.SDL_KEYUP => switch (event.?.key.keysym.sym) {
                c.SDLK_UP => inputState.walkingUp = false,
                c.SDLK_DOWN => inputState.walkingDown = false,
                c.SDLK_LEFT => inputState.walkingLeft = false,
                c.SDLK_RIGHT => inputState.walkingRight = false,
                else => {},
            },
            else => {},
        }
        i += 1;
        event = events[i];
    }
}
