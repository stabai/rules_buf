# Bazel rules for Buf

This is experimental to provide basic access to the Buf CLI and generate proto outputs using Buf's managed mode in Bazel.

Depend on this at your own risk!

## Sample Code

### `WORKSPACE` file setup

```skylark
load("@com_github_stabai_rules_buf//buf:repositories.bzl", "buf_register_toolchains", "rules_buf_dependencies")

rules_buf_dependencies()

buf_register_toolchains(buf_version = "1.4.0")
```

### `BUILD.bazel` file usage

```skylark
load(
    "@com_github_stabai_rules_buf//buf:defs.bzl",
    "buf_cli",
    "buf_generate",
    "buf_module",
    "buf_workspace",
)


# In //BUILD.bazel file
buf_workspace(
    name = "buf_workspace",
    modules = ["//proto"],
    work_yaml_file = "buf.work.yaml",
)

buf_generate(
    name = "buf_generate",
    go_package_prefix = "github.com/myorg/myrepo/gen/proto/go",
    plugins = [
        "@com_github_stabai_rules_buf//buf/plugins:go",
    ],
    workspace = ":buf_workspace",
)


# In //proto/BUILD.bazel file
buf_module(
    name = "proto",
    srcs = glob(
        ["**/*.proto"],
    ),
    config_file = "buf.yaml",
    visibility = ["//:__pkg__"],
)
```
