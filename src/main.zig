const std = @import("std");
const sv = @import("sunvox.zig");

pub fn main() !void {
    std.debug.print("<!-- Skri-A Kaark -->", .{});

    const version = try sv.init(0, 44100, 2, 0);
    std.debug.print("SunVox Version: {d}.{d}.{d}", .{ version & 0xff0000 >> 16, version & 0x00ff00 >> 8, version & 0x0000ff });

    const slot = 0;

    try sv.open_slot(slot);
    try sv.load(slot, "src/Logickin - Mech Haven.sunvox");
    try sv.play_from_Beginning(slot);

    while (!sv.end_of_song(slot)) {
        std.time.sleep(1000 * 1000 * 1000);
    }
}
