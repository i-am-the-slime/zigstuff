const constants = @import("../constants.zig");
const input = @import("input.zig");
const Vec2 = @Vector(2, f32);

pub const Object = struct {
    const Self = @This();
    position: Vec2,
    tile: *const Tile,
};

const UpdateFn = fn (self: *Sprite, inputState: input.State, deltaTime: f64) void;

pub const Sprite = struct {
    posX: f32,
    posY: f32,
    tile: *Tile,
    updateFn: *const UpdateFn,
    // pub fn update(self: *@This(), inputState: input.State, deltaTime: f64) void {
    //     self.updateFn(self, inputState, deltaTime);
    // }
};

pub const Tile = struct {
    srcX: u8,
    srcY: u8,
    width: i32 = 16,
    height: i32 = 16,
    collision: ?Collision,
};

pub fn Rect(comptime size: comptime_int) type {
    return struct {
        const Self = @This();
        x: u32,
        y: u32,
        fn intersects(otherSize: comptime_int, self: *Self, other: *Rect(otherSize)) bool {
            const result =
                self.x < other.x + otherSize and
                self.x + size > other.x and
                self.y < other.y + otherSize and
                self.y + size > other.y;
            return result;
        }
    };
}

pub const Collision = packed struct {
    top: bool = false,
    bottom: bool = false,
    left: bool = false,
    right: bool = false,
};

pub const collideAll = Collision{
    .top = true,
    .bottom = true,
    .left = true,
    .right = true,
};

pub const collideBottom = Collision{ .bottom = true };
pub const collideTop = Collision{ .top = true };
pub const collideLeft = Collision{ .left = true };
pub const collideRight = Collision{ .right = true };

pub inline fn mkTile(x: u8, y: u8, collision: ?Collision) Tile {
    return Tile{ .srcX = x, .srcY = y, .collision = collision };
}

pub inline fn mkTile8(x: u8, y: u8, collision: ?Collision) Tile {
    return Tile{ .srcX = x, .srcY = y, .width = 8, .height = 8, .collision = collision };
}

pub inline fn mkTile8w(x: u8, y: u8, w: i32, collision: ?Collision) Tile {
    return Tile{ .srcX = x, .srcY = y, .width = w, .height = 8, .collision = collision };
}

pub inline fn mkSprite(
    x: f32,
    y: f32,
    tile: *Tile,
    comptime update: *const UpdateFn,
) Sprite {
    return Sprite{ .posX = x, .posY = y, .tile = tile, .updateFn = update };
}
