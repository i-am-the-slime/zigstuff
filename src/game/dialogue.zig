const std = @import("std");

pub const Dialogue = union(enum) {
    End: u0,
    Line: *const []const u8,
    Choice: *const [] *const []const u8,
};
const DialogueTag = std.meta.Tag(Dialogue);

pub const Conversation = struct {
  current: Dialogue,
  next: ?*const Conversation
};