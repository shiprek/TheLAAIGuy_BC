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
