const c = @import("../sdl.zig").c;
const constants = @import("../constants.zig");
const graphics = @import("../game/graphics.zig");
const input = @import("../game/input.zig");
const std = @import("std");

const BackgroundLayer = struct {
    objects: []graphics.Object,
};

const SpriteLayer = struct {
    sprites: []*graphics.Sprite,
};

const Level = struct {
    backgroundLayer: BackgroundLayer,
    spriteLayer: SpriteLayer,
    pub fn update(
        self: @This(),
        inputState: input.State,
    ) void {
        for (self.spriteLayer.sprites) |sprite| {
            sprite.update(inputState);
        }
    }
    pub fn render(self: @This(), renderer: *c.SDL_Renderer, backgroundTexture: *c.SDL_Texture, spriteTexture: *c.SDL_Texture) void {
        var srcRect = c.SDL_Rect{ .x = 0, .y = 0, .w = 16, .h = 16 };
        var dstRect = c.SDL_Rect{ .x = 0, .y = 0, .w = 16 * constants.SCALE, .h = 16 * constants.SCALE };
        for (self.backgroundLayer.objects) |object| {
            srcRect.x = object.tile.srcX * 16;
            srcRect.y = object.tile.srcY * 16;
            dstRect.x = object.posX * constants.SCALE;
            dstRect.y = object.posY * constants.SCALE;
            _ = c.SDL_RenderCopy(renderer, backgroundTexture, &srcRect, &dstRect);
        }
        for (self.spriteLayer.sprites) |sprite| {
            srcRect.x = sprite.tile.srcX * 16;
            srcRect.y = sprite.tile.srcY * 16;
            dstRect.x = @floatToInt(c_int, sprite.posX);
            dstRect.y = @floatToInt(c_int, sprite.posY);
            _ = c.SDL_RenderCopy(renderer, spriteTexture, &srcRect, &dstRect);
        }
    }
};

const wallTopLeft = graphics.mkTile(0, 13);
const wallTop = graphics.mkTile(1, 13);
const wallTopRight = graphics.mkTile(2, 13);
const wallLeft = graphics.mkTile(0, 14);
const floor = graphics.mkTile(1, 14);
const wallRight = graphics.mkTile(2, 14);
const wallBottomLeft = graphics.mkTile(0, 15);
const wallBottom = graphics.mkTile(1, 15);
const wallBottomRight = graphics.mkTile(2, 15);
const doorTop = graphics.mkTile(4, 15);

