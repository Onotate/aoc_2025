const std = @import("std");

fn zero_count(dial: i32, is_left: bool, val: i32) i32 {
    // Calculate how many zeros a turn would get
    // 1. Calculate how far away from 0 (dist) in the turing direction
    // 2. take val // 100 gives number of revolutions
    // 3. if (val % 100) >= dist, then the remaining clicks take the dial
    // past 0 once more.
    // 4. if dist == 0, we don't count case 3 to prevent double count
    var dist: i32 = undefined;
    if (is_left) {
        dist = @mod(dial, 100);
    } else {
        dist = 100 - @mod(dial, 100);
    }
    var count: i32 = @divFloor(val, 100);
    if (dist != 0 and @mod(val, 100) >= dist) {
        count += 1;
    }
    return count;
}

fn sol(input: []const u8) !i32 {
    var iter = std.mem.tokenizeAny(u8, input, "\n");
    var count: i32 = 0;
    var dial: i32 = 50;  // dial starts at 50
    while (iter.next()) |line| {
        const is_left = line[0] == 'L';
        const val = try std.fmt.parseInt(i32, line[1..], 10);
        count += zero_count(dial, is_left, val);

        if (is_left) {
            dial -= val;
        } else {
            dial += val;
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
