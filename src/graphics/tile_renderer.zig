const std = @import("std");
const c = @import("../sdl.zig").c;
const constants = @import("../constants.zig");
const graphics = @import("../game/graphics.zig");

pub const TileRenderer = struct {
    const Self = @This();
    srcRect: c.SDL_Rect,
    dstRect: c.SDL_FRect,

    pub fn init() Self {
        return Self{
            .srcRect = c.SDL_Rect{
                .x = 0,
                .y = 0,
                .w = constants.TILE_SIZE,
                .h = constants.TILE_SIZE,
            },
            .dstRect = c.SDL_FRect{
                .x = 0,
                .y = 0,
                .w = constants.TILE_SIZE * constants.SCALE,
                .h = constants.TILE_SIZE * constants.SCALE,
            },
        };
    }

    pub fn render(
        self: *Self,
        renderer: *c.SDL_Renderer,
        texture: *c.SDL_Texture,
        tile: *const graphics.Tile,
        x: f32,
        y: f32,
    ) void {
        self.srcRect.x = tile.srcX;
        self.srcRect.y = tile.srcY;
        self.srcRect.w = tile.width;
        self.srcRect.h = tile.height;
        self.dstRect.x = x;
        self.dstRect.y = y;
        self.dstRect.w = @intToFloat(f32, tile.width * constants.SCALE);
        self.dstRect.h = @intToFloat(f32, tile.height * constants.SCALE);
        _ = c.SDL_RenderCopyF(
            renderer,
            texture,
            &self.srcRect,
            &self.dstRect,
        );
    }
};