var backgroundObjects = [_]graphics.Object{
    // First line
    graphics.mkObject(0, 0, &wallTopLeft),
    graphics.mkObject(16, 0, &wallTop),
    graphics.mkObject(32, 0, &wallTop),
    graphics.mkObject(48, 0, &wallTop),
    graphics.mkObject(64, 0, &wallTop),
    graphics.mkObject(80, 0, &wallTop),
    graphics.mkObject(96, 0, &wallTop),
    graphics.mkObject(112, 0, &wallTop),
    graphics.mkObject(128, 0, &doorTop),
    graphics.mkObject(144, 0, &wallTop),
    graphics.mkObject(160, 0, &wallTop),
    graphics.mkObject(176, 0, &wallTop),
    graphics.mkObject(192, 0, &wallTop),
    graphics.mkObject(208, 0, &wallTop),
    graphics.mkObject(224, 0, &wallTop),
    graphics.mkObject(240, 0, &wallTopRight),
    // Second line
    graphics.mkObject(0, 16, &wallLeft),
    graphics.mkObject(16, 16, &floor),
    graphics.mkObject(32, 16, &floor),
    graphics.mkObject(48, 16, &floor),
    graphics.mkObject(64, 16, &floor),
    graphics.mkObject(80, 16, &floor),
    graphics.mkObject(96, 16, &floor),
    graphics.mkObject(112, 16, &floor),
    graphics.mkObject(128, 16, &floor),
    graphics.mkObject(144, 16, &floor),
    graphics.mkObject(160, 16, &floor),
    graphics.mkObject(176, 16, &floor),
    graphics.mkObject(192, 16, &floor),
    graphics.mkObject(208, 16, &floor),
    graphics.mkObject(224, 16, &floor),
    graphics.mkObject(240, 16, &wallRight),
    // Third line
    graphics.mkObject(0, 32, &wallLeft),
    graphics.mkObject(16, 32, &floor),
    graphics.mkObject(32, 32, &floor),
    graphics.mkObject(48, 32, &floor),
    graphics.mkObject(64, 32, &floor),
    graphics.mkObject(80, 32, &floor),
    graphics.mkObject(96, 32, &floor),
    graphics.mkObject(112, 32, &floor),
    graphics.mkObject(128, 32, &floor),
    graphics.mkObject(144, 32, &floor),
    graphics.mkObject(160, 32, &floor),
    graphics.mkObject(176, 32, &floor),
    graphics.mkObject(192, 32, &floor),
    graphics.mkObject(208, 32, &floor),
    graphics.mkObject(224, 32, &floor),
    graphics.mkObject(240, 32, &wallRight),
    // Fourth line
    graphics.mkObject(0, 48, &wallLeft),
    graphics.mkObject(16, 48, &floor),
    graphics.mkObject(32, 48, &floor),
    graphics.mkObject(48, 48, &floor),
    graphics.mkObject(64, 48, &floor),
    graphics.mkObject(80, 48, &floor),
    graphics.mkObject(96, 48, &floor),
    graphics.mkObject(112, 48, &floor),
    graphics.mkObject(128, 48, &floor),
    graphics.mkObject(144, 48, &floor),
    graphics.mkObject(160, 48, &floor),
    graphics.mkObject(176, 48, &floor),
    graphics.mkObject(192, 48, &floor),
    graphics.mkObject(208, 48, &floor),
    graphics.mkObject(224, 48, &floor),
    graphics.mkObject(240, 48, &wallRight),
    // Fifth line
    graphics.mkObject(0, 64, &wallLeft),
    graphics.mkObject(16, 64, &floor),
    graphics.mkObject(32, 64, &floor),
    graphics.mkObject(48, 64, &floor),
    graphics.mkObject(64, 64, &floor),
    graphics.mkObject(80, 64, &floor),
    graphics.mkObject(96, 64, &floor),
    graphics.mkObject(112, 64, &floor),
    graphics.mkObject(128, 64, &floor),
    graphics.mkObject(144, 64, &floor),
    graphics.mkObject(160, 64, &floor),
    graphics.mkObject(176, 64, &floor),
    graphics.mkObject(192, 64, &floor),
    graphics.mkObject(208, 64, &floor),
    graphics.mkObject(224, 64, &floor),
    graphics.mkObject(240, 64, &wallRight),
    graphics.mkObject(0, 80, &wallLeft),
    graphics.mkObject(16, 80, &floor),
    graphics.mkObject(32, 80, &floor),
    graphics.mkObject(48, 80, &floor),
    graphics.mkObject(64, 80, &floor),
    graphics.mkObject(80, 80, &floor),
    graphics.mkObject(96, 80, &floor),
    graphics.mkObject(112, 80, &floor),
    graphics.mkObject(128, 80, &floor),
    graphics.mkObject(144, 80, &floor),
    graphics.mkObject(160, 80, &floor),
    graphics.mkObject(176, 80, &floor),
    graphics.mkObject(192, 80, &floor),
    graphics.mkObject(208, 80, &floor),
    graphics.mkObject(224, 80, &floor),
    graphics.mkObject(240, 80, &wallRight),
    graphics.mkObject(0, 96, &wallLeft),
    graphics.mkObject(16, 96, &floor),
    graphics.mkObject(32, 96, &floor),
    graphics.mkObject(48, 96, &floor),
    graphics.mkObject(64, 96, &floor),
    graphics.mkObject(80, 96, &floor),
    graphics.mkObject(96, 96, &floor),
    graphics.mkObject(112, 96, &floor),
    graphics.mkObject(128, 96, &floor),
    graphics.mkObject(144, 96, &floor),
    graphics.mkObject(160, 96, &floor),
    graphics.mkObject(176, 96, &floor),
    graphics.mkObject(192, 96, &floor),
    graphics.mkObject(208, 96, &floor),
    graphics.mkObject(224, 96, &floor),
    graphics.mkObject(240, 96, &wallRight),
    graphics.mkObject(0, 112, &wallLeft),
    graphics.mkObject(16, 112, &floor),
    graphics.mkObject(32, 112, &floor),
    graphics.mkObject(48, 112, &floor),
    graphics.mkObject(64, 112, &floor),
    graphics.mkObject(80, 112, &floor),
    graphics.mkObject(96, 112, &floor),
    graphics.mkObject(112, 112, &floor),
    graphics.mkObject(128, 112, &floor),
    graphics.mkObject(144, 112, &floor),
    graphics.mkObject(160, 112, &floor),
    graphics.mkObject(176, 112, &floor),
    graphics.mkObject(192, 112, &floor),
    graphics.mkObject(208, 112, &floor),
    graphics.mkObject(224, 112, &floor),
    graphics.mkObject(240, 112, &wallRight),
    graphics.mkObject(0, 128, &wallBottomLeft),
    graphics.mkObject(16, 128, &wallBottom),
    graphics.mkObject(32, 128, &wallBottom),
    graphics.mkObject(48, 128, &wallBottom),
    graphics.mkObject(64, 128, &wallBottom),
    graphics.mkObject(80, 128, &wallBottom),
    graphics.mkObject(96, 128, &wallBottom),
    graphics.mkObject(112, 128, &wallBottom),
    graphics.mkObject(128, 128, &wallBottom),
    graphics.mkObject(144, 128, &wallBottom),
    graphics.mkObject(160, 128, &wallBottom),
    graphics.mkObject(176, 128, &wallBottom),
    graphics.mkObject(192, 128, &wallBottom),
    graphics.mkObject(208, 128, &wallBottom),
    graphics.mkObject(224, 128, &wallBottom),
    graphics.mkObject(240, 128, &wallBottomRight),
};

