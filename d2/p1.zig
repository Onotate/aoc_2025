const std = @import("std"); 

fn invalid(num: u64) bool {
    const order = std.math.log10(num);
    if (order % 2 == 0) return false;
    const tester = std.math.pow(u64, 10, (order + 1)/2) + 1;
    return (num % tester) == 0;
}

fn sol(input: []const u8) !u64 {
    var iter = std.mem.tokenizeAny(u8, input, ",");
    var sum: u64 = 0;
    
    while (iter.next()) |range| {
        const dash_i = std.mem.indexOfScalar(u8, range, '-').?;
        const lower = try std.fmt.parseInt(u64, range[0..dash_i], 10);
        const upper = try std.fmt.parseInt(u64, range[dash_i+1..], 10);
        for (lower..(upper+1)) |i| {
            if (invalid(i)) {
                sum += i;
            }
        }
    }
    return sum;
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const input = try std.fs.File.stdin().readToEndAlloc(allocator, 512);
    const result = try sol(input[0..input.len-1]); // chop off eof char
    std.debug.print("result: {}\n", .{result});
} 
