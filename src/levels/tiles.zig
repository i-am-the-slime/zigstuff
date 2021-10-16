const graphics = @import("../game/graphics.zig");
const TS = @import("../constants.zig").TILE_SIZE;

pub const wallTopLeft = graphics.mkTile(0 * TS, 26 * TS, null);
pub const wallTop = graphics.mkTile(2 * TS, 26 * TS, graphics.collideBottom);
pub const wallTopRight = graphics.mkTile(4 * TS, 26 * TS, null);
pub const wallLeft = graphics.mkTile(0 * TS, 28 * TS, graphics.collideRight);
pub const floor = graphics.mkTile(2 * TS, 28 * TS, null);
pub const wallRight = graphics.mkTile(4 * TS, 28 * TS, graphics.collideLeft);
pub const wallBottomLeft = graphics.mkTile(0 * TS, 30 * TS, null);
pub const wallBottom = graphics.mkTile(2 * TS, 30 * TS, graphics.collideTop);
pub const wallBottomRight = graphics.mkTile(4 * TS, 30 * TS, null);
pub const doorLockedTop = graphics.mkTile(8 * TS, 30 * TS, graphics.collideBottom);

// Letters and numbers

// Numbers
pub const num1 = graphics.mkTile8(19 * TS, 26 * TS, null);
pub const num2 = graphics.mkTile8(20 * TS, 26 * TS, null);
pub const num3 = graphics.mkTile8(21 * TS, 26 * TS, null);
pub const num4 = graphics.mkTile8(22 * TS, 26 * TS, null);
pub const num5 = graphics.mkTile8(23 * TS, 26 * TS, null);
pub const num6 = graphics.mkTile8(24 * TS, 26 * TS, null);
pub const num7 = graphics.mkTile8(25 * TS, 26 * TS, null);
pub const num8 = graphics.mkTile8(26 * TS, 26 * TS, null);
pub const num9 = graphics.mkTile8(27 * TS, 26 * TS, null);
pub const num0 = graphics.mkTile8(28 * TS, 26 * TS, null);
pub const symbolSharp = graphics.mkTile8(29 * TS, 26 * TS, null);
pub const symbolFlat = graphics.mkTile8(30 * TS, 26 * TS, null);

// Letters
pub const letterCapitalA = graphics.mkTile8w(19 * TS, 27 * TS, 6, null);
pub const letterCapitalB = graphics.mkTile8w(20 * TS, 27 * TS, 6, null);
pub const letterCapitalC = graphics.mkTile8w(21 * TS, 27 * TS, 6, null);
pub const letterCapitalD = graphics.mkTile8w(22 * TS, 27 * TS, 6, null);
pub const letterCapitalE = graphics.mkTile8w(23 * TS, 27 * TS, 6, null);
pub const letterCapitalF = graphics.mkTile8w(24 * TS, 27 * TS, 6, null);
pub const letterCapitalG = graphics.mkTile8w(25 * TS, 27 * TS, 6, null);
pub const letterCapitalH = graphics.mkTile8w(26 * TS, 27 * TS, 6, null);
pub const letterCapitalI = graphics.mkTile8w(27 * TS, 27 * TS, 4, null);
pub const letterCapitalJ = graphics.mkTile8w(28 * TS, 27 * TS, 6, null);
pub const letterCapitalK = graphics.mkTile8w(29 * TS, 27 * TS, 6, null);
pub const letterCapitalL = graphics.mkTile8w(30 * TS, 27 * TS, 6, null);
pub const letterCapitalM = graphics.mkTile8w(31 * TS, 27 * TS, 6, null);
pub const letterCapitalN = graphics.mkTile8w(19 * TS, 28 * TS, 6, null);
pub const letterCapitalO = graphics.mkTile8w(20 * TS, 28 * TS, 6, null);
pub const letterCapitalP = graphics.mkTile8w(21 * TS, 28 * TS, 6, null);
pub const letterCapitalQ = graphics.mkTile8w(22 * TS, 28 * TS, 6, null);
pub const letterCapitalR = graphics.mkTile8w(23 * TS, 28 * TS, 6, null);
pub const letterCapitalS = graphics.mkTile8w(24 * TS, 28 * TS, 6, null);
pub const letterCapitalT = graphics.mkTile8w(25 * TS, 28 * TS, 6, null);
pub const letterCapitalU = graphics.mkTile8w(26 * TS, 28 * TS, 6, null);
pub const letterCapitalV = graphics.mkTile8w(27 * TS, 28 * TS, 6, null);
pub const letterCapitalW = graphics.mkTile8w(28 * TS, 28 * TS, 6, null);
pub const letterCapitalX = graphics.mkTile8w(29 * TS, 28 * TS, 6, null);
pub const letterCapitalY = graphics.mkTile8w(30 * TS, 28 * TS, 6, null);
pub const letterCapitalZ = graphics.mkTile8w(31 * TS, 28 * TS, 6, null);

