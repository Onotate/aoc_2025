const std = @import("std");

const Accum = struct {
    val: u64,
    op:  u8,

    pub fn init(op: u8) Accum {
        if (op == '+') {
            return .{ .val = 0, .op = op };
        } else {
            return .{ .val = 1, .op = op };
        }
    }

    pub fn consume(self: *Accum, item: u64) void {
        if (self.op == '+') {
            self.val += item;
        } else {
            self.val = self.val * item;
        }
    }
};

fn sol(allocator: std.mem.Allocator, input: []u8) !u64 {
    var accums = std.ArrayList(Accum).empty;
    defer accums.deinit(allocator);
    
    var tk = std.mem.tokenizeAny(u8, input, "\n");
    while (tk.next()) |line| {
        var line_tokenizer = std.mem.tokenizeAny(u8, line, " ");
        if (accums.items.len == 0) {
            // the operators should be the first line now
            // since we have le_cheat.bash
            while (line_tokenizer.next()) |op| {
                try accums.append(allocator, Accum.init(op[0]));
            }
        } else {
            var idx: usize = 0;
            while (line_tokenizer.next()) |tok| {
                const num = try std.fmt.parseInt(u64, tok, 10);
                accums.items[idx].consume(num);
                idx += 1;
            }
        }
    }
    // Sum up all accumulators
    var sum: u64 = 0;
    for (accums.items) |acc| {
        sum += acc.val;
    }
    return sum;
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const input = try std.fs.File.stdin().readToEndAlloc(allocator, 18800);
    const result = try sol(allocator, input[0..input.len-1]); // chop off eof char
    std.debug.print("result: {}\n", .{result});
}

