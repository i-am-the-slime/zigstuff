const AnimatedSprite = @import("../graphics/animated_sprite.zig").AnimatedSprite;
const Keyframe = @import("../graphics/animated_sprite.zig").Keyframe;
const graphics = @import("../game/graphics.zig");
const constants = @import("../constants.zig");
const TS = constants.TILE_SIZE;
const input = @import("../game/input.zig");
const std = @import("std");
const Vec2 = @import("../math/vector.zig").Vec2;

var playerLookingDown = graphics.mkTile(0, 0, null);

const PlayerState = struct {
    directionVec: Vec2,
    direction: Direction,
    speed: Vec2,
    animationFrame: c_int,
};

pub var playerSprite = graphics.mkSprite(
    240,
    128,
    &playerLookingDown,
    updatePlayer,
);

var playerState = PlayerState{
    .directionVec = Vec2{ .x = 0, .y = 0 },
    .direction = Direction.Down,
    .speed = Vec2{ .x = 0, .y = 0 },
    .animationFrame = 0,
};

const constantDeceleration: f32 = 1.0; // m/s/s
const playerAcceleration: f32 = 0.825 + constantDeceleration; // m/s/s
const maxSpeed: f32 = 1.35 * @intToFloat(f32, constants.SCALE); // m/s

const tileSizeInMetres = 1.5;

const keyframesWalkingDown: []const Keyframe = &.{
    .{ .srcX = 0 * TS, .srcY = 0 * TS, .duration = 0.15 },
    .{ .srcX = 2 * TS, .srcY = 0 * TS, .duration = 0.15 },
};
const keyframesWalkingUp: []const Keyframe = &.{
    .{ .srcX = 4 * TS, .srcY = 0 * TS, .duration = 0.15 },
    .{ .srcX = 6 * TS, .srcY = 0 * TS, .duration = 0.15 },
};
const keyframesWalkingLeft: []const Keyframe = &.{
    .{ .srcX = 8 * TS, .srcY = 0 * TS, .duration = 0.15 },
    .{ .srcX = 10 * TS, .srcY = 0 * TS, .duration = 0.15 },
};
const keyframesWalkingRight: []const Keyframe = &.{
    .{ .srcX = 12 * TS, .srcY = 0 * TS, .duration = 0.15 },
    .{ .srcX = 14 * TS, .srcY = 0 * TS, .duration = 0.15 },
};

var playerAnimation = AnimatedSprite.init(keyframesWalkingDown);

fn updatePlayer(
    sprite: *graphics.Sprite,
    inputState: input.State,
    deltaTime: f64,
) void {
    const previousDirection = playerState.direction;
    playerState.directionVec.x = 0;
    playerState.directionVec.y = 0;
    if (inputState.up) playerState.directionVec.y -= 1;
    if (inputState.down) playerState.directionVec.y += 1;
    if (inputState.left) playerState.directionVec.x -= 1;
    if (inputState.right) playerState.directionVec.x += 1;
    playerState.directionVec.normalise();
    // Calculate the new direction
    const newDirection = vec2ToDirection(&playerState.directionVec);
    playerState.direction = newDirection orelse previousDirection;
    if (previousDirection != newDirection) {
        switch (playerState.direction) {
            Direction.Down => playerAnimation.replace(keyframesWalkingDown),
            Direction.Up => playerAnimation.replace(keyframesWalkingUp),
            Direction.Left => playerAnimation.replace(keyframesWalkingLeft),
            Direction.Right => playerAnimation.replace(keyframesWalkingRight),
        }
        playerAnimation.rewind();
    }
    const nextFrame = playerAnimation.advance(deltaTime);
    sprite.tile.srcX = nextFrame.srcX;
    sprite.tile.srcY = nextFrame.srcY;
    // Calculate the new position
    // 1 px/frame + 1 px/frame * 0.1 ((px/frame)/frame)
    const accelerateBy = tileSizeInMetres / (playerAcceleration * @floatCast(f32, deltaTime));
    playerState.speed.x = std.math.clamp(
        @mulAdd(f32, accelerateBy, playerState.directionVec.x, playerState.speed.x),
        (-maxSpeed) * std.math.absFloat(playerState.directionVec.x),
        maxSpeed * std.math.absFloat(playerState.directionVec.x),
    );
    playerState.speed.y = std.math.clamp(
        @mulAdd(f32, accelerateBy, playerState.directionVec.y, playerState.speed.y),
        (-maxSpeed) * std.math.absFloat(playerState.directionVec.y),
        maxSpeed * std.math.absFloat(playerState.directionVec.y),
    );

    playerState.speed.x =
        if (std.math.absFloat(playerState.speed.x) < 0.1) 0 else playerState.speed.x * constantDeceleration;
    playerState.speed.y = if (std.math.absFloat(playerState.speed.y) < 0.1) 0 else playerState.speed.y * constantDeceleration;

    const newPosX = sprite.posX + playerState.speed.x;
    const newPosY = sprite.posY + playerState.speed.y;
    sprite.posX = newPosX;
    sprite.posY = newPosY;

    // Stop playing an animation if the player does not move
    // Maybe play an idle animation instead?
    if (playerState.speed.x == 0 and playerState.speed.y == 0 and nextFrame.animationDone) {
        playerAnimation.pause();
    } else {
        playerAnimation.unpause();
    }
}

const Direction = enum { Up, Down, Left, Right };

inline fn vec2ToDirection(vec2: *Vec2) ?Direction {
    if (vec2.x == 0 and vec2.y == 0)
        return null;
    if (vec2.y < 0)
        return Direction.Up;
    if (vec2.y > 0)
        return Direction.Down;
    if (vec2.x < 0)
        return Direction.Left;
    return Direction.Right;
}
