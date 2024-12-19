const sv = @cImport({
    @cDefine("SUNVOX_MAIN", {});
    @cInclude("../lib/sunvox/sunvox.h");
});

const SV_ERR = error{
    MISSING_DLL,
    METHOD_NOT_FOUND,
    FAILED_TO_INITIALIZED,
    FAILED_TO_CREATE_NEW_SLOT,
    FAILED_TO_LOAD_PROJECT,
    FAILED_TO_PLAY_PROJECT,
};

pub fn init(config: [*c]const u8, sample_rate: i32, channels: i32, flags: u32) !i32 {
    if (sv.sv_load_dll() != 0) return SV_ERR.MISSING_DLL;

    if (sv.sv_init) |func| {
        const result = func(config, @as(c_int, sample_rate), @as(c_int, channels), flags);

        if (result < 0) return SV_ERR.FAILED_TO_INITIALIZED;

        return @as(i32, result);
    } else {
        return SV_ERR.METHOD_NOT_FOUND;
    }
}

pub fn open_slot(slot_id: i4) !void {
    const status = sv.sv_open_slot.?(@as(c_int, slot_id));

    if (status < 0) return SV_ERR.FAILED_TO_CREATE_NEW_SLOT;
}

pub fn load(slot_id: i4, file_name: [*c]const u8) !void {
    const status = sv.sv_load.?(@as(c_int, slot_id), file_name);

    if (status < 0) return SV_ERR.FAILED_TO_LOAD_PROJECT;
}

pub fn play_from_Beginning(slot_id: i4) !void {
    const status = sv.sv_play_from_beginning.?(@as(c_int, slot_id));

    if (status < 0) return SV_ERR.FAILED_TO_PLAY_PROJECT;
}

pub fn end_of_song(slot_id: i4) bool {
    const status = sv.sv_end_of_song.?(@as(c_int, slot_id));

    if (status == 1) return true else return false;
}
