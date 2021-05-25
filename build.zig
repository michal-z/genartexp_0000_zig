const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    var target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("genartexp_0000", "src/0000.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);

    const glfw_src = [_][]const u8{
        "context.c",
        "init.c",
        "input.c",
        "monitor.c",
        "vulkan.c",
        "window.c",
        "win32_init.c",
        "win32_joystick.c",
        "win32_monitor.c",
        "win32_time.c",
        "win32_thread.c",
        "win32_window.c",
        "wgl_context.c",
        "egl_context.c",
        "osmesa_context.c",
    };
    const glfw_flags = [_][]const u8{ "-std=c99", "-D_GLFW_WIN32=1" };
    const glfw_src_dir = "c/glfw-3.3.4/src/";
    inline for (glfw_src) |src| {
        exe.addCSourceFile(glfw_src_dir ++ src, &glfw_flags);
    }
    exe.addIncludeDir("c/glfw-3.3.4/include");

    exe.addCSourceFile("c/stb_image.c", &[_][]const u8{"-std=c99"});
    exe.addCSourceFile("c/stb_perlin.c", &[_][]const u8{"-std=c99"});

    exe.addIncludeDir("c");

    exe.addIncludeDir("c/fmod/include");
    exe.addLibPath("c/fmod/lib");

    exe.linkSystemLibrary("user32");
    exe.linkSystemLibrary("gdi32");
    exe.linkSystemLibrary("shell32");
    exe.linkSystemLibrary("opengl32");
    exe.linkSystemLibrary("c");
    exe.linkSystemLibrary("fmodL_vc");

    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
