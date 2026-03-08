#!/usr/bin/env node

const fs = require("fs");
const https = require("https");

const GITHUB_API = "api.github.com";

function fail(msg) {
  console.error(`❌ ${msg}`);
  process.exit(1);
}

function getEnv(name) {
  const value = process.env[name];
  if (!value) {
    fail(`Missing environment variable: ${name}`);
  }
  return value;
}

function githubRequest(method, path, body = null) {
  const token = getEnv("GITHUB_TOKEN");

  const options = {
    hostname: GITHUB_API,
    path,
    method,
    headers: {
      "Authorization": `Bearer ${token}`,
      "Accept": "application/vnd.github+json",
      "User-Agent": "terraform-notifier",
    },
  };

  return new Promise((resolve, reject) => {
    const req = https.request(options, (res) => {
      let data = "";
      res.on("data", chunk => data += chunk);
      res.on("end", () => {
        if (res.statusCode >= 400) {
          reject(new Error(`GitHub API error ${res.statusCode}: ${data}`));
        }
        resolve(data ? JSON.parse(data) : {});
      });
    });

    req.on("error", reject);

    if (body) {
      req.write(JSON.stringify(body));
    }
    req.end();
  });
}

async function getExistingComment(owner, repo, prNumber, marker) {
  const comments = await githubRequest(
    "GET",
    `/repos/${owner}/${repo}/issues/${prNumber}/comments`
  );

  for (const comment of comments) {
    if (comment.body && comment.body.includes(marker)) {
      return comment.id;
    }
  }
  return null;
}

async function createOrUpdateComment(owner, repo, prNumber, marker, body) {
  const existingId = await getExistingComment(owner, repo, prNumber, marker);

  if (existingId) {
    await githubRequest(
      "PATCH",
      `/repos/${owner}/${repo}/issues/comments/${existingId}`,
      { body }
    );
    console.log("♻️ Updated existing PR comment");
  } else {
    await githubRequest(
      "POST",
      `/repos/${owner}/${repo}/issues/${prNumber}/comments`,
      { body }
    );
    console.log("🆕 Created new PR comment");
  }
}

async function main() {
  const repoFull = getEnv("GITHUB_REPOSITORY"); // owner/repo
  const prNumber = getEnv("PR_NUMBER");
  const environment = getEnv("TF_ENV").toUpperCase();
  const planPath = getEnv("PLAN_PATH");

  const [owner, repo] = repoFull.split("/");

  if (!fs.existsSync(planPath)) {
    fail(`Plan file not found: ${planPath}`);
  }

  const plan = fs.readFileSync(planPath, "utf8");

  const marker = `<!-- terraform-plan-${environment.toLowerCase()} -->`;

  const body = `
${marker}
### 🌍 Terraform Plan – **${environment}**

<details>
<summary>Click to expand</summary>

\`\`\`terraform
${plan}
\`\`\`

</details>
`;

  await createOrUpdateComment(owner, repo, prNumber, marker, body);
}

main().catch(err => fail(err.message));
