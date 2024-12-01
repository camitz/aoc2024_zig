const std = @import("std");

pub fn readFile(filename: []const u8) ![]const u8 {
    // Get allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Open and read file
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    const read_buf = try file.readToEndAlloc(allocator, 1024 * 1024);
    defer allocator.free(read_buf);

    return read_buf;
}
