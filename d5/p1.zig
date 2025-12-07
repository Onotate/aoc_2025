const std = @import("std");

const Range = struct {
    start: u64,
    end:   u64,
};

fn is_fresh(ranges: *const std.ArrayList(Range), id: u64) !bool {
    for (ranges.items) |range| {
        if (id >= range.start and id <= range.end) {
            return true;
        }
    }
    return false;
}

fn sol(allocator: std.mem.Allocator, input: []u8) !u64 {
    // So... using tokenizer does not get the empty line,
    // we check for the '-' instead.
    var ranges = std.ArrayList(Range).empty;
    defer ranges.deinit(allocator);
    
    var tk = std.mem.tokenizeAny(u8, input, "\n");
    var reading_ranges = true;
    var count: u64 = 0;
    while (tk.next()) |line| {
        if (reading_ranges) {
            const dash_opt = std.mem.indexOfScalar(u8, line, '-');
            if (dash_opt) |index| {
                const start = try std.fmt.parseInt(u64, line[0..index], 10);
                const end = try std.fmt.parseInt(u64, line[index+1..], 10);
                try ranges.append(allocator, .{ .start = start, .end = end });
                continue; // skip IDs checking logic
            } else {
                reading_ranges = false;
            }
        }
        // Checking ID
        const id = try std.fmt.parseInt(u64, line, 10);
        if (try is_fresh(&ranges, id)) {
            count += 1;
        }
    }
    return count;
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const input = try std.fs.File.stdin().readToEndAlloc(allocator, 21600);
    const result = try sol(allocator, input[0..input.len-1]); // chop off eof char
    std.debug.print("result: {}\n", .{result});
}

