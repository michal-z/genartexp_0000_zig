const std = @import("std");
const c = @import("c.zig");

const window_name = "generative art experiment 0000";
const window_width = 1920;
const window_height = 1080;

pub fn main() !void {
    _ = c.glfwSetErrorCallback(handleGlfwError);
    if (c.glfwInit() == c.GLFW_FALSE) {
        std.debug.panic("glfwInit() failed.\n", .{});
    }
    defer c.glfwTerminate();

    c.glfwWindowHint(c.GLFW_DEPTH_BITS, 24);
    c.glfwWindowHint(c.GLFW_STENCIL_BITS, 8);
    c.glfwWindowHint(c.GLFW_RESIZABLE, c.GLFW_FALSE);

    const window = c.glfwCreateWindow(window_width, window_height, window_name, null, null) orelse {
        std.debug.panic("glfwCreateWindow() failed.\n", .{});
    };
    defer c.glfwDestroyWindow(window);

    c.glfwMakeContextCurrent(window);
    c.glfwSwapInterval(0);

    c.initOpenGlEntryPoints();

    c.glEnable(c.GL_DEBUG_OUTPUT);
    c.glDebugMessageCallback(handleGlError, null);

    c.glEnable(c.GL_FRAMEBUFFER_SRGB);

    var srgb_color_tex: c.GLuint = undefined;
    c.glCreateTextures(c.GL_TEXTURE_2D_MULTISAMPLE, 1, &srgb_color_tex);
    c.glTextureStorage2DMultisample(srgb_color_tex, 8, c.GL_SRGB8_ALPHA8, window_width, window_height, c.GL_FALSE);

    var srgb_ds_tex: c.GLuint = undefined;
    c.glCreateTextures(c.GL_TEXTURE_2D_MULTISAMPLE, 1, &srgb_ds_tex);
    c.glTextureStorage2DMultisample(srgb_ds_tex, 8, c.GL_DEPTH24_STENCIL8, window_width, window_height, c.GL_FALSE);

    var srgb_fbo: c.GLuint = undefined;
    c.glCreateFramebuffers(1, &srgb_fbo);
    c.glNamedFramebufferTexture(srgb_fbo, c.GL_COLOR_ATTACHMENT0, srgb_color_tex, 0);
    c.glNamedFramebufferTexture(srgb_fbo, c.GL_DEPTH_STENCIL_ATTACHMENT, srgb_ds_tex, 0);
    c.glClearNamedFramebufferfv(srgb_fbo, c.GL_COLOR, 0, &[_]f32{ 0.0, 0.0, 0.0, 0.0 });
    c.glClearNamedFramebufferfi(srgb_fbo, c.GL_DEPTH_STENCIL, 0, 1.0, 0);

    while (c.glfwWindowShouldClose(window) == c.GLFW_FALSE) {
        const stats = updateFrameStats(window, window_name);

        c.glClearNamedFramebufferfv(srgb_fbo, c.GL_COLOR, 0, &[_]f32{ 0.2, 0.4, 0.8, 1.0 });
        c.glClearNamedFramebufferfi(srgb_fbo, c.GL_DEPTH_STENCIL, 0, 1.0, 0);

        c.glBindFramebuffer(c.GL_DRAW_FRAMEBUFFER, srgb_fbo);

        c.glBegin(c.GL_TRIANGLES);
        c.glVertex2f(-0.7, -0.7);
        c.glVertex2f(0.7, -0.7);
        c.glVertex2f(0.0, 0.7);
        c.glEnd();

        c.glBindFramebuffer(c.GL_DRAW_FRAMEBUFFER, 0);
        c.glBlitNamedFramebuffer(
            srgb_fbo, // src
            0, // dst
            0,
            0,
            window_width,
            window_height,
            0,
            0,
            window_width,
            window_height,
            c.GL_COLOR_BUFFER_BIT,
            c.GL_NEAREST,
        );

        if (c.glGetError() != c.GL_NO_ERROR) {
            std.debug.panic("OpenGL error detected.\n", .{});
        }
        c.glfwSwapBuffers(window);
        c.glfwPollEvents();
    }

    c.glDeleteFramebuffers(1, &srgb_fbo);
    c.glDeleteTextures(1, &srgb_ds_tex);
    c.glDeleteTextures(1, &srgb_color_tex);
}

fn updateFrameStats(window: *c.GLFWwindow, name: [*:0]const u8) struct { time: f64, delta_time: f32 } {
    const state = struct {
        var timer: std.time.Timer = undefined;
        var previous_time_ns: u64 = 0;
        var header_refresh_time_ns: u64 = 0;
        var frame_count: u64 = ~@as(u64, 0);
    };

    if (state.frame_count == ~@as(u64, 0)) {
        state.timer = std.time.Timer.start() catch unreachable;
        state.previous_time_ns = 0;
        state.header_refresh_time_ns = 0;
        state.frame_count = 0;
    }

    const now_ns = state.timer.read();
    const time = @intToFloat(f64, now_ns) / std.time.ns_per_s;
    const delta_time = @intToFloat(f32, now_ns - state.previous_time_ns) / std.time.ns_per_s;
    state.previous_time_ns = now_ns;

    if ((now_ns - state.header_refresh_time_ns) >= std.time.ns_per_s) {
        const t = @intToFloat(f64, now_ns - state.header_refresh_time_ns) / std.time.ns_per_s;
        const fps = @intToFloat(f64, state.frame_count) / t;
        const ms = (1.0 / fps) * 1000.0;

        var buffer = [_]u8{0} ** 128;
        const buffer_slice = buffer[0 .. buffer.len - 1];
        const header = std.fmt.bufPrint(
            buffer_slice,
            "[{d:.1} fps  {d:.3} ms] {s}",
            .{ fps, ms, name },
        ) catch buffer_slice;

        _ = c.glfwSetWindowTitle(window, header.ptr);

        state.header_refresh_time_ns = now_ns;
        state.frame_count = 0;
    }
    state.frame_count += 1;

    return .{ .time = time, .delta_time = delta_time };
}

fn handleGlfwError(err: c_int, description: [*c]const u8) callconv(.C) void {
    std.debug.panic("GLFW error: {s}\n", .{@as([*:0]const u8, description)});
}

fn handleGlError(
    source: c.GLenum,
    mtype: c.GLenum,
    id: c.GLuint,
    severity: c.GLenum,
    length: c.GLsizei,
    message: [*c]const c.GLchar,
    user_param: ?*const c_void,
) callconv(.C) void {
    if (message != null) {
        std.debug.print("{s}\n", .{message});
    }
}
