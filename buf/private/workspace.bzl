"""
Rules for defining a Buf workspace represented by a buf.work.yaml file.
"""

load(":providers.bzl", "BufWorkspace")

def _buf_workspace_impl(ctx):
    configs = [ctx.file.work_yaml_file]
    return [
        DefaultInfo(files = depset(ctx.files.modules + configs)),
        BufWorkspace(
            modules = ctx.files.modules,
            configs = configs,
            work_yaml_file = ctx.attr.work_yaml_file,
        ),
    ]

buf_workspace = rule(
    implementation = _buf_workspace_impl,
    attrs = {
        "modules": attr.label_list(mandatory = True, allow_files = True),
        "work_yaml_file": attr.label(allow_single_file = True),
    },
)
