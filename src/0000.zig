const std = @import("std");
const panic = std.debug.panic;
const c = @import("c.zig");

const window_name = "generative art experiment 0000";
const window_width = 1920;
const window_height = 1080;
var window: *c.GLFWwindow = undefined;

pub fn main() !void {
    if (c.glfwInit() == c.GLFW_FALSE) {
        panic("glfwInit() failed.\n", .{});
    }
    defer c.glfwTerminate();

    c.glfwWindowHint(c.GLFW_DEPTH_BITS, 24);
    c.glfwWindowHint(c.GLFW_STENCIL_BITS, 8);
    c.glfwWindowHint(c.GLFW_RESIZABLE, c.GLFW_FALSE);

    window = c.glfwCreateWindow(window_width, window_height, window_name, null, null) orelse {
        panic("glfwCreateWindow() failed.\n", .{});
    };
    defer c.glfwDestroyWindow(window);

    c.glfwMakeContextCurrent(window);
    c.glfwSwapInterval(1);

    c.initOpenGlEntryPoints();

    while (c.glfwWindowShouldClose(window) == c.GLFW_FALSE) {
        c.glClearNamedFramebufferfv(0, c.GL_COLOR, 0, &[_]f32{ 0.2, 0.4, 0.8, 1.0 });
        c.glClearNamedFramebufferfi(0, c.GL_DEPTH_STENCIL, 0, 1.0, 0);

        c.glfwSwapBuffers(window);
        c.glfwPollEvents();
        if (c.glGetError() != c.GL_NO_ERROR) {
            panic("OpenGL error detected.\n", .{});
        }
    }
}
