# The LA AI Guy — Business Central Extension

This repository contains the `LAAI Leads` per-tenant extension for Microsoft Dynamics 365 Business Central.

## Features

- Lead tracking and lead-to-customer conversion
- A separate Website Intake entity for Squarespace submissions
- Review workflow for new and existing customers
- Controlled creation of open sales quotes and sales orders
- Website-origin and intake-reference fields on sales documents
- CSV import matching the 21-column `Website Intakes` Google Sheet export
- API page for future direct integrations

## Build and deployment

The project uses Microsoft AL-Go for GitHub. Application source is in `LeadExtension` and project settings are in `.AL-Go/settings.json`.

1. Push or merge the desired changes to `main`.
2. Confirm the **CI/CD** workflow completes successfully.
3. Run **Publish To Environment** from GitHub Actions.
4. Select app version `current` and environment `DEV`.
5. Validate the change in the DEV sandbox.
6. Only once validated, promote to TEST: fast-forward the `release` branch to the validated commit on `main` (`git checkout release && git merge --ff-only main && git push`), then run **Publish To Environment** again with environment `TEST`.

`TEST` only accepts deployments from the `release` branch — this is enforced both in `.github/AL-Go-Settings.json` (`DeployToTEST.Branches`) and as a GitHub Environment deployment branch policy, so nothing can reach TEST without first landing and being validated in DEV. No production environment is configured yet.

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
