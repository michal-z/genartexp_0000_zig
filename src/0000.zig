const std = @import("std");
const math = std.math;
const c = @import("c.zig");

const window_name = "generative art experiment 0000";
const window_width = 1920;
const window_height = 1080;
var oglppo: c.GLuint = undefined;

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

    c.glCreateProgramPipelines(1, &oglppo);
    c.glBindProgramPipeline(oglppo);

    //c.glEnable(c.GL_DEBUG_OUTPUT);
    c.glDebugMessageCallback(handleGlError, null);

    c.glEnable(c.GL_FRAMEBUFFER_SRGB);

    var srgb_color_tex: c.GLuint = undefined;
    c.glCreateTextures(c.GL_TEXTURE_2D_MULTISAMPLE, 1, &srgb_color_tex);
    c.glTextureStorage2DMultisample(srgb_color_tex, 8, c.GL_SRGB8_ALPHA8, window_width, window_height, c.GL_FALSE);
    defer c.glDeleteTextures(1, &srgb_color_tex);

    var srgb_ds_tex: c.GLuint = undefined;
    c.glCreateTextures(c.GL_TEXTURE_2D_MULTISAMPLE, 1, &srgb_ds_tex);
    c.glTextureStorage2DMultisample(srgb_ds_tex, 8, c.GL_DEPTH24_STENCIL8, window_width, window_height, c.GL_FALSE);
    defer c.glDeleteTextures(1, &srgb_ds_tex);

    var srgb_fbo: c.GLuint = undefined;
    c.glCreateFramebuffers(1, &srgb_fbo);
    c.glNamedFramebufferTexture(srgb_fbo, c.GL_COLOR_ATTACHMENT0, srgb_color_tex, 0);
    c.glNamedFramebufferTexture(srgb_fbo, c.GL_DEPTH_STENCIL_ATTACHMENT, srgb_ds_tex, 0);
    c.glClearNamedFramebufferfv(srgb_fbo, c.GL_COLOR, 0, &[_]f32{ 0.0, 0.0, 0.0, 0.0 });
    c.glClearNamedFramebufferfi(srgb_fbo, c.GL_DEPTH_STENCIL, 0, 1.0, 0);
    defer c.glDeleteFramebuffers(1, &srgb_fbo);

    var sys: ?*c.FMOD_SYSTEM = null;
    if (c.FMOD_System_Create(&sys) != .FMOD_OK) {
        std.debug.panic("FMOD_System_Create failed.\n", .{});
    }
    defer _ = c.FMOD_System_Release(sys);

    const fs = c.glCreateShaderProgramv(c.GL_FRAGMENT_SHADER, 1, &@as([*c]const u8, 
        \\  #version 460 compatibility
        \\
        \\  void main() {
        \\      gl_FragColor = vec4(0.0, 0.8, 0.1, 1.0);
        \\  }
    ));
    defer c.glDeleteProgram(fs);

    var image_w: c_int = undefined;
    var image_h: c_int = undefined;
    const image_data = c.stbi_load("data/genart_0025_5.png", &image_w, &image_h, null, 4);
    if (image_data == null) {
        std.debug.panic("Failed to load image.\n", .{});
    }

    var image_tex: c.GLuint = undefined;
    c.glCreateTextures(c.GL_TEXTURE_2D, 1, &image_tex);
    c.glTextureStorage2D(image_tex, 1, c.GL_SRGB8_ALPHA8, image_w, image_h);
    c.glTextureSubImage2D(image_tex, 0, 0, 0, image_w, image_h, c.GL_RGBA, c.GL_UNSIGNED_BYTE, image_data);
    c.glTextureParameteri(image_tex, c.GL_TEXTURE_MIN_FILTER, c.GL_LINEAR);
    c.glTextureParameteri(image_tex, c.GL_TEXTURE_MAG_FILTER, c.GL_LINEAR);
    c.stbi_image_free(image_data);
    defer c.glDeleteTextures(1, &image_tex);

    while (c.glfwWindowShouldClose(window) == c.GLFW_FALSE) {
        const stats = updateFrameStats(window, window_name);

        c.glClearNamedFramebufferfv(srgb_fbo, c.GL_COLOR, 0, &[_]f32{ 0.2, 0.4, 0.8, 1.0 });
        c.glClearNamedFramebufferfi(srgb_fbo, c.GL_DEPTH_STENCIL, 0, 1.0, 0);
        c.glBindFramebuffer(c.GL_DRAW_FRAMEBUFFER, srgb_fbo);

        c.glMatrixLoadIdentityEXT(c.GL_PROJECTION);
        c.glMatrixLoadIdentityEXT(c.GL_MODELVIEW);

        c.glUseProgramStages(oglppo, c.GL_FRAGMENT_SHADER_BIT, fs);
        c.glBegin(c.GL_TRIANGLES);
        c.glVertex2f(-0.7, -0.7);
        c.glVertex2f(0.7, -0.7);
        c.glVertex2f(0.0, 0.7);
        c.glEnd();
        c.glUseProgramStages(oglppo, c.GL_ALL_SHADER_BITS, 0);

        c.glDrawTextureNV(
            image_tex,
            0,
            0.0, // x
            0.0, // y
            @intToFloat(f32, image_w),
            @intToFloat(f32, image_h),
            0.0, // z
            0.0, // s0
            1.0, // t0
            1.0, // s1
            0.0, // t1
        );

        c.glMatrixOrthoEXT(
            c.GL_PROJECTION,
            -0.5 * @intToFloat(f32, window_width),
            0.5 * @intToFloat(f32, window_width),
            -0.5 * @intToFloat(f32, window_height),
            0.5 * @intToFloat(f32, window_height),
            -1.0,
            1.0,
        );

        const path_obj = 1;
        {
            const num_vertices = 11;
            var path_commands: [num_vertices + 1]u8 = undefined;
            var path_coords: [num_vertices][2]f32 = undefined;
            var i: u32 = 0;
            while (i < num_vertices) {
                if (i == 0) path_commands[i] = c.GL_MOVE_TO_NV else path_commands[i] = c.GL_LINE_TO_NV;

                const t = @floatCast(f32, stats.time);
                const frac_i = @intToFloat(f32, i) / num_vertices;
                const r = 150 + 100.0 * math.sin(t + frac_i * math.tau);
                const theta = frac_i * math.tau;
                path_coords[i] = [2]f32{ r * math.cos(theta), r * math.sin(theta) };
                i += 1;
            }
            path_commands[num_vertices] = c.GL_CLOSE_PATH_NV;

            c.glPathCommandsNV(path_obj, path_commands.len, &path_commands, path_coords.len * 2, c.GL_FLOAT, &path_coords);
            c.glPathParameterfNV(path_obj, c.GL_PATH_STROKE_WIDTH_NV, 6.5);
            c.glPathParameteriNV(path_obj, c.GL_PATH_JOIN_STYLE_NV, c.GL_ROUND_NV);
        }

        c.glEnable(c.GL_BLEND);
        c.glBlendFunc(c.GL_SRC_ALPHA, c.GL_ONE_MINUS_SRC_ALPHA);
        c.glEnable(c.GL_STENCIL_TEST);
        c.glStencilFunc(c.GL_NOTEQUAL, 0, 0xFF);
        c.glStencilOp(c.GL_KEEP, c.GL_KEEP, c.GL_ZERO);

        c.glColor4f(1.0, 0.5, 1.0, 0.5);
        c.glStencilThenCoverFillPathNV(path_obj, c.GL_COUNT_UP_NV, 0xFF, c.GL_BOUNDING_BOX_NV);

        c.glColor3f(0.0, 0.0, 0.0);
        c.glStencilThenCoverStrokePathNV(path_obj, 0x1, 0xFF, c.GL_CONVEX_HULL_NV);

        {
            const num_vertices = 128;
            var path_commands: [num_vertices]u8 = undefined;
            var path_coords: [num_vertices][2]f32 = undefined;

            var i: u32 = 0;
            while (i < num_vertices) {
                if (i == 0) path_commands[i] = c.GL_MOVE_TO_NV else path_commands[i] = c.GL_LINE_TO_NV;
                const frac_i = @intToFloat(f32, i) / num_vertices;
                path_coords[i] = [2]f32{ frac_i * 900.0, 50.0 * math.sin(math.tau * frac_i * 4.0) };
                i += 1;
            }

            c.glPathCommandsNV(path_obj, path_commands.len, &path_commands, path_coords.len * 2, c.GL_FLOAT, &path_coords);
            c.glPathParameterfNV(path_obj, c.GL_PATH_STROKE_WIDTH_NV, 5.5);
        }

        c.glColor3f(0.0, 0.0, 0.0);
        c.glStencilThenCoverStrokePathNV(path_obj, 0x1, 0xFF, c.GL_CONVEX_HULL_NV);

        c.glDisable(c.GL_STENCIL_TEST);
        c.glDisable(c.GL_BLEND);

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
