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
        deltaTime: f64,
    ) void {
        for (self.spriteLayer.sprites) |sprite| {
            sprite.update(inputState, deltaTime);
        }
    }
    pub fn render(self: Self, renderer: *c.SDL_Renderer, backgroundTexture: *c.SDL_Texture, spriteTexture: *c.SDL_Texture) !void {
        for (self.backgroundLayer.objects) |object| {
            setRects(object.tile, object.position.x * tileSizeInPx, object.position.y * tileSizeInPx);
            _ = c.SDL_RenderCopyF(renderer, backgroundTexture, &srcRect, &dstRect);
        }
        for (self.spriteLayer.sprites) |sprite| {
            setRects(sprite.tile, sprite.posX, sprite.posY);
            _ = c.SDL_RenderCopyF(renderer, spriteTexture, &srcRect, &dstRect);
        }

        const lineGap = constants.TILE_SIZE * constants.SCALE * 0.5;
        const lineHeight = constants.TILE_SIZE * constants.SCALE + lineGap;
        const lines = try text.tilesToLines(
            self.allocator,
            "Here is some long ass text that should wrap eventually into multiple lines",
            constants.MAP_WIDTH_IN_TILES * constants.TILE_SIZE * constants.SCALE,
            lineHeight,
        );
        const yOffset = (constants.MAP_HEIGHT_IN_TILES - 3) * constants.TILE_SIZE * constants.SCALE - (2 * lineGap);
        for (lines.items) |line| {
            for (line.items) |obj| {
                setRects(obj.tile, obj.position.x, obj.position.y + yOffset);
                _ = c.SDL_RenderCopyF(renderer, spriteTexture, &srcRect, &dstRect);
            }
            line.deinit();
        }
        lines.deinit();
        // const padX = 2;
        // var x: f32 = padX * tileSizeInPx;
        // var y: f32 = 8 * tileSizeInPx;
        // const letterTiles = try text.textToTile(self.allocator, "Hi, hast du vielleicht den Arsch auf? Ich denke, so wird das leider nichts mit uns!");
        // for (letterTiles) |letterTile, i| {
        //     setRects(letterTile, x, y);
        //     _ = c.SDL_RenderCopyF(renderer, spriteTexture, &srcRect, &dstRect);
        //     x += (@intToFloat(f32, letterTile.width)) * constants.SCALE;
        //     if (x >= ((constants.MAP_WIDTH_IN_TILES - padX) * constants.TILE_SIZE * constants.SCALE)) {
        //         x = padX * tileSizeInPx;
        //         y += @intToFloat(f32, letterTile.height) * constants.SCALE;
        //     }
        // }
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