pub const letterA = graphics.mkTile8w(19 * TS, 29 * TS, 6, null);
pub const letterB = graphics.mkTile8w(20 * TS, 29 * TS, 6, null);
pub const letterC = graphics.mkTile8w(21 * TS, 29 * TS, 6, null);
pub const letterD = graphics.mkTile8w(22 * TS, 29 * TS, 5, null);
pub const letterE = graphics.mkTile8w(23 * TS, 29 * TS, 5, null);
pub const letterF = graphics.mkTile8w(24 * TS, 29 * TS, 5, null);
pub const letterG = graphics.mkTile8w(25 * TS, 29 * TS, 6, null);
pub const letterH = graphics.mkTile8w(26 * TS, 29 * TS, 5, null);
pub const letterI = graphics.mkTile8w(27 * TS, 29 * TS, 2, null);
pub const letterJ = graphics.mkTile8w(28 * TS, 29 * TS, 4, null);
pub const letterK = graphics.mkTile8w(29 * TS, 29 * TS, 4, null);
pub const letterL = graphics.mkTile8w(30 * TS, 29 * TS, 4, null);
pub const letterM = graphics.mkTile8w(31 * TS, 29 * TS, 8, null);
pub const letterN = graphics.mkTile8w(19 * TS, 30 * TS, 5, null);
pub const letterO = graphics.mkTile8w(20 * TS, 30 * TS, 6, null);
pub const letterP = graphics.mkTile8w(21 * TS, 30 * TS, 5, null);
pub const letterQ = graphics.mkTile8w(22 * TS, 30 * TS, 5, null);
pub const letterR = graphics.mkTile8w(23 * TS, 30 * TS, 5, null);
pub const letterS = graphics.mkTile8w(24 * TS, 30 * TS, 5, null);
pub const letterT = graphics.mkTile8w(25 * TS, 30 * TS, 4, null);
pub const letterU = graphics.mkTile8w(26 * TS, 30 * TS, 5, null);
pub const letterV = graphics.mkTile8w(27 * TS, 30 * TS, 6, null);
pub const letterW = graphics.mkTile8w(28 * TS, 30 * TS, 6, null);
pub const letterX = graphics.mkTile8w(29 * TS, 30 * TS, 5, null);
pub const letterY = graphics.mkTile8w(30 * TS, 30 * TS, 6, null);
pub const letterZ = graphics.mkTile8w(31 * TS, 30 * TS, 6, null);

pub const punctuationFullStop = graphics.mkTile8w(19 * TS, 31 * TS, 4, null);
pub const punctuationComma = graphics.mkTile8w(20 * TS, 31 * TS, 3, null);
pub const punctuationColon = graphics.mkTile8(21 * TS, 31 * TS, null);
pub const punctuationExclamationMark = graphics.mkTile8(22 * TS, 31 * TS, null);
pub const punctuationQuestionMark = graphics.mkTile8(23 * TS, 31 * TS, null);
pub const punctuationHyphen = graphics.mkTile8(24 * TS, 31 * TS, null);
pub const punctuationUnderscore = graphics.mkTile8(25 * TS, 31 * TS, null);
pub const punctuationSpace = graphics.mkTile8w(31 * TS, 31 * TS, 3, null);
