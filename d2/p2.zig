const std = @import("std"); 

fn invalid(num: u64) bool {
    const order = std.math.log10(num);
    for (0..(order+1)/2) |i| {
        // If number of digits not divisible by i+1, skip
        if ((order + 1) % (i + 1) != 0) continue;

        // Check if the leading i+1 digits are repeating
        const rep = (order + 1) / (i + 1);
        var expectation: u64 = 0;
        for (0..rep) |pow| {
            expectation += std.math.pow(u64, 10, pow*(i+1));
        }
        const j = order - i;
        const sample = num / std.math.pow(u64, 10, j);
        if ((num % sample) == 0 and (num / sample) == expectation) {
            return true;
        } 
    }
    return false;
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
