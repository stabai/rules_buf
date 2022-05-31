"""
Rules for generating code from protos. Automatically generates the buf.gen.yaml
file from Bazel rule attributes, and runs the buf generate command.
"""

load(":providers.bzl", "BufPlugin", "BufWorkspace")

GENERATED_FOLDER = "buf_generated"

def _buf_gen_yaml_file_impl(ctx):
    outdir = ctx.bin_dir.path + "/" + GENERATED_FOLDER
    gen_yaml = "version: v1\n"
    gen_yaml += "managed:\n"
    gen_yaml += "  enabled: true\n"
    if hasattr(ctx.attr, "go_package_prefix"):
        gen_yaml += "  go_package_prefix:\n"
        gen_yaml += "    default: %s\n" % ctx.attr.go_package_prefix
    gen_yaml += "plugins:\n"
    for p in ctx.attr.plugins:
        plugin = p[BufPlugin]
        if hasattr(plugin, "remote"):
            gen_yaml += "  - remote: %s\n" % plugin.remote
        else:
            gen_yaml += "  - name: %s\n" % plugin.name
            gen_yaml += "    path: %s\n" % plugin.tool.path
        gen_yaml += "    out: %s\n" % outdir
        if hasattr(plugin, "opt") and len(plugin.opt) > 0:
            gen_yaml += "    opt:\n"
            for o in plugin.opt:
                gen_yaml += "      - %s\n" % o
        if hasattr(plugin, "strategy"):
            gen_yaml += "    strategy: %s\n" % plugin.strategy

    ctx.actions.write(output = ctx.outputs.out, content = gen_yaml)
    runfiles = ctx.runfiles(files = [ctx.outputs.out])
    return [DefaultInfo(files = depset([ctx.outputs.out]), data_runfiles = runfiles)]

_buf_gen_yaml_file = rule(
    implementation = _buf_gen_yaml_file_impl,
    attrs = {
        "out": attr.output(),
        "go_package_prefix": attr.string(),
        "plugins": attr.label_list(mandatory = True, providers = [BufPlugin]),
    },
)

def _buf_generate_impl(ctx):
    buf = ctx.toolchains["@com_github_stabai_rules_buf//buf:toolchain_type"]
    workspace = ctx.attr.workspace[BufWorkspace]

    outdir = workspace.work_yaml_file.label.package
    if outdir != "":
        outdir += "/"
    outdir += GENERATED_FOLDER
    gen_out = ctx.actions.declare_directory(outdir)

    configs = workspace.configs + [ctx.file.gen_yaml_file]

    ctx.actions.run(
        inputs = configs + workspace.modules,
        outputs = [gen_out],
        executable = buf.bufinfo.tool_files[0],
        arguments = [
            "generate",
            "--template",
            ctx.file.gen_yaml_file.path,
        ],
        env = {
            "HOME": ".",
        },
        mnemonic = "BufGenerate",
    )
    return [DefaultInfo(files = depset([gen_out]))]

_buf_generate = rule(
    implementation = _buf_generate_impl,
    toolchains = ["@com_github_stabai_rules_buf//buf:toolchain_type"],
    attrs = {
        "workspace": attr.label(mandatory = True, providers = [BufWorkspace]),
        "plugins": attr.label_list(mandatory = True, providers = [BufPlugin]),
        "gen_yaml_file": attr.label(allow_single_file = True),
    },
)

def buf_generate(name, workspace, plugins, go_package_prefix, **kwargs):
    gen_yaml_file_target = "%s_yaml_file" % name
    _buf_gen_yaml_file(
        name = gen_yaml_file_target,
        plugins = plugins,
        go_package_prefix = go_package_prefix,
        out = "buf.gen.yaml",
    )
    return _buf_generate(
        plugins = plugins,
        name = name,
        workspace = workspace,
        gen_yaml_file = ":" + gen_yaml_file_target,
        **kwargs
    )
