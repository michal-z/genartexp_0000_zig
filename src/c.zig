pub usingnamespace @cImport({
    @cDefine("GLFW_INCLUDE_GLEXT", "");
    @cInclude("GLFW/glfw3.h");
    @cInclude("fmod.h");
    @cInclude("stb_image.h");
    @cInclude("stb_perlin.h");
});

pub var glCreateTextures: @typeInfo(PFNGLCREATETEXTURESPROC).Optional.child = undefined;
pub var glTextureStorage2D: @typeInfo(PFNGLTEXTURESTORAGE2DPROC).Optional.child = undefined;
pub var glTextureStorage2DMultisample: @typeInfo(PFNGLTEXTURESTORAGE2DMULTISAMPLEPROC).Optional.child = undefined;
pub var glTextureParameteri: @typeInfo(PFNGLTEXTUREPARAMETERIPROC).Optional.child = undefined;
pub var glTextureParameterf: @typeInfo(PFNGLTEXTUREPARAMETERFPROC).Optional.child = undefined;
pub var glTextureParameterfv: @typeInfo(PFNGLTEXTUREPARAMETERFVPROC).Optional.child = undefined;
pub var glTextureSubImage2D: @typeInfo(PFNGLTEXTURESUBIMAGE2DPROC).Optional.child = undefined;
pub var glDrawTextureNV: @typeInfo(PFNGLDRAWTEXTURENVPROC).Optional.child = undefined;
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
pub var glUseProgram: @typeInfo(PFNGLUSEPROGRAMPROC).Optional.child = undefined;
pub var glUseProgramStages: @typeInfo(PFNGLUSEPROGRAMSTAGESPROC).Optional.child = undefined;
pub var glCreateShaderProgramv: @typeInfo(PFNGLCREATESHADERPROGRAMVPROC).Optional.child = undefined;
pub var glDeleteProgram: @typeInfo(PFNGLDELETEPROGRAMPROC).Optional.child = undefined;
pub var glCreateProgramPipelines: @typeInfo(PFNGLCREATEPROGRAMPIPELINESPROC).Optional.child = undefined;
pub var glBindProgramPipeline: @typeInfo(PFNGLBINDPROGRAMPIPELINEPROC).Optional.child = undefined;
pub var glStencilFillPathNV: @typeInfo(PFNGLSTENCILFILLPATHNVPROC).Optional.child = undefined;
pub var glStencilStrokePathNV: @typeInfo(PFNGLSTENCILSTROKEPATHNVPROC).Optional.child = undefined;
pub var glCoverFillPathNV: @typeInfo(PFNGLCOVERFILLPATHNVPROC).Optional.child = undefined;
pub var glCoverStrokePathNV: @typeInfo(PFNGLCOVERSTROKEPATHNVPROC).Optional.child = undefined;
pub var glStencilThenCoverFillPathNV: @typeInfo(PFNGLSTENCILTHENCOVERFILLPATHNVPROC).Optional.child = undefined;
pub var glStencilThenCoverStrokePathNV: @typeInfo(PFNGLSTENCILTHENCOVERSTROKEPATHNVPROC).Optional.child = undefined;
pub var glPathCommandsNV: @typeInfo(PFNGLPATHCOMMANDSNVPROC).Optional.child = undefined;
pub var glPathParameteriNV: @typeInfo(PFNGLPATHPARAMETERINVPROC).Optional.child = undefined;
pub var glPathParameterivNV: @typeInfo(PFNGLPATHPARAMETERIVNVPROC).Optional.child = undefined;
pub var glPathParameterfNV: @typeInfo(PFNGLPATHPARAMETERFNVPROC).Optional.child = undefined;
pub var glPathParameterfvNV: @typeInfo(PFNGLPATHPARAMETERFVNVPROC).Optional.child = undefined;

