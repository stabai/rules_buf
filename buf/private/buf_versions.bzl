"""Mirror of release info

Generate latest version from GitHub API using version_update.ts:
  $ deno run --allow-net --allow-read --allow-write --allow-env buf/private/version_update.ts
"""

BUF_VERSIONS = {
    "1.4.0": {
        "Darwin-arm64": "sha384-a8VvQrUbPjbsC/wF/QhLW6pTjXCQ4uiz1GTRzaFvzqKCaXIz7DkrbZ0TGd2itwfz",
        "Darwin-x86_64": "sha384-OzKiiIKJBGlutJOZVRFtMSn6T5uaxQnZHDKg34YLkCp+jrklO3tONvCR1NakeqPo",
        "Linux-aarch64": "sha384-J282N5RVTFxrgW+gBpv4Cpp9ltLcfKoVOBFXPHPm9OjBQO9NlmYU3TB2fvgtNHMm",
        "Linux-x86_64": "sha384-v43sZXRQzoWdtTUVYOncV2sij6JT9ymbgnydW4aWFgZuLS2WjlQ/WdSd7LKDKN57",
        "Windows-arm64.exe": "sha384-wN7QcK3UiFIHj2Nrwevktpko4h6hYkXft/T2Y9/mmlTpwvgr2m8cI/IEqkwDVI3p",
        "Windows-x86_64.exe": "sha384-iM586v5358QZ7yqsnfYlE2GXSvA8lO02vbtxnRgflNOfLO1f5T2ArK4qlXY+3Z9J",
    },
}

LATEST_VERSION = BUF_VERSIONS.keys()[-1]
