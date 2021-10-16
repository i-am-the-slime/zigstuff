const c = @import("sdl.zig").c;
const assert = @import("std").debug.assert;
const std = @import("std");
const mkTestLevel = @import("levels/testlevel.zig").mkTestLevel;
const Level = @import("levels/testlevel.zig").Level;
const input = @import("game/input.zig");
const GameMidi = @import("game/game_midi.zig").GameMidi;
const constants = @import("constants.zig");

pub fn main() !void {
    var allocator = std.testing.allocator;
    var gameInput = try input.GameInput.init(allocator);
    defer gameInput.deinit();
    if (c.SDL_Init(c.SDL_INIT_VIDEO) != 0) {
        c.SDL_Log("Unable to initialize SDL: %s", c.SDL_GetError());
        return error.SDLInitializationFailed;
    }
    defer c.SDL_Quit();

    var gameMidi = try GameMidi(input.GameInput).init(
        allocator,
        &input.onMidiMessage,
        &gameInput,
    );

    gameMidi.registerCallback();

    var rend = try Renderer.init(allocator);
    defer rend.deinit();
    mainloop: while (true) {
        var event: c.SDL_Event = undefined;
        while (c.SDL_PollEvent(&event) != 0) {
            switch (event.@"type") {
                c.SDL_QUIT => break :mainloop,
                else => {},
            }
        }
        gameInput.updateInputState(gameMidi.in != null and gameMidi.callbackAndData != null);
        try rend.updateAndRender(gameInput.inputState);
    }
}

const Renderer = struct {
    const maxFPS = 120.0;
    const targetDeltaBetweenFrames: f64 = 1.0 / maxFPS;
    now: u64 = undefined,
    last: u64 = 0,
    deltaTime: f64 = 0.0,
    screen: *c.SDL_Window,
    renderer: *c.SDL_Renderer,
    spriteTexture: *c.SDL_Texture,
    backgroundTexture: *c.SDL_Texture,
    level: Level,

    pub fn deinit(self: @This()) void {
        defer c.SDL_DestroyWindow(self.screen);
        defer c.SDL_DestroyRenderer(self.renderer);
        defer c.SDL_DestroyTexture(self.backgroundTexture);
        defer c.SDL_DestroyTexture(self.spriteTexture);
    }

    pub fn init(allocator: *std.mem.Allocator) !@This() {
        const screen: *c.SDL_Window = c.SDL_CreateWindow(
            "---",
            c.SDL_WINDOWPOS_UNDEFINED,
            c.SDL_WINDOWPOS_UNDEFINED,
            constants.MAP_WIDTH_IN_TILES * constants.TILE_SIZE * constants.SCALE,
            constants.MAP_HEIGHT_IN_TILES * constants.TILE_SIZE * constants.SCALE,
            c.SDL_WINDOW_OPENGL,
        ) orelse {
            c.SDL_Log("Unable to create window: %s", c.SDL_GetError());
            return error.SDLInitializationFailed;
        };

        const renderer = c.SDL_CreateRenderer(screen, -1, c.SDL_RENDERER_ACCELERATED) orelse {
            c.SDL_Log("Unable to create renderer: %s", c.SDL_GetError());
            return error.SDLInitializationFailed;
        };

        // assert(c.SDL_RenderSetScale(renderer, 4, 4) == 0);

        // Load the sprite sheet
        const sheet = @embedFile("../assets/sheet.bmp");
        const rw = c.SDL_RWFromConstMem(
            @ptrCast(*const c_void, &sheet[0]),
            @intCast(c_int, sheet.len),
        ) orelse {
            c.SDL_Log("Unable to get RWFromConstMem: %s", c.SDL_GetError());
            return error.SDLInitializationFailed;
        };
        defer assert(c.SDL_RWclose(rw) == 0);

        const spriteSurface = c.SDL_LoadBMP_RW(rw, 0) orelse {
            c.SDL_Log("Unable to load bmp: %s", c.SDL_GetError());
            return error.SDLInitializationFailed;
        };
        defer c.SDL_FreeSurface(spriteSurface);

        // This doesn't work: c.SDL_MapRGB(...)
        const transparentCol: u32 = 0xe0_f8_cf;
        // Set the transparent colour
        assert(c.SDL_SetColorKey(spriteSurface, c.SDL_TRUE, transparentCol) == 0);

        const spriteTexture = c.SDL_CreateTextureFromSurface(renderer, spriteSurface) orelse {
            c.SDL_Log("Unable to create spriteTexture from spriteSurface: %s", c.SDL_GetError());
            return error.SDLInitializationFailed;
        };

        // Load the background
        const rw2 = c.SDL_RWFromConstMem(
            @ptrCast(*const c_void, &sheet[0]),
            @intCast(c_int, sheet.len),
        ) orelse {
            c.SDL_Log("Unable to get RWFromConstMem: %s", c.SDL_GetError());
            return error.SDLInitializationFailed;
        };
        defer assert(c.SDL_RWclose(rw2) == 0);
        const backgroundSurface = c.SDL_LoadBMP_RW(rw2, 0) orelse {
            c.SDL_Log("Unable to load bmp: %s", c.SDL_GetError());
            return error.SDLInitializationFailed;
        };
        defer c.SDL_FreeSurface(backgroundSurface); // Do this earlier?

        const backgroundTexture = c.SDL_CreateTextureFromSurface(renderer, backgroundSurface) orelse {
            c.SDL_Log("Unable to create spriteTexture from spriteSurface: %s", c.SDL_GetError());
            return error.SDLInitializationFailed;
        };

        return Renderer{
            .screen = screen,
            .renderer = renderer,
            .spriteTexture = spriteTexture,
            .backgroundTexture = backgroundTexture,
            .now = c.SDL_GetPerformanceCounter(),
            .level = mkTestLevel(allocator),
        };
    }

    fn updateAndRender(self: *@This(), inputState: input.State) !void {
        self.last = self.now;
        self.now = c.SDL_GetPerformanceCounter();
        self.deltaTime =
            @intToFloat(f64, (self.now - self.last)) /
            @intToFloat(f64, c.SDL_GetPerformanceFrequency());
        self.level.updateAndRender(inputState, self.deltaTime);

        _ = c.SDL_RenderClear(self.renderer);
        try self.level.render(self.renderer, self.backgroundTexture, self.spriteTexture);
        c.SDL_RenderPresent(self.renderer);
        const delayBy = std.math.max(0, targetDeltaBetweenFrames - self.deltaTime);
        c.SDL_Delay(@floatToInt(u32, delayBy));
    }
};
