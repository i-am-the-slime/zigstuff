const constants = @import("../constants.zig");
const input = @import("input.zig");

pub const Sprite = struct {
    posX: f32,
    posY: f32,
    tile: *Tile,
    updateFn: fn (self: *@This(), inputState: input.State) void,
    pub fn update(self: *@This(), inputState: input.State) void {
        self.updateFn(self, inputState);
    }
};

pub const Object = struct {
    posX: c_int,
    posY: c_int,
    tile: *const Tile,
};

pub const Tile = struct {
    srcX: u8,
    srcY: u8,
};

pub inline fn mkTile(x: u8, y: u8) Tile {
    return Tile{ .srcX = x, .srcY = y };
}

pub inline fn mkObject(x: c_int, y: c_int, tile: *const Tile) Object {
    return Object{ .posX = x, .posY = y, .tile = tile };
}

pub inline fn mkSprite(x: c_int, y: c_int, tile: *Tile, comptime update: fn (*Sprite, inputState: input.State) void) Sprite {
    return Sprite{ .posX = x, .posY = y, .tile = tile, .updateFn = update };
}
