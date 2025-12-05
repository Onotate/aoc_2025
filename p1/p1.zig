const std = @import("std");

fn sol(input: []const u8) !u32 {
    var iter = std.mem.tokenizeAny(u8, input, "\n");
    var count: u32 = 0;
    var dial: i32 = 50;  // dial starts at 50
    while (iter.next()) |line| {
        const val = try std.fmt.parseInt(i32, line[1..], 10);
        if (line[0] == 'L') {
            dial -= val;
        } else {
            dial += val;
        }
        if (@rem(dial, 100) == 0) {
            count += 1;
        }
    }
    return count;
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const p_input = try std.fs.File.stdin().readToEndAlloc(allocator, 17100);
    const result = try sol(p_input);
    std.debug.print("result: {}\n", .{result});
}
