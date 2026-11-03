# Arios plugin

Connect Claude, ChatGPT or Codex to your company in Arios. The assistant reads your accounts and
your bills, brings new invoices in, and prepares a bill payment for you to submit.

**The plugin never moves money.** It has no tool that submits a payment and no tool that approves
one. You submit every payment yourself in Arios, with the supplier and the amount in front of you.

## What it does

| Skill           | What happens                                                                                           |
| --------------- | ------------------------------------------------------------------------------------------------------ |
| `connect-arios` | Reports the connection: the companies it was approved for, and what it can do in each one              |
| `collect-bills` | Brings an invoice into Arios as a bill, sends the PDF, and lets Arios read the fields off the document |
| `spend-summary` | Answers a spend question from your transaction feed                                                    |
| `pay-bill`      | Prepares the payment draft and gives you the link. You submit it in Arios                              |

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
2. Sign in to Arios and approve the connection with your passkey. The page shows which companies and
   which permissions you are giving. Every company you tick is one the assistant may work in.
3. Ask "What can you do in Arios?" to see what the connection can do.

You approve the connection again every 7 days. The assistant tells you when it needs the approval.

The connection never holds more than you hold. You can see it, rename it and revoke it in Arios,
under **Settings, Connected apps**.

The plugin holds no token and no password. Your Arios access lives in your client, from the browser
approval above.

## Updates

| Client                                | How to update                                                                                   |
| ------------------------------------- | ----------------------------------------------------------------------------------------------- |
| Claude Code                           | Run `claude plugin update arios@arios`, or turn on auto-update for the marketplace in `/plugin` |
| claude.ai, Claude desktop app, Cowork | Select **Check for updates** on the Arios marketplace, or turn on **Sync automatically**        |
| Codex CLI, ChatGPT desktop app        | Run `codex plugin marketplace upgrade`                                                          |

## What the assistant cannot do here

- Send, submit or approve a payment
- Save a supplier or enter bank details
- Clear a duplicate warning on a bill
- Work in a company you did not approve
- Read anything you cannot read yourself in Arios

Arios enforces each of these. They hold whether or not this plugin is installed.