pub fn initOpenGlEntryPoints() void {
    glCreateTextures = @ptrCast(@TypeOf(glCreateTextures), glfwGetProcAddress("glCreateTextures").?);
    glTextureStorage2D = @ptrCast(@TypeOf(glTextureStorage2D), glfwGetProcAddress("glTextureStorage2D").?);
    glTextureStorage2DMultisample = @ptrCast(
        @TypeOf(glTextureStorage2DMultisample),
        glfwGetProcAddress("glTextureStorage2DMultisample").?,
    );
    glTextureParameteri = @ptrCast(@TypeOf(glTextureParameteri), glfwGetProcAddress("glTextureParameteri").?);
    glTextureParameterf = @ptrCast(@TypeOf(glTextureParameterf), glfwGetProcAddress("glTextureParameterf").?);
    glTextureParameterfv = @ptrCast(@TypeOf(glTextureParameterfv), glfwGetProcAddress("glTextureParameterfv").?);
    glTextureSubImage2D = @ptrCast(@TypeOf(glTextureSubImage2D), glfwGetProcAddress("glTextureSubImage2D").?);
    glDrawTextureNV = @ptrCast(@TypeOf(glDrawTextureNV), glfwGetProcAddress("glDrawTextureNV").?);
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
    glUseProgram = @ptrCast(@TypeOf(glUseProgram), glfwGetProcAddress("glUseProgram").?);
    glUseProgramStages = @ptrCast(@TypeOf(glUseProgramStages), glfwGetProcAddress("glUseProgramStages").?);
    glCreateShaderProgramv = @ptrCast(@TypeOf(glCreateShaderProgramv), glfwGetProcAddress("glCreateShaderProgramv").?);
    glDeleteProgram = @ptrCast(@TypeOf(glDeleteProgram), glfwGetProcAddress("glDeleteProgram").?);
    glCreateProgramPipelines = @ptrCast(@TypeOf(glCreateProgramPipelines), glfwGetProcAddress("glCreateProgramPipelines").?);
    glBindProgramPipeline = @ptrCast(@TypeOf(glBindProgramPipeline), glfwGetProcAddress("glBindProgramPipeline").?);
    glStencilFillPathNV = @ptrCast(@TypeOf(glStencilFillPathNV), glfwGetProcAddress("glStencilFillPathNV").?);
    glStencilStrokePathNV = @ptrCast(@TypeOf(glStencilStrokePathNV), glfwGetProcAddress("glStencilStrokePathNV").?);
    glCoverFillPathNV = @ptrCast(@TypeOf(glCoverFillPathNV), glfwGetProcAddress("glCoverFillPathNV").?);
    glCoverStrokePathNV = @ptrCast(@TypeOf(glCoverStrokePathNV), glfwGetProcAddress("glCoverStrokePathNV").?);
    glStencilThenCoverFillPathNV = @ptrCast(
        @TypeOf(glStencilThenCoverFillPathNV),
        glfwGetProcAddress("glStencilThenCoverFillPathNV").?,
    );
    glStencilThenCoverStrokePathNV = @ptrCast(
        @TypeOf(glStencilThenCoverStrokePathNV),
        glfwGetProcAddress("glStencilThenCoverStrokePathNV").?,
    );
    glPathCommandsNV = @ptrCast(@TypeOf(glPathCommandsNV), glfwGetProcAddress("glPathCommandsNV").?);
    glPathParameteriNV = @ptrCast(@TypeOf(glPathParameteriNV), glfwGetProcAddress("glPathParameteriNV").?);
    glPathParameterivNV = @ptrCast(@TypeOf(glPathParameterivNV), glfwGetProcAddress("glPathParameterivNV").?);
    glPathParameterfNV = @ptrCast(@TypeOf(glPathParameterfNV), glfwGetProcAddress("glPathParameterfNV").?);
    glPathParameterfvNV = @ptrCast(@TypeOf(glPathParameterfvNV), glfwGetProcAddress("glPathParameterfvNV").?);
}
