"""
Rules for defining a plugin for the Buf generator.
"""

load(":providers.bzl", "BufPlugin")

def _buf_plugin_impl(ctx):
    tool_count = 0
    tool = None
    remote = None
    if hasattr(ctx.attr, "tool"):
        tool_count += 1
        tool = ctx.attr.tool
    if (ctx.attr, "remote"):
        tool_count += 1
        remote = ctx.attr.remote
    if tool_count != 1:
        fail("Exactly one of tool or remote must be specified.")
    return BufPlugin(
        name = ctx.attr.name,
        opt = ctx.attr.opt,
        tool = tool,
        remote = remote,
        strategy = ctx.attr.strategy,
    )

remote_buf_plugin = rule(
    implementation = _buf_plugin_impl,
    attrs = {
        "remote": attr.string(mandatory = True),
        "opt": attr.string_list(),
        "strategy": attr.string(),
    },
)
local_buf_plugin = rule(
    implementation = _buf_plugin_impl,
    attrs = {
        "tool": attr.label(
            mandatory = True,
            allow_single_file = True,
            executable = True,
            cfg = "exec",
        ),
        "opt": attr.string_list(),
        "strategy": attr.string(),
    },
)
