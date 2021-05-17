pub usingnamespace @cImport({
    @cDefine("GLFW_INCLUDE_GLEXT", "");
    @cInclude("glfw3.h");
});
pub var glTextureStorage2D: @typeInfo(PFNGLTEXTURESTORAGE2DPROC).Optional.child = undefined;
pub var glMatrixLoadIdentityEXT: @typeInfo(PFNGLMATRIXLOADIDENTITYEXTPROC).Optional.child = undefined;

pub fn initOpenGlEntryPoints() void {
    glTextureStorage2D = @ptrCast(@TypeOf(glTextureStorage2D), glfwGetProcAddress("glTextureStorage2D").?);
    glMatrixLoadIdentityEXT = @ptrCast(@TypeOf(glMatrixLoadIdentityEXT), glfwGetProcAddress("glMatrixLoadIdentityEXT").?);
}
