"""
Rules for defining a set of protos as a compilable unit, aka Buf module.
"""

def _buf_module_impl(ctx):
    return [DefaultInfo(files = depset(ctx.files.srcs + [ctx.file.config_file]))]

buf_module = rule(
    implementation = _buf_module_impl,
    attrs = {
        "config_file": attr.label(allow_single_file = True),
        "srcs": attr.label_list(mandatory = True, allow_files = True),
    },
)
