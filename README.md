# The LA AI Guy — Business Central Extension

This repository contains the `LAAI Leads` and `LAAI Time Entry` per-tenant extensions for Microsoft Dynamics 365 Business Central.

## Features

- Lead tracking and lead-to-customer conversion
- A separate Website Intake entity for Squarespace submissions
- Review workflow for new and existing customers
- Controlled creation of open sales quotes and sales orders
- Website-origin and intake-reference fields on sales documents
- CSV import matching the 21-column `Website Intakes` Google Sheet export
- API page for future direct integrations

## Build and deployment

The project uses Microsoft AL-Go for GitHub. Each app has its own folder (`LeadExtension`, `TimeEntry`, and any new app folder). `appFolders` in `.AL-Go/settings.json` is empty, so AL-Go finds every app folder on its own. Deployment settings are in `.github/AL-Go-Settings.json`.

One AL-Go system file carries a local edit: the device-login step in `.github/workflows/PublishToEnvironment.yaml` downloads AL-Go-Helper.ps1 with its companion modules, because the helper alone fails to load. **Update AL-Go System Files** overwrites it, so put that block back in every update PR before merging (the update on 2026-10-08 needed it).

### DEV

1. Open a pull request into `main`. CodeRabbit reviews it and the **Pull Request Status Check** build must pass.
2. Merge it. BC agent pull requests auto-merge once the build is green and CodeRabbit approves.
3. The **CI/CD** run on `main` builds the apps and deploys them to DEV on its own (`DeployToDEV.ContinuousDeployment`). No manual publish is needed.
4. Validate the change in the DEV sandbox.

### TEST

TEST only accepts deployments from the `release` branch. This is set in `DeployToTEST.Branches` and in the TEST GitHub Environment's deployment branch policy, so nothing reaches TEST without landing in DEV first. The same validated commit is promoted; nothing is rebuilt from different code.

1. Fast-forward `release` to the validated commit on `main` (`git checkout release && git merge --ff-only main && git push`).
2. Run the **CI/CD** workflow manually on `release` (a push to `release` does not start it).
3. Run **Publish To Environment** from the `release` branch with app version `current` and environment `TEST`.

No production environment is configured yet.

## Website intake import

Export the `Website Intakes` worksheet from Google Sheets as CSV. In Business Central, open **Website Intakes** and choose **Import Website Intakes**. Duplicate rows are ignored using the website intake ID.

All customer, lead, quote, and order creation remains a reviewed Business Central action. Existing customers are linked directly and do not create a lead.

## Lead list import

Externally researched lead lists (e.g. a prospect list built by an AI helper) import touchlessly via GitHub Actions - no Business Central UI steps required. Full procedure, data contract, and troubleshooting: [Lead list import](https://github.com/shiprek/TheLAAIGuy/blob/main/docs/lead-list-import.md) in the Integration Playbooks repository.

Quick reference:

1. Convert the list to `data/leads/<batch-id>.json` (see `data/leads/2026-09-14-la-small-business.json` for the format) and commit it.
2. `gh workflow run ImportLeads.yaml --ref <main|release> -f environmentName=<DEV|TEST> -f leadsFile=data/leads/<batch-id>.json`
3. Re-running the same batch file is safe - it's create-only and skips any Company Name already present, never updates or deletes.
4. `gh run download <run-id> -n import-results` retrieves each row's BC-assigned `No.` (for building a spreadsheet back for the setup user).

The `LAAI Lead API` (page 50108) reuses the same app-only auth pattern (federated OIDC, `API.ReadWrite.All`, per-environment `LAAI LEADS` permission set, company selected by name not index) documented for `LAAI Customer Posting Grp API` in the Integration Playbooks repo's GitHub-to-Business-Central playbook.

## Code review

A structure and standards review from 3 October 2026 is in [docs/code-review.md](docs/code-review.md). It records findings only. It does not change how the code runs.
