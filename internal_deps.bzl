"""Our "development" dependencies

Users should *not* need to install these.
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def rules_buf_internal_deps():
    maybe(
        http_archive,
        name = "bazel_skylib",
        sha256 = "07b4117379dde7ab382345c3b0f5edfc6b7cff6c93756eac63da121e0bbcc5de",
        strip_prefix = "bazel-skylib-1.1.1",
        urls = [
            "https://github.com/bazelbuild/bazel-skylib/archive/refs/tags/1.1.1.tar.gz",
        ],
    )
    maybe(
        http_archive,
        name = "io_bazel_stardoc",
        sha256 = "c9794dcc8026a30ff67cf7cf91ebe245ca294b20b071845d12c192afe243ad72",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/stardoc/releases/download/0.5.0/stardoc-0.5.0.tar.gz",
            "https://github.com/bazelbuild/stardoc/releases/download/0.5.0/stardoc-0.5.0.tar.gz",
        ],
    )
    maybe(
        http_archive,
        name = "aspect_bazel_lib",
        sha256 = "aedc52557a74dc69d0be0638d6bad38f0f617e2fef475a2945e2662ae5ee2f94",
        strip_prefix = "bazel-lib-0.9.7",
        url = "https://github.com/aspect-build/bazel-lib/archive/refs/tags/v0.9.7.tar.gz",
    )
