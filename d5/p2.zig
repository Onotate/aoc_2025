const std = @import("std");

const Range = struct {
    start: u64,
    end:   u64,

    pub fn size(self: Range) usize {
        return self.end - self.start + 1;
    }
    
    // I don't understand why `context` is needed here for the 
    // std.sort.blocks, just gonna shove a random thing here
    pub fn lessThan(_: []Range, lhs: Range, rhs: Range) bool {
        return lhs.start < rhs.start;
    }
};

fn count_all(ranges: *const std.ArrayList(Range)) u64 {
    // Sort ranges by ascending start
    const r_items = ranges.items;
    std.sort.block(Range, r_items, r_items, Range.lessThan);
    
    var count: u64 = 0;
    var window: Range = r_items[0];
    for (r_items[1..]) |r| {
        // if range overlap, add range to window
        if (window.end >= r.start) {
            if (r.end > window.end) {
                window.end = r.end;
            }
        } else {
            // else, record window size and reset
            count += window.size();
            window = r;
        }
    }
    count += window.size(); // last window
    return count; 
}

fn sol(allocator: std.mem.Allocator, input: []u8) !u64 {
    // So... using tokenizer does not get the empty line,
    // we check for the '-' instead.
    var ranges = std.ArrayList(Range).empty;
    defer ranges.deinit(allocator);
    
    var tk = std.mem.tokenizeAny(u8, input, "\n");
    while (tk.next()) |line| {
        const dash_opt = std.mem.indexOfScalar(u8, line, '-');
        if (dash_opt) |index| {
            const start = try std.fmt.parseInt(u64, line[0..index], 10);
            const end = try std.fmt.parseInt(u64, line[index+1..], 10);
            try ranges.append(allocator, .{ .start = start, .end = end });
        } else {
            break;
        }
    }
    return count_all(&ranges);
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const input = try std.fs.File.stdin().readToEndAlloc(allocator, 21600);
    const result = try sol(allocator, input[0..input.len-1]); // chop off eof char
    std.debug.print("result: {}\n", .{result});
}

