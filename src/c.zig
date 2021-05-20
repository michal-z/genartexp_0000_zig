pub usingnamespace @cImport({
    @cDefine("GLFW_INCLUDE_GLEXT", "");
    @cInclude("GLFW/glfw3.h");
});
pub var glCreateTextures: @typeInfo(PFNGLCREATETEXTURESPROC).Optional.child = undefined;
pub var glTextureStorage2D: @typeInfo(PFNGLTEXTURESTORAGE2DPROC).Optional.child = undefined;
pub var glTextureStorage2DMultisample: @typeInfo(PFNGLTEXTURESTORAGE2DMULTISAMPLEPROC).Optional.child = undefined;
pub var glMatrixLoadIdentityEXT: @typeInfo(PFNGLMATRIXLOADIDENTITYEXTPROC).Optional.child = undefined;
pub var glMatrixOrthoEXT: @typeInfo(PFNGLMATRIXORTHOEXTPROC).Optional.child = undefined;
pub var glCreateFramebuffers: @typeInfo(PFNGLCREATEFRAMEBUFFERSPROC).Optional.child = undefined;
pub var glDeleteFramebuffers: @typeInfo(PFNGLDELETEFRAMEBUFFERSPROC).Optional.child = undefined;
pub var glBindFramebuffer: @typeInfo(PFNGLBINDFRAMEBUFFERPROC).Optional.child = undefined;
pub var glNamedFramebufferTexture: @typeInfo(PFNGLNAMEDFRAMEBUFFERTEXTUREPROC).Optional.child = undefined;
pub var glBlitNamedFramebuffer: @typeInfo(PFNGLBLITNAMEDFRAMEBUFFERPROC).Optional.child = undefined;
pub var glClearNamedFramebufferfv: @typeInfo(PFNGLCLEARNAMEDFRAMEBUFFERFVPROC).Optional.child = undefined;
pub var glClearNamedFramebufferfi: @typeInfo(PFNGLCLEARNAMEDFRAMEBUFFERFIPROC).Optional.child = undefined;
pub var glDebugMessageCallback: @typeInfo(PFNGLDEBUGMESSAGECALLBACKPROC).Optional.child = undefined;

pub fn initOpenGlEntryPoints() void {
    glCreateTextures = @ptrCast(@TypeOf(glCreateTextures), glfwGetProcAddress("glCreateTextures").?);
    glTextureStorage2D = @ptrCast(@TypeOf(glTextureStorage2D), glfwGetProcAddress("glTextureStorage2D").?);
    glTextureStorage2DMultisample = @ptrCast(
        @TypeOf(glTextureStorage2DMultisample),
        glfwGetProcAddress("glTextureStorage2DMultisample").?,
    );
    glMatrixLoadIdentityEXT = @ptrCast(@TypeOf(glMatrixLoadIdentityEXT), glfwGetProcAddress("glMatrixLoadIdentityEXT").?);
    glMatrixOrthoEXT = @ptrCast(@TypeOf(glMatrixOrthoEXT), glfwGetProcAddress("glMatrixOrthoEXT").?);
    glCreateFramebuffers = @ptrCast(@TypeOf(glCreateFramebuffers), glfwGetProcAddress("glCreateFramebuffers").?);
    glDeleteFramebuffers = @ptrCast(@TypeOf(glDeleteFramebuffers), glfwGetProcAddress("glDeleteFramebuffers").?);
    glBindFramebuffer = @ptrCast(@TypeOf(glBindFramebuffer), glfwGetProcAddress("glBindFramebuffer").?);
    glNamedFramebufferTexture = @ptrCast(
        @TypeOf(glNamedFramebufferTexture),
        glfwGetProcAddress("glNamedFramebufferTexture").?,
    );
    glBlitNamedFramebuffer = @ptrCast(@TypeOf(glBlitNamedFramebuffer), glfwGetProcAddress("glBlitNamedFramebuffer").?);
    glClearNamedFramebufferfv = @ptrCast(
        @TypeOf(glClearNamedFramebufferfv),
        glfwGetProcAddress("glClearNamedFramebufferfv").?,
    );
    glClearNamedFramebufferfi = @ptrCast(
        @TypeOf(glClearNamedFramebufferfi),
        glfwGetProcAddress("glClearNamedFramebufferfi").?,
    );
    glDebugMessageCallback = @ptrCast(@TypeOf(glDebugMessageCallback), glfwGetProcAddress("glDebugMessageCallback").?);
}
