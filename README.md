# Arios plugin

Connect Claude, ChatGPT or Codex to Arios. The assistant registers your company from its registry
extract and prepares its KYC application. Once Arios approves the company, it reads your accounts
and bills, brings new invoices in, and prepares a bill payment for you to submit.

**The plugin never moves money.** It has no tool that submits a payment and no tool that approves
one. You submit every payment yourself in Arios, with the supplier and the amount in front of you.

## What it does

| Skill             | What happens                                                                                                          |
| ----------------- | --------------------------------------------------------------------------------------------------------------------- |
| `connect-arios`   | Reports the connection: the companies it was approved for, and what it can do in each one                             |
| `onboard-company` | Registers a company after you confirm its details, prepares its application and answers compliance follow-up requests |
| `collect-bills`   | Brings an invoice into Arios as a bill, sends the PDF, and lets Arios read the fields off the document                |
| `spend-summary`   | Answers a spend question from your transaction feed                                                                   |
| `pay-bill`        | Prepares the payment draft and gives you the link. You submit it in Arios                                             |

The assistant picks the right skill from what you ask. In Claude Code you can also start one by its
name, for example `/arios:collect-bills`.

In Claude Code and Cowork, the `reader` agent answers questions about accounts, balances,
transactions and bills. It only reads.

## Install

| Client                                | Steps                                                                                                                          |
| ------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| Claude Code                           | Run `claude plugin install arios --marketplace arios-co/plugins`, then restart Claude Code                                     |
| claude.ai, Claude desktop app, Cowork | Open **Customize, Plugins**. Select **Add, Add marketplace** and enter `arios-co/plugins`. Install Arios                       |
| Codex CLI                             | Run `codex plugin marketplace add arios-co/plugins`, then `codex plugin add arios@arios`                                       |
| ChatGPT desktop app                   | Run `codex plugin marketplace add arios-co/plugins` and restart the app. Open **Plugins**, select the Arios source and install |
| ChatGPT on the web                    | A workspace admin imports `arios-co/plugins` under **Admin, Plugins**                                                          |

## Connect

1. Connect the Arios server. Your browser opens the Arios page.
   - Claude Code: run `/mcp`, select the `arios` server and authenticate.
   - claude.ai, Claude desktop app, Cowork: open the Arios plugin, then connect Arios on its
     **Connectors** tab.
   - Codex CLI: run `codex mcp login arios`.
   - ChatGPT: open the Arios plugin under **Plugins** and connect it.
2. Sign in to Arios, or sign up and verify your email. In production a new sign-up first waits for
   Arios to approve it. With no company role, approve registration access with no passkey. If you
   already belong to a company, approve the connection with your passkey. The page shows the
   companies and permissions you share.
3. Ask "What can you do in Arios?" to see what the connection can do.

You approve the connection again every 7 days. The assistant tells you when it needs the approval.

The connection never holds more than you hold. You can see it, rename it and revoke it in Arios,
under **Settings, Connected apps**.

The plugin holds no token and no password. Your Arios access lives in your client, from the browser
approval above.

## Open an Arios account

Ask "Open an Arios account for my company" and provide the registry extract. The assistant uploads
it, shows the extracted details and waits for you to confirm before registering. The extracted
registration number and country cannot be replaced here. If either is wrong, register in Arios.

After registration, approve access to the new company and its application. That approval needs a
passkey. Your first passkey added after registration can be used at once. The assistant then drafts
answers from your documents and asks you to confirm business activity and owners. You verify your
identity in Arios. The assistant waits for the result, so you do not have to tell it when you
finished. You then review and submit the application in Arios. The assistant answers later
compliance requests, and you submit each round yourself.

Registration is separate from verification, submission and approval. Financial tools wait until
Arios approves the company. In a client with no shell, the assistant gives you the Arios link so you
can add documents there. The same workflow can register a second company.

## Updates

| Client                                | How to update                                                                                   |
| ------------------------------------- | ----------------------------------------------------------------------------------------------- |
| Claude Code                           | Run `claude plugin update arios@arios`, or turn on auto-update for the marketplace in `/plugin` |
| claude.ai, Claude desktop app, Cowork | Select **Check for updates** on the Arios marketplace, or turn on **Sync automatically**        |
| Codex CLI, ChatGPT desktop app        | Run `codex plugin marketplace upgrade`                                                          |

## What the assistant cannot do here

- Send, submit or approve a payment
- Submit or approve a KYC application, or verify your identity for you
- Save a supplier or enter bank details
- Clear a duplicate warning on a bill
- Work in a company you did not approve
- Read anything you cannot read yourself in Arios

Arios enforces each of these. They hold whether or not this plugin is installed.
