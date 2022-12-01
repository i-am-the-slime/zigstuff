const c = @import("../sdl.zig").c;
const constants = @import("../constants.zig");
const graphics = @import("../game/graphics.zig");
const tile_renderer = @import("./tile_renderer.zig");
const text = @import("../game/text.zig");
const tile = @import("../levels/tiles.zig");
const std = @import("std");

pub const TextRenderer = struct {
    const Self = @This();
    allocator: *std.mem.Allocator,
    tileRenderer: tile_renderer.TileRenderer,

    pub fn init(allocator: *std.mem.Allocator) !Self {
        return Self{
            .allocator = allocator,
            .tileRenderer = tile_renderer.TileRenderer.init(),
        };
    }

    pub fn renderText(
        self: *Self,
        renderer: *c.SDL_Renderer,
        texture: *c.SDL_Texture,
        textToRender: *const []const u8,
    ) !void {
        const lineGap = constants.SCALED_TILE_SIZE * 0.5;
        const lineHeight = constants.SCALED_TILE_SIZE + lineGap;
        const xOffset = constants.SCALED_TILE_SIZE;
        const yOffset = (constants.MAP_HEIGHT_IN_TILES - 3) * constants.SCALED_TILE_SIZE - (2 * lineGap);
        const allLines = try text.tilesToLines(
            self.allocator,
            textToRender,
            (constants.MAP_WIDTH_IN_TILES) * constants.SCALED_TILE_SIZE - (2 * xOffset),
            lineHeight,
        );
        const lineBuckets = try text.bucketise(
            std.ArrayList(graphics.Object),
            self.allocator,
            allLines,
            2,
        );
        const lines = lineBuckets.items[0]; // TODO: Don't fix to first line
        // const lines = allLines;
        // Draw text border:
        if (lines.items.len > 0) {
            for ([_]u0{0} ** constants.MAP_WIDTH_IN_TILES) |_, x| {
                for ([_]u0{0} ** 5) |_, y| {
                    const borderTile: *const graphics.Tile =
                        if (x == 0 and y == 0) &tile.textBorderTopLeft else if (x == constants.MAP_WIDTH_IN_TILES - 1 and y == 0) &tile.textBorderTopRight else if (x == 0 and y == 4) &tile.textBorderBottomLeft else if (x == constants.MAP_WIDTH_IN_TILES - 1 and y == 4) &tile.textBorderBottomRight else if (x == 0) &tile.textBorderLeft else if (x == constants.MAP_WIDTH_IN_TILES - 1) &tile.textBorderRight else if (y == 0) &tile.textBorderTop else if (y == 4) &tile.textBorderBottom else &tile.textBackgroundBlank;
                    self.tileRenderer.render(
                        renderer,
                        texture,
                        borderTile,
                        @intToFloat(f32, x) * constants.SCALED_TILE_SIZE,
                        @intToFloat(f32, y) * constants.SCALED_TILE_SIZE +
                            yOffset - constants.SCALED_TILE_SIZE,
                    );
                }
            }
        }
        for (lines.items) |line| {
            for (line.items) |obj| {
                self.tileRenderer.render(
                    renderer,
                    texture,
                    obj.tile,
                    obj.position[0] + xOffset,
                    obj.position[1] + yOffset,
                );
            }
            line.deinit();
        }
        lines.deinit();
    }
};