var playerLookingDown = graphics.mkTile(0, 0);

const Vec2 = struct {
    x: f32,
    y: f32,
    pub fn len(self: @This()) f32 {
        return std.math.sqrt((self.x * self.x) + (self.y * self.y));
    }
    pub fn normalise(self: *@This()) void {
        const length = self.len();
        if (length != 0) {
            self.x /= length;
            self.y /= length;
        }
    }
};

const PlayerState = struct {
    directionVec: Vec2,
    direction: Direction,
    speed: Vec2,
    animationFrame: c_int,
};

var playerSprite = graphics.mkSprite(
    120,
    64,
    &playerLookingDown,
    updatePlayer,
);

var playerState = PlayerState{
    .directionVec = Vec2{ .x = 0, .y = 0 },
    .direction = Direction.Down,
    .speed = Vec2{ .x = 0, .y = 0 },
    .animationFrame = 0,
};

const playerAcceleration: f32 = 2.5; // (pixels per frame) per frame
const friction: f32 = 0.33; // (pixels per frame) per frame
const maxSpeed: f32 = 6.0; // pixels per frame

fn updatePlayer(
    sprite: *graphics.Sprite,
    inputState: input.State,
) void {
    const previousDirection = playerState.direction;
    playerState.directionVec.x = 0;
    playerState.directionVec.y = 0;
    if (inputState.walkingUp) playerState.directionVec.y -= 1;
    if (inputState.walkingDown) playerState.directionVec.y += 1;
    if (inputState.walkingLeft) playerState.directionVec.x -= 1;
    if (inputState.walkingRight) playerState.directionVec.x += 1;
    playerState.directionVec.normalise();
    // Calculate the new direction
    playerState.direction = vec2ToDirection(&playerState.directionVec) orelse previousDirection;
    switch (playerState.direction) {
        Direction.Down => sprite.tile.srcX = 0,
        Direction.Up => sprite.tile.srcX = 2,
        Direction.Left => sprite.tile.srcX = 4,
        Direction.Right => sprite.tile.srcX = 6,
    }
    // Calculate the new position
    // 1 px/frame + 1 px/frame * 0.1 ((px/frame)/frame)
    playerState.speed.x += std.math.clamp(
        playerState.speed.x +
            playerAcceleration * playerState.directionVec.x,
        -maxSpeed,
        maxSpeed,
    );
    playerState.speed.y += std.math.clamp(
        playerState.speed.y +
            playerAcceleration * playerState.directionVec.y,
        -maxSpeed,
        maxSpeed,
    );

    playerState.speed.x *= friction;
    playerState.speed.y *= friction;

    sprite.posX += playerState.speed.x;
    sprite.posY += playerState.speed.y;
}

const Direction = enum { Up, Down, Left, Right };

inline fn vec2ToDirection(vec2: *Vec2) ?Direction {
    if (vec2.x == 0 and vec2.y == 0)
        return null;
    if (vec2.x == 0 and vec2.y < 0)
        return Direction.Up;
    if (vec2.x == 0 and vec2.y > 0)
        return Direction.Down;
    if (vec2.x < 0)
        return Direction.Left;
    return Direction.Right;
}

var sprites = [_]*graphics.Sprite{
    &playerSprite,
};

pub const testlevel =
    Level{
    .backgroundLayer = .{ .objects = &backgroundObjects },
    .spriteLayer = .{ .sprites = &sprites },
};

const Collision = packed struct {
    top: bool = false,
    bottom: bool = false,
    left: bool = false,
    right: bool = false,
};

const collideAll = Collision{
    .top = true,
    .bottom = true,
    .left = true,
    .right = true,
};
