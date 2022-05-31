"""
Rule to provide a binary target for the Buf executable.
"""

def _buf_cli_impl(ctx):
    buf = ctx.toolchains["@com_github_stabai_rules_buf//buf:toolchain_type"]
    out = ctx.actions.declare_file("buf")
    ctx.actions.symlink(
        output = out,
        target_file = buf.bufinfo.tool_files[0],
        is_executable = True,
    )
    return DefaultInfo(executable = out)

buf_cli = rule(
    implementation = _buf_cli_impl,
    toolchains = ["@com_github_stabai_rules_buf//buf:toolchain_type"],
    executable = True,
)
