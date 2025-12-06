const std = @import("std");

fn greedy_pick(slice: []const u8) usize {
    var pick: usize = 0;
    var pick_val: u8 = slice[0];
    for (slice, 0..) |bat, i| {
        if (bat > pick_val) {
            pick = i;
            pick_val = bat;
        }
    }
    return pick;
}

fn sol(input: []const u8) !u64 {
    var iter = std.mem.tokenizeAny(u8, input, "\n");
    var joltage: u64 = 0;

    while (iter.next()) |bank| {
        const id1 = greedy_pick(bank[0..bank.len-1]); // avoid last battery
        const id2 = id1 + 1 + greedy_pick(bank[id1+1..bank.len]);
        const num: [2]u8 = .{ bank[id1], bank[id2] };  
        const val = try std.fmt.parseInt(u64, &num, 10);
        joltage += val;
    }
    return joltage;
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const input = try std.fs.File.stdin().readToEndAlloc(allocator, 20210);
    const result = try sol(input[0..input.len-1]); // chop off eof char
    std.debug.print("result: {}\n", .{result});
}
