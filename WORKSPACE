workspace(
    name = "com_github_stabai_rules_buf",
)

load(":internal_deps.bzl", "rules_buf_internal_deps")

rules_buf_internal_deps()

load("//buf:repositories.bzl", "buf_register_toolchains", "rules_buf_dependencies")

rules_buf_dependencies()

buf_register_toolchains(buf_version = "1.4.0")
