const std = @import("std");

fn accessible(input: []const u8, rows: usize, cols: usize, y: usize, x: usize) bool {
    var ncount: u64 = 0;
    const sr = if (y == 0) 0 else y-1; // prevent underflow of usize
    const er = if (y == rows-1) rows else y+2; // prevent grid overflow
    const sc = if (x == 0) 0 else x-1;
    const ec = if (x == cols-1) cols else x+2;
    for (sr..er) |r| {
        for (sc..ec) |c| {
            if (r == y and c == x) continue;
            const nidx = r * cols + c;
            if (input[nidx] == '@') {
                ncount += 1;
            }
        }
    }
    return ncount < 4;
}

fn sol(input: []const u8) !u64 {
    // Map out dimension of the grid
    // treat newline chars as valid empty spots as well
    // last line also has a newline char at the end
    const cols = std.mem.indexOfScalar(u8, input, '\n').? + 1;
    const rows = std.mem.count(u8, input, "\n");

    var count: u64 = 0;
    for (0..rows) |r| {
        for (0..cols) |c| {
            const idx = r * cols + c;
            if (input[idx] != '@') continue;
            if (accessible(input, rows, cols, r, c)) {
                count += 1;
            }
        }
    }
    return count;
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const input = try std.fs.File.stdin().readToEndAlloc(allocator, 20000);
    const result = try sol(input[0..input.len-1]); // chop off eof char
    std.debug.print("result: {}\n", .{result});
}
