const conversation = @import("dialogue.zig");
const std = @import("std");

pub const GameState = union(enum) {
    InGame: u0,
    Talking: *const conversation.Conversation,
};
pub const GameStateTag = std.meta.Tag(GameState);
