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
        var num: [12]u8 = undefined;
        var offset: usize = 0;

        for (0..12) |i| {
            const end = bank.len - 11 + i; // ignore last 11 - i batteries
            const pick = offset + greedy_pick(bank[offset..end]);
            num[i] = bank[pick];
            offset = pick + 1;
        }
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
