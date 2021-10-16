pub const Vec2 = struct {
    const Self = @This();
    x: f32,
    y: f32,
    pub fn len(self: Self) f32 {
        return @sqrt((self.x * self.x) + (self.y * self.y));
    }
    pub fn normalise(self: *Self) void {
        const length = self.len();
        if (length != 0) {
            self.x /= length;
            self.y /= length;
        }
    }
};

pub fn vec2(x: f32, y: f32) Vec2 {
    return Vec2{ .x = x, .y = y };
}
