const std = @import("std");

pub const Dialogue = union(enum) {
    End: u0,
    Line: u8,
    Choice: []u8,
};
const DialogueTag = std.meta.Tag(Dialogue);

pub const Conversation = struct {
  current: Dialogue,
  next: *Conversation
};