/// A tuple of a pointer to a tile in the sprite sheet and its duration in frames.
pub const Keyframe = struct {
    /// The x position in the sprite sheet
    srcX: u8,
    /// The y position in the sprite sheet
    srcY: u8,
    /// For how many ms (assuming 60fps) this sprite should be displayed
    duration: f32,
};

const AnimationFrame = struct {
    srcX: u8,
    srcY: u8,
    animationDone: bool,
};

pub const AnimatedSprite = struct {
    keyframes: []const Keyframe,
    totalDuration: f32,
    currentTime: f64,
    paused: bool = false,

    inline fn countTotalDuration(keyframes: []const Keyframe) f32 {
        var totalDuration: f32 = 0;
        for (keyframes) |keyframe| {
            totalDuration += keyframe.duration;
        }
        return totalDuration;
    }

    pub fn init(keyframes: []const Keyframe) AnimatedSprite {
        return .{
            .keyframes = keyframes,
            .currentTime = 0,
            .totalDuration = countTotalDuration(keyframes),
        };
    }

    pub fn replace(self: *@This(), keyframes: []const Keyframe) void {
        self.keyframes = keyframes;
        self.totalDuration = countTotalDuration(keyframes);
    }

    pub fn rewind(self: *@This()) void {
        self.currentTime = 0;
    }

    pub fn pause(self: *@This()) void {
        self.paused = true;
    }

    pub fn unpause(self: *@This()) void {
        self.paused = false;
    }

    /// Advances the animation to its next frame looping it.
    pub fn advance(self: *@This(), deltaTime: f64) AnimationFrame {
        if (!self.paused) {
            self.currentTime = @mod(self.currentTime + deltaTime, self.totalDuration);
        }
        var srcX: u8 = undefined;
        var srcY: u8 = undefined;
        var i: u32 = 0;
        var durationInAnimation: f64 = 0;
        // Find the current frame
        while (true) {
            if (self.currentTime > durationInAnimation + self.keyframes[i].duration) {
                durationInAnimation += self.keyframes[i].duration;
                i += 1;
            } else {
                srcX = self.keyframes[i].srcX;
                srcY = self.keyframes[i].srcY;
                break;
            }
        }
        // This should only be the case if we just wrapped
        const isFinished = !self.paused and self.currentTime == 0;
        return .{
            .animationDone = isFinished,
            .srcX = srcX,
            .srcY = srcY,
        };
    }
};
