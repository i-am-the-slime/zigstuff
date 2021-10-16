const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    // const target = b.standardTargetOptions(.{});
    const target = b.standardTargetOptions(.{ .default_target = .{ .abi = .gnu } });

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("zigstuff", "src/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);

    // SDL stuff for macOS
    exe.linkSystemLibrary("sdl2");
    exe.addIncludeDir("lib/rtmidi/include");
    exe.addObjectFile("lib/rtmidi/lib/x64/librtmidi.a");
    exe.linkFramework("CoreMIDI");
    exe.linkFramework("CoreFoundation");
    exe.linkFramework("CoreAudio");
    exe.linkSystemLibrary("c++");
    exe.linkLibC();

    // Midi stuff for macOS
    // exe.addIncludeDir("/usr/local/include/rtmidi");

    exe.linkLibC();

    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    // // Test
    // var rtmidi_tests = b.addTest("src/rtmidi.zig");
    // rtmidi_tests.setBuildMode(mode);
    // rtmidi_tests.addIncludeDir("lib/rtmidi/include");
    // rtmidi_tests.addObjectFile("lib/rtmidi/lib/x64/librtmidi.a");
    // rtmidi_tests.linkFramework("CoreMIDI");
    // rtmidi_tests.linkFramework("CoreFoundation");
    // rtmidi_tests.linkFramework("CoreAudio");
    // rtmidi_tests.linkSystemLibrary("c++");
    // rtmidi_tests.linkLibC();

    // const test_step = b.step("test", "Run library tests");
    // test_step.dependOn(&rtmidi_tests.step);
}
