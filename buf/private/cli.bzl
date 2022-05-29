def _buf_cli_impl(ctx):
    buf = ctx.toolchains["@com_github_actualhq_rules_buf//buf:toolchain_type"]
    ctx.actions.symlink(
        output = ctx.outputs.out,
        target_file = buf.bufinfo.tool_files[0],
        is_executable = True,
    )
    return DefaultInfo(executable = ctx.outputs.out)

_buf_cli = rule(
    implementation = _buf_cli_impl,
    toolchains = ["@com_github_actualhq_rules_buf//buf:toolchain_type"],
    executable = True,
    attrs = {
        "out": attr.output(mandatory = True),
    },
)

def buf_cli(**kwargs):
    _buf_cli(
        out = "buf",
        **kwargs
    )
