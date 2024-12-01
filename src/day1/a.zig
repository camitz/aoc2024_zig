const std = @import("std");

pub fn a() !struct { u32, u32 } {
    var gpa = std.heap.GeneralPurposeAllocator(.{ .safety = true }){};
    const allocator = gpa.allocator();

    var left = std.ArrayList(u32).init(allocator);
    var right = std.ArrayList(u32).init(allocator);
    defer left.deinit();
    defer right.deinit();

    const file = try std.fs.cwd().openFile("./src/day1/input", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    while (try in_stream.readUntilDelimiterOrEofAlloc(allocator, '\n', 1024)) |line| {
        std.debug.print("Processing line: {s}\n", .{line});
        defer allocator.free(line);

        if (line.len == 0) continue;
        var numbers = std.mem.tokenizeAny(u8, line, " ");

        const left_num = numbers.next() orelse {
            std.debug.print("Warning: No left number found\n", .{});
            continue;
        };
        try left.append(try std.fmt.parseInt(u32, left_num, 10));

        const right_num = numbers.next() orelse {
            std.debug.print("Warning: No right number found\n", .{});
            continue;
        };
        try right.append(try std.fmt.parseInt(u32, right_num, 10));
    }

    // Sort both arrays
    std.mem.sort(u32, left.items, {}, std.sort.asc(u32));
    std.mem.sort(u32, right.items, {}, std.sort.asc(u32));

    // Calculate total distance
    var total: u32 = 0;
    var similiarityTotal: u32 = 0;

    for (left.items, right.items) |l, r| {
        const diff = if (l > r) l - r else r - l;
        total += diff;
    }

    for (left.items) |l| {
        var count: u32 = 0;
        for (right.items) |r| {
            if (r == l) count += 1;
        }
        similiarityTotal += l * count;
    }

    return .{ total, similiarityTotal };
}
