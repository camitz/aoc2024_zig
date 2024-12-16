const std = @import("std");
const inputfile = "./src/day2/input";

pub fn a() !struct { u32, u32 } {
    var gpa = std.heap.GeneralPurposeAllocator(.{ .safety = true }){};
    const allocator = gpa.allocator();

    const file = try std.fs.cwd().openFile(inputfile, .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var nUnsafe: u32 = 0;
    var total: u32 = 0;

    while (try in_stream.readUntilDelimiterOrEofAlloc(allocator, '\n', 1024)) |line| {
        std.debug.print("Processing line: {s}\n", .{line});
        defer allocator.free(line);

        var oDir: ?i8 = null;
        var oPrevLevel: ?i32 = null;

        var it = std.mem.tokenizeScalar(u8, line, ' ');
        while (it.next()) |sLevel| {
            const level = try std.fmt.parseInt(i32, sLevel, 10);
            if (oPrevLevel) |prevLevel| {
                if (oDir == null) {
                    oDir = if (prevLevel < level) 1 else -1;
                }

                if (oDir) |dir| {
                    if (dir == 1 and prevLevel >= level) {
                        nUnsafe += 1;
                        std.debug.print("unsafe 1 ({d})\n", .{level});
                        break;
                    }

                    if (dir == -1 and prevLevel <= level) {
                        nUnsafe += 1;
                        std.debug.print("unsafe -1 ({d})\n", .{level});
                        break;
                    }

                    if (level - prevLevel > 3 or level - prevLevel < -3) {
                        nUnsafe += 1;
                        std.debug.print("unsafe ||>3 ({d})\n", .{level});
                        break;
                    }

                    oPrevLevel = level;
                }
            } else {
                oPrevLevel = level;
                continue;
            }
        }
        total += 1;
    }

    return .{ total - nUnsafe, 0 };
}
