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

    while (c.glfwWindowShouldClose(window) == c.GLFW_FALSE) {
        c.glClear(c.GL_COLOR_BUFFER_BIT | c.GL_DEPTH_BUFFER_BIT | c.GL_STENCIL_BUFFER_BIT);
        c.glfwSwapBuffers(window);
        c.glfwPollEvents();
    }
}
