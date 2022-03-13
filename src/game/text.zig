const graphics = @import("./graphics.zig");
const tile = @import("../levels/tiles.zig");
const std = @import("std");
const ArrayList = @import("std").ArrayList;
const constants = @import("../constants.zig");
const Vec2 = @import("../math/vector.zig").Vec2;
const vec2 = @import("../math/vector.zig").vec2;

pub fn textToTile(allocator: *std.mem.Allocator, text: *const []const u8) ![]*const graphics.Tile {
    var result = try allocator.alloc(*const graphics.Tile, text.len);
    for (text.*) |letter, i| {
        result[i] = letterToTile(letter);
    }
    return result;
}

pub fn bucketise(
    comptime T: type,
    allocator: *std.mem.Allocator,
    lines: ArrayList(T),
    size: u32,
) !ArrayList(ArrayList(T)) {
    var result = ArrayList(ArrayList(T)).init(allocator);
    var lineIndex: u32 = 0;
    var i: u32 = 0;
    // Stop when we're out of lines
    while (lineIndex < lines.items.len) {
        // Create a new subarray
        var newList: ArrayList(T) = try ArrayList(T).initCapacity(allocator, size);
        i = 0;
        while (i < size and lineIndex < lines.items.len) {
            const item = lines.items[lineIndex];
            try newList.append(item);
            lineIndex += 1;
            i += 1;
        }
        try result.append(newList);
    }
    return result;
}

test "bucketise works" {
    std.log.debug("mofo", .{});
    var example = ArrayList(i32).init(std.testing.allocator);
    try example.append(1);
    try example.append(2);
    try example.append(1);
    try example.append(2);
    try example.append(1);
    try example.append(2);
    const result = try bucketise(i32, std.testing.allocator, example, 2);
    std.log.debug("bucketised: {}", .{result});
    try std.testing.expect(result.items.len == 4);
}

const ObjectList = ArrayList(graphics.Object);
pub fn tilesToLines(
    allocator: *std.mem.Allocator,
    text: *const []const u8,
    lineWidth: f32,
    lineHeight: f32,
) !ArrayList(ObjectList) {
    // Result should be something like
    // [ ['a', ' ', 't', 'e', 'x', 't'],
    //   ['o', 'n' ' ', 'm', 'a', 'n', 'y'],
    //   ['l', 'i', 'n', 'e', 's']
    // ]
    var result = ArrayList(ObjectList).init(allocator);
    var textTiles = try textToTile(allocator, text);
    var x: f32 = 0;
    var y: f32 = 0;
    var currLine: u32 = 0;
    if (textTiles.len == 0) return result;
    try result.append(ObjectList.init(allocator));
    for (textTiles) |t, tileIndex| {
        const wordWidth = @intToFloat(f32, calcWordWidth(textTiles[tileIndex..textTiles.len]));
        // Check if this word still fits on this line
        if (wordWidth + x > lineWidth) {
            // Start a new line
            try result.append(ObjectList.init(allocator));
            x = 0;
            currLine += 1;
            y += lineHeight;
        }
        const vOffset = tileVerticalOffset(t) * constants.SCALE;
        var object = graphics.Object{
            .position = vec2(x, y + vOffset),
            .tile = t,
        };
        try result.items[currLine].append(object);
        x += @intToFloat(f32, t.width * constants.SCALE);
    }
    return result;
}

inline fn calcWordWidth(wordTiles: []*const graphics.Tile) i32 {
    var width: i32 = 0;
    for (wordTiles) |t| {
        if (t == &tile.punctuationSpace) {
            return width;
        }
        width += t.width * constants.SCALE;
    }
    return width;
}

inline fn tileVerticalOffset(t: *const graphics.Tile) f32 {
    return if (t == &tile.letterP or t == &tile.letterQ or t == &tile.letterY or t == &tile.letterG or t == &tile.letterJ)
        3
    else
        0;
}

inline fn letterToTile(letter: u8) *const graphics.Tile {
    switch (letter) {
        'a' => return &tile.letterA,
        'b' => return &tile.letterB,
        'c' => return &tile.letterC,
        'd' => return &tile.letterD,
        'e' => return &tile.letterE,
        'f' => return &tile.letterF,
        'g' => return &tile.letterG,
        'h' => return &tile.letterH,
        'i' => return &tile.letterI,
        'j' => return &tile.letterJ,
        'k' => return &tile.letterK,
        'l' => return &tile.letterL,
        'm' => return &tile.letterM,
        'n' => return &tile.letterN,
        'o' => return &tile.letterO,
        'p' => return &tile.letterP,
        'q' => return &tile.letterQ,
        'r' => return &tile.letterR,
        's' => return &tile.letterS,
        't' => return &tile.letterT,
        'u' => return &tile.letterU,
        'v' => return &tile.letterV,
        'w' => return &tile.letterW,
        'x' => return &tile.letterX,
        'y' => return &tile.letterY,
        'z' => return &tile.letterZ,
        'A' => return &tile.letterCapitalA,
        'B' => return &tile.letterCapitalB,
        'C' => return &tile.letterCapitalC,
        'D' => return &tile.letterCapitalD,
        'E' => return &tile.letterCapitalE,
        'F' => return &tile.letterCapitalF,
        'G' => return &tile.letterCapitalG,
        'H' => return &tile.letterCapitalH,
        'I' => return &tile.letterCapitalI,
        'J' => return &tile.letterCapitalJ,
        'K' => return &tile.letterCapitalK,
        'L' => return &tile.letterCapitalL,
        'M' => return &tile.letterCapitalM,
        'N' => return &tile.letterCapitalN,
        'O' => return &tile.letterCapitalO,
        'P' => return &tile.letterCapitalP,
        'Q' => return &tile.letterCapitalQ,
        'R' => return &tile.letterCapitalR,
        'S' => return &tile.letterCapitalS,
        'T' => return &tile.letterCapitalT,
        'U' => return &tile.letterCapitalU,
        'V' => return &tile.letterCapitalV,
        'W' => return &tile.letterCapitalW,
        'X' => return &tile.letterCapitalX,
        'Y' => return &tile.letterCapitalY,
        'Z' => return &tile.letterCapitalZ,
        ' ' => return &tile.punctuationSpace,
        '1' => return &tile.num1,
        '2' => return &tile.num2,
        '3' => return &tile.num3,
        '4' => return &tile.num4,
        '5' => return &tile.num5,
        '6' => return &tile.num6,
        '7' => return &tile.num7,
        '8' => return &tile.num8,
        '9' => return &tile.num9,
        '0' => return &tile.num0,
        '.' => return &tile.punctuationFullStop,
        ',' => return &tile.punctuationComma,
        ':' => return &tile.punctuationColon,
        '!' => return &tile.punctuationExclamationMark,
        '?' => return &tile.punctuationQuestionMark,
        '-' => return &tile.punctuationHyphen,
        '_' => return &tile.punctuationUnderscore,
        '#' => return &tile.symbolSharp,
        '$' => return &tile.symbolFlat,
        else => return &tile.punctuationQuestionMark,
    }
}
