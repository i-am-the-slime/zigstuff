const c = @import("../sdl.zig").c;
const constants = @import("../constants.zig");
const graphics = @import("../game/graphics.zig");
const input = @import("../game/input.zig");
const std = @import("std");
const startroom = @import("./startroom.zig");
const AnimatedSprite = @import("../graphics/animated_sprite.zig").AnimatedSprite;
const Keyframe = @import("../graphics/animated_sprite.zig").Keyframe;
const player = @import("../game/player.zig");
const Vec2 = @import("../math/vector.zig").Vec2;
const tile = @import("./tiles.zig");
const text = @import("../game/text.zig");
const renderText = @import("../graphics/text.zig").renderText;
const game_state = @import("../game/game_state.zig");
const tileRenderer = @import("../graphics/tile_renderer.zig").TileRenderer;

const BackgroundLayer = struct {
    const Self = @This();
    objects: []*const graphics.Object,
    pub fn tileAtPoint(self: Self, x: f32, y: f32) ?*const graphics.Tile {
        self.objects[((y / constants.SCALE) * self.width + (x / constants.SCALE)) / 16];
    }
};

const SpriteLayer = struct {
    sprites: []*graphics.Sprite,
};

pub const Level = struct {
    const Self = @This();
    var srcRect = c.SDL_Rect{ .x = 0, .y = 0, .w = constants.TILE_SIZE, .h = constants.TILE_SIZE };
    var dstRect = c.SDL_FRect{ .x = 0, .y = 0, .w = constants.TILE_SIZE * constants.SCALE, .h = constants.TILE_SIZE * constants.SCALE };
    const tileSizeInPx: f32 = constants.TILE_SIZE * constants.SCALE;
    allocator: *std.mem.Allocator,
    backgroundLayer: BackgroundLayer,
    spriteLayer: SpriteLayer,
    inline fn setRects(t: *const graphics.Tile, x: f32, y: f32) void {
        srcRect.x = t.srcX;
        srcRect.y = t.srcY;
        srcRect.w = t.width;
        srcRect.h = t.height;
        dstRect.x = x;
        dstRect.y = y;
        dstRect.w = @intToFloat(f32, t.width * constants.SCALE);
        dstRect.h = @intToFloat(f32, t.height * constants.SCALE);
    }
    pub fn updateAndRender(
        self: Self,
        inputState: input.State,
        gameState: *game_state.GameState,
        deltaTime: f64,
    ) void {
        switch (gameState.*) {
            game_state.GameState.InGame => for (self.spriteLayer.sprites) |sprite|
                sprite.update(inputState, deltaTime),
            else => for (self.spriteLayer.sprites) |sprite|
                sprite.update(inputState, deltaTime),
        }
    }
    pub fn render(
        self: Self,
        renderer: *c.SDL_Renderer,
        backgroundTexture: *c.SDL_Texture,
        spriteTexture: *c.SDL_Texture,
    ) !void {
        for (self.backgroundLayer.objects) |object| {
            setRects(object.tile, object.position.x * tileSizeInPx, object.position.y * tileSizeInPx);
            _ = c.SDL_RenderCopyF(renderer, backgroundTexture, &srcRect, &dstRect);
        }
        for (self.spriteLayer.sprites) |sprite| {
            setRects(sprite.tile, sprite.posX, sprite.posY);
            _ = c.SDL_RenderCopyF(renderer, spriteTexture, &srcRect, &dstRect);
        }
        // renderText(self.allocator);
    }
};

var sprites = [_]*graphics.Sprite{
    &player.playerSprite,
};

pub fn mkTestLevel(allocator: *std.mem.Allocator) Level {
    return Level{
        .allocator = allocator,
        .backgroundLayer = .{ .objects = &startroom.background },
        .spriteLayer = .{ .sprites = &sprites },
    };
}

inline fn between(min: f32, x: f32, max: f32) bool {
    return x >= min and x <= max;
}
