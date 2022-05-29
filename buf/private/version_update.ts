import { download } from "https://deno.land/x/download@v1.0.1/mod.ts";
import { crypto } from "https://deno.land/std@0.140.0/crypto/mod.ts";
import { encode } from "https://deno.land/std@0.140.0/encoding/base64.ts";
// @deno-types="https://deno.land/x/chalk_deno@v4.1.1-deno/index.d.ts"
import chalk from 'https://deno.land/x/chalk_deno@v4.1.1-deno/source/index.js';

interface GitHubReleaseJson {
  html_url: string;
  tag_name: string;
  body: string;
  draft: boolean;
  prerelease: boolean;
  created_at: string;
  published_at: string;
  assets: GitHubReleaseAssetJson[];
}
interface GitHubReleaseAssetJson {
  browser_download_url: string;
  name: string;
  label: string;
  state: string;
  content_type: string;
  size: number;
  created_at: string;
  updated_at: string;
}

async function getRepoReleases(ownerName: string, repoName: string): Promise<GitHubReleaseJson[]> {
  const jsonResponse = await fetch(`https://api.github.com/repos/${ownerName}/${repoName}/releases`);
  return await jsonResponse.json();
}

async function sha384HashFile(filePath: string): Promise<string> {
  const fileBytes = await Deno.readFile(filePath);
  const hash =
    new Uint8Array(
      await crypto.subtle.digest(
        "SHA-384",
        fileBytes,
      ),
    );
  return encode(hash);
}


const TRACKED_ASSETS = ['buf-Darwin-arm64', 'buf-Darwin-x86_64', 'buf-Linux-aarch64', 'buf-Linux-x86_64', 'buf-Windows-arm64.exe', 'buf-Windows-x86_64.exe'];

const releases = await getRepoReleases("bufbuild", "buf");
const latestRelease = releases[0];

console.log();
console.log(chalk.bold(`Latest release is ${latestRelease.tag_name}`));
console.log('Getting release data...');
console.log();

function trimBufPrefix(text: string) {
  return text.startsWith('buf-') ? text.substring(4) : text;
}

const releaseInfo: Record<string, Record<string, string>> = {};
const currentReleaseInfo: Record<string, string> = {};
for (const a of latestRelease.assets) {
  if (TRACKED_ASSETS.includes(a.name)) {
    console.log(`Analyzing ${chalk.bold(a.name)} from ${chalk.underline.blue(a.browser_download_url)}`);
    const file = await download(a.browser_download_url, { file: a.name });
    const sha384Hash = await sha384HashFile(file.fullPath);
    Deno.remove(file.fullPath); // Best effort, don't wait for response
    console.log({ asset: a.name, sha384Hash });
    const key = trimBufPrefix(a.name);
    currentReleaseInfo[key] = `sha384-${sha384Hash}`;
  }
}
let version = latestRelease.tag_name;
if (version.startsWith('v')) {
  version = version.substring(1);
}
releaseInfo[version] = currentReleaseInfo;

console.log();
console.log(chalk.bold('Latest version data:'));
console.log(releaseInfo);
