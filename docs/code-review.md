# Code review — 3 October 2026

Review only. No AL was edited.

[AGENTS.md](../AGENTS.md) says the AL in this repo is written by the local Business Central agent and committed unedited. Analyzer findings are evidence about the agent. Fixes go into the prompts and checks in [LAAI-Document-Library](https://github.com/shiprek/LAAI-Document-Library), not into these files by hand. This note is the list of what the next draft should change, and what a human should not "clean up" in place.

Bar: Microsoft's [AL coding guidelines](https://learn.microsoft.com/dynamics365/business-central/dev-itpro/compliance/apptest-bestpracticesforalcode) and [alguidelines.dev](https://alguidelines.dev/), plus upgrade-safe procedure structure: integration events, extensible enums, stable API versions, no UI inside codeunits, and id ranges that match `app.json`.

## High

1. **Lead numbers are not safe across inserts or later apps.** [Lead.Table.al](../LeadExtension/Lead.Table.al) `OnInsert` (line 109) calls local `GetNextLeadNo` (line 120). That procedure `FindLast`s on `"No."`, strips the literal `'LEAD-'`, and `Evaluate`s the rest with no `if`. A number that sorts last and is not `LEAD-` plus digits makes `Evaluate` throw, and every later insert fails. The card leaves `"No."` editable, so a typed value can do this. Two API inserts at the same time can take the same number: there is no lock and no No. Series. There is no integration event, so another app cannot replace the pattern without editing the table. The comment on line 117 already says to swap this for a No. Series. Do that in a codeunit (`GetNextNo` under a lock) and publish `OnBeforeGetNextLeadNo` / `OnAfterGetNextLeadNo`.

2. **`IsHandled` does not cover the rest of the procedure.** In [WebsiteIntakeMgt.Codeunit.al](../LeadExtension/WebsiteIntakeMgt.Codeunit.al) the events are the right shape, but the work after `if not IsHandled` still runs:
   - `CreateLead` (line 15) always calls `LeadToCustomerMgt.CreateContact` after the event. A subscriber that already created the contact hits `ContactAlreadyExistsErr`.
   - `CreateOpenSalesQuote` (line 117) writes `Intake."Sales Quote No."` from `SalesHeader."No."` even when `IsHandled` is true. If the subscriber did not fill `SalesHeader`, the intake stores a blank quote number, sets status to `"SOW Draft"`, and logs success.
   - `CreateOpenSalesOrder` (line 143) assigns `OrderHeader.Status` and calls `Modify` even when `IsHandled` is true. A subscriber that does not return a persisted order header still hits `Modify`.

   Put every side effect inside `if not IsHandled`, or give each step (`CreateQuoteHeader`, `ApplyIntakeResult`) its own event.

3. **`ConvertToCustomer` is one public procedure and has no events.** [LeadToCustomerMgt.Codeunit.al](../LeadExtension/LeadToCustomerMgt.Codeunit.al) `ConvertToCustomer` (line 44) confirms, builds contacts, inserts the customer, writes `Contact Business Relation`, forces `Status::Won`, and shows a `Message`. `CreateContact` (line 22) also shows a `Message`. A job, an API, or a test cannot call these without a dialog, and a subscriber cannot add a field or skip `Won` without reimplementing the whole procedure. `WebsiteIntakeMgt.ConvertLeadToCustomer` calls `ConvertToCustomer`, so the confirm sits on that path too. Split into `EnsureCompanyContact`, `EnsurePersonContact`, `CreateCustomerFromLead`, `LinkCustomerRelation`, and `MarkLeadConverted`. Keep `Confirm` and `Message` on the page action. Publish `OnBefore` / `OnAfter` with `IsHandled`. The branch that copies a person contact into the company-contact variable (lines 81–83) should still insert a company contact before the business relation.

4. **There is no test app.** AL-Go has `Test Current`, `Test Next Minor`, and `Test Next Major` workflows. This repo has no test project. Numbering, the person-versus-company branches, the `IsHandled` paths, CSV parsers, and API insert resets are exactly what a future BC version will break first. Add a test app that calls the codeunits without the UI.

## Medium

4. **API insert rules live on the page.** [WebsiteIntake.Api.Page.al](../LeadExtension/WebsiteIntake.Api.Page.al) `OnInsertRecord` (line 64) sets status, clears lead/customer/quote/order numbers, and sets `"SOW Required" := true`. The card does not share that procedure. API version `v1.0` is correctly `Extensible = false` (do not extend an API page; ship `v2.0`). The rules still need one codeunit so v1 and v2 do not each invent a copy. `Extensible = false` on the API pages (`LeadApi`, `WebsiteIntake.Api`, `CustomerPostingGroupApi`, `TimeEntryApi`) is the right choice. Do not flip it.

5. **The CSV xmlport is a closed parser.** [WebsiteIntakeCsv.XmlPort.al](../LeadExtension/WebsiteIntakeCsv.XmlPort.al) maps text to enums in local procedures (`ParseIntakeType`, `ParseAIMaturity`, `ParseTiming`, `ParseNextStep`) and publishes no events. The enums are `Extensible = true`, so another app can add a value that this parser will not accept. Either document the xmlport as a closed import contract, or raise an event when a token does not match so a subscriber can map an added value.

6. **`enum "LAAI Time Type"` does not set `Extensible`.** Every enum in `LeadExtension` sets `Extensible = true`. This one omits the property. The AL default is `false`, so a later app cannot add a time type. Set `Extensible = true` while this app is still `1.0.0.0`. Turning it on later is allowed; turning it off later is not.

7. **`application` and `platform` are `1.0.0.0` with `runtime` `13.0` in both apps.** Those two properties are the minimum Base Application and platform versions this code is compiled against, not a placeholder. `1.0.0.0` does not pin the Customer, Contact, or `"Sales-Quote to Order"` surface this code calls, so a later BC signature change is not gated by `app.json`. `runtime` `13.0` is a real floor (Business Central 2024 release wave 1). It still publishes to newer servers. Set `application` and `platform` to the oldest version you actually compile and run in DEV, and keep `runtime` on that same release. Do this as its own change.

8. **`LinkExistingCustomer` uses `Page.RunModal` inside the codeunit** ([WebsiteIntakeMgt.Codeunit.al](../LeadExtension/WebsiteIntakeMgt.Codeunit.al) line 74), even though an `IsHandled` event wraps the modal. The default branch should be a procedure the page calls after the user picks a customer, so an API can pass a customer number without a dialog. `CreateOpenSalesOrder` also assigns `OrderHeader.Status := Open` directly (line 143) instead of the reopen path, and it requires the quote to be `Released`. A later status model has to replace the whole procedure. Raise an event around header defaults and line creation, and do not assign `Status` directly.

## Low

- Time entry is its own app ([TimeEntry/app.json](../TimeEntry/app.json), ids 50150–50199), which is the right split from LAAI Leads. The table still has no captions, no field `DataClassification`, no `TableRelation` on `Customer`, and no insert event. The `Chat ID` key is unique with no default, so a second blank chat id from the list page fails. The API page allows modify and delete while the permission set is only insert and read. Add `"Customer No."` with `TableRelation = Customer`, generate a chat id when it is blank or do not treat blank as unique, and publish `OnBeforeInsertTimeEntry`.
- API field names are camelCase and stable. Do not rename `websiteIntake`, `lead`, `timeEntry`, or `customerPostingGroup` in `v1.0`. Add fields only as optional. Removing or retyping a field means a new `APIVersion`. `OnInsertRecord` overwriting status and document numbers is part of the v1.0 contract. Change it only behind a new version or an event.
- [LAAI.PermissionSet.al](../LeadExtension/LAAI.PermissionSet.al) includes `tabledata "Customer Posting Group" = RIMD` for every leads user, while the posting-group API mirrors G/L accounts and allows modify and delete. Conversion code writes Customer, Contact, and sales documents, which are not all in this set. A separate permission set for the posting-group API is the smaller surface.
- Lead and intake pages that were sampled have ToolTips on the card and the role center. UICop will still flag list pages and the intake card fields that have no ToolTip (`LeadList.Page.al`, `WebsiteIntakeCard.Page.al`, `WebsiteIntakeList.Page.al`, `TimeEntryList.Page.al`). Your rule is that those warnings are a score, not a merge gate.

## Already in good shape

- `WebsiteIntakeMgt` is the pattern to copy: public procedure, `IsHandled`, integration event before and after, then a local `LogEvent`.
- Enums in `LeadExtension` are extensible and use captions.
- API pages use `ODataKeyFields = SystemId`, `DelayedInsert = true`, and a publisher/group/version. That versioning is how you add fields later without breaking current callers.
- Sales document links are table extensions and page extensions, not copies of the base objects.
- Object names use the `LAAI` prefix. Ids in `LeadExtension` stay inside 50100–50149.

## What not to do with this review

Do not open a pull request that restyles this AL to satisfy CodeCop or the notes above. Change LAAI-Document-Library so the next agent draft fails the check, then let the agent publish the AL. `app.json` version pins, if you change them, are a human decision about which BC version you support, not an agent restyle.
