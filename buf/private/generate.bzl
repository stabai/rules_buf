"""
Rules for generating files from protobuf sources.
"""

BufPlugin = provider()

def _buf_generate_impl(ctx):
    buf = ctx.toolchains["@com_github_actualhq_rules_buf//buf:toolchain_type"]
    ctx.actions.declare_directory(
        filename = "generated",
    )
    gen_yaml = "version: v1\nplugins:\n"
    for plugin in ctx.attr.plugins:
        if plugin.remote == None:
            gen_yaml += "  - name: %s\n" % plugin.name
            gen_yaml += "    path: %s\n" % plugin.tool.path
        else:
            gen_yaml += "  - remote: %s\n" % plugin.remote
        if plugin.opt != None and len(opt) > 0:
            gen_yaml += "    opt:\n"
            for o in opt:
              gen_yaml += "      - %s\n" % o
        if plugin.strategy != None:
            gen_yaml += "    strategy: %s\n" % plugin.strategy
        gen_yaml += plugin.strategy
    return DefaultInfo(executable = ctx.outputs.out)

buf_generate = rule(
    implementation = _buf_generate_impl,
    attrs = {
        plugins = attr.label_list(mandatory = True),
    },
)

def _buf_plugin_impl(ctx):
    tools = 0
    if ctx.attr.tool != None:
        tools += 1
    if ctx.attr.remote != None:
        tools += 1
    if tools != 1:
        fail("Exactly one of tool or remote must be specified.")
    return BufPlugin(
        name = ctx.attr.name,
        opt = ctx.attr.opt,
        tool = ctx.files.tool,
        remote = ctx.attr.remote,
        strategy = ctx.attr.strategy,
    )

def buf_plugin = rule(
    implementation = _buf_plugin_impl,
    attrs = {
        name: attr.string(mandatory = True),
        opt: attr.string_list(),
        tool: attr.label(),
        remote: attr.string(),
        strategy: attr.string(),
    },
)
