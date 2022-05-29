"""Declare runtime dependencies

These are needed for local dev, and users must install them as well.
See https://docs.bazel.build/versions/main/skylark/deploying.html#dependencies
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("//buf/private:toolchains_repo.bzl", "PLATFORMS", "toolchains_repo")
load("//buf/private:buf_versions.bzl", "BUF_VERSIONS")

_DOC = "TODO"
_ATTRS = {
    "buf_version": attr.string(mandatory = True, values = BUF_VERSIONS.keys()),
    "platform": attr.string(mandatory = True, values = PLATFORMS.keys()),
}

def _buf_repo_impl(repository_ctx):
    filename = "buf-%s" % repository_ctx.attr.platform
    url = "https://github.com/bufbuild/buf/releases/download/v{0}/{1}".format(repository_ctx.attr.buf_version, filename)
    repository_ctx.download(
        url = url,
        integrity = BUF_VERSIONS[repository_ctx.attr.buf_version][repository_ctx.attr.platform],
        executable = True,
        output = filename,
    )
    build_content = """#Generated by buf/repositories.bzl
load("@com_github_actualhq_rules_buf//buf:toolchain.bzl", "buf_toolchain")
buf_toolchain(name = "buf_toolchain", target_tool = "%s")
""" % filename

    # Base BUILD file for this repository
    repository_ctx.file("BUILD.bazel", build_content)

buf_repositories = repository_rule(
    _buf_repo_impl,
    doc = _DOC,
    attrs = _ATTRS,
)

# Wrapper macro around everything above, this is the primary API
def buf_register_toolchains(name = "buf", **kwargs):
    """Convenience macro for users which does typical setup.

    - create a repository for each built-in platform like "buf_linux_amd64" -
      this repository is lazily fetched when node is needed for that platform.
    - TODO: create a convenience repository for the host platform like "buf_host"
    - create a repository exposing toolchains for each platform like "buf_platforms"
    - register a toolchain pointing at each platform
    Users can avoid this macro and do these steps themselves, if they want more control.
    Args:
        name: base name for all created repos, like "buf"
        **kwargs: passed to each node_repositories call
    """
    for platform in PLATFORMS.keys():
        buf_repositories(
            name = name + "_" + platform,
            platform = platform,
            **kwargs
        )
        native.register_toolchains("@%s_toolchains//:%s_toolchain" % (name, platform))

    # repo_host_os_alias(
    #     name = name + "_host",
    #     user_repository_name = name,
    # )
    toolchains_repo(
        name = name + "_toolchains",
        user_repository_name = name,
    )

# WARNING: any changes in this function may be BREAKING CHANGES for users
# because we'll fetch a dependency which may be different from one that
# they were previously fetching later in their WORKSPACE setup, and now
# ours took precedence. Such breakages are challenging for users, so any
# changes in this function should be marked as BREAKING in the commit message
# and released only in semver majors.
def rules_buf_dependencies():
    # The minimal version of bazel_skylib we require
    maybe(
        http_archive,
        name = "bazel_skylib",
        urls = [
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.1.1/bazel-skylib-1.1.1.tar.gz",
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.1.1/bazel-skylib-1.1.1.tar.gz",
        ],
        sha256 = "c6966ec828da198c5d9adbaa94c05e3a1c7f21bd012a0b29ba8ddbccb2c93b0d",
    )
