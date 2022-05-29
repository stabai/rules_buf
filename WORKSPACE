workspace(
    name = "com_github_actualhq_rules_buf",
)

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

load(":internal_deps.bzl", "rules_buf_internal_deps")

rules_buf_internal_deps()

load("//buf:repositories.bzl", "buf_register_toolchains", "rules_buf_dependencies")

rules_buf_dependencies()

buf_register_toolchains(buf_version = "1.4.0")
