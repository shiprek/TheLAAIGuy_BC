# Operations

How to build, deploy and load data for the apps in this repo. The [README](../README.md) gives the overview. This page is the operator's runbook.

## Build and deployment

The project uses Microsoft AL-Go for GitHub. Each app has its own folder (`LeadExtension`, `TimeEntry`, and any new app folder). `appFolders` in `.AL-Go/settings.json` is empty, so AL-Go finds every app folder on its own. Deployment settings are in `.github/AL-Go-Settings.json`.

One AL-Go system file carries a local edit: the device-login step in `.github/workflows/PublishToEnvironment.yaml` downloads AL-Go-Helper.ps1 with its companion modules, because the helper alone fails to load. **Update AL-Go System Files** overwrites it, so put that block back in every update PR before merging (the update on 2026-10-08 needed it).

`artifact` in `.AL-Go/settings.json` pins the BC version the build compiles against (sandbox 29.0.54011.56023, us), so the artifact cache hits and a build takes about 3 minutes instead of 14. Move the pin to a newer version on purpose, in its own PR between pieces of work, and never to a version newer than DEV or TEST runs.

### DEV

1. Open a pull request into `main`. CodeRabbit reviews it and the **Pull Request Status Check** build must pass.
2. Merge it. BC agent pull requests auto-merge once the build is green, CodeRabbit approves, and every review thread is resolved.
3. The **CI/CD** run on `main` builds the apps and deploys them to DEV on its own (`DeployToDEV.ContinuousDeployment`). No manual publish is needed. CI/CD ignores pushes that change only Markdown files or only workflow files other than `CICD.yaml` (`paths-ignore` in `CICD.yaml`), so such a merge deploys nothing; run CI/CD manually on `main` if DEV needs a fresh deploy.
4. Validate the change in the DEV sandbox.

### TEST

TEST only accepts deployments from the `release` branch. This is set in `DeployToTEST.Branches` and in the TEST GitHub Environment's deployment branch policy. **Publish To Environment** is started by hand and accepts other app versions, so the settings alone do not stop an unvalidated build from reaching TEST. The procedure does: promote only the exact commit validated in DEV, and publish the build of that commit.

1. Fast-forward `release` to the exact commit validated in DEV (`git checkout release && git merge --ff-only <validated-sha> && git push`). Do not merge `main` itself, which may have moved on since DEV was validated.
2. Run the **CI/CD** workflow manually on `release` (a push to `release` does not start it).
3. Run **Publish To Environment** from the `release` branch with app version `current` and environment `TEST`.

No production environment is configured yet.

## Website intake import

Export the `Website Intakes` worksheet from Google Sheets as CSV. In Business Central, open **Website Intakes** and choose **Import Website Intakes**. Rows whose website intake ID (`Submission Id`) is already in Business Central are skipped. A row with a blank intake ID is always imported, so it can create a duplicate.

All customer, lead, quote, and order creation remains a reviewed Business Central action. Existing customers are linked directly and do not create a lead.

## Lead list import

Externally researched lead lists (e.g. a prospect list built by an AI helper) import touchlessly via GitHub Actions - no Business Central UI steps required. The full procedure, data contract, and troubleshooting are in the maintainer's private playbooks.

Quick reference:

1. Convert the list to `data/leads/<batch-id>.json` (see `data/leads/2026-09-14-la-small-business.json` for the format) and commit it.
2. `gh workflow run ImportLeads.yaml --ref <main|release> -f environmentName=<DEV|TEST> -f leadsFile=data/leads/<batch-id>.json`
3. Re-running the same batch file is safe once the previous run has finished - it's create-only and skips any Company Name already present, never updates or deletes. The script reads the existing leads once at the start, so two runs that overlap can both create the same lead. Start one run at a time.
4. `gh run download <run-id> -n import-results` retrieves each row's BC-assigned `No.` (for building a spreadsheet back for the setup user).

The `LAAI Lead API` (page 50108) reuses the same app-only auth pattern (federated OIDC, `API.ReadWrite.All`, per-environment `LAAI LEADS` permission set, company selected by name not index) that `LAAI Customer Posting Grp API` uses, as documented in the maintainer's private GitHub-to-Business-Central playbook.

## Code review

A structure and standards review from 3 October 2026 is in [code-review.md](code-review.md). It records findings only. It does not change how the code runs.
