#!/bin/sh
# The Stop hook of the Arios skills. Claude Code runs it when the agent ends a
# turn and passes the hook input as JSON on stdin. When a read that waits for a
# person in Arios still runs in the background and the last message holds no
# link to the person's step, it blocks the end of the turn once and asks for the
# link. It reads only its input and calls nothing. In every other case, and on
# input it cannot read, it prints nothing and exits 0.

awk '
function repeat(text, count,    out) {
  out = ""
  while (count-- > 0) out = out text
  return out
}
# A string token: keep the fields the check reads.
function value(text) {
  if (depth == 1 && key[1] == "last_assistant_message") message = text
  if (depth == 1 && key[1] == "stop_hook_active" && text == "true") active = 1
  if (task && depth == 3) field[key[3]] = text
}
# A running background task of the Arios server counts as a waiting read.
# Claude Code names its server and tool, and its description reads
# <server>/<tool>.
function settle(    server) {
  server = field["server"]
  if (server == "" && index(field["description"], arios "/") == 1) {
    server = arios
  }
  if (field["status"] ~ /^(running|pending|working|input_required)$/ &&
      server == arios) waiting = 1
}
{ input = input $0 "\n" }
END {
  arios = "plugin:arios:arios"
  # Escaped backslashes and quotes become placeholders, so each quote left
  # opens or closes a string.
  gsub(/\\\\/, "\001", input)
  gsub(/\\"/, "\002", input)
  parts = split(input, token, "\"")
  if (parts % 2 == 0) exit
  depth = 0
  for (i = 1; i <= parts; i++) {
    if (i % 2 == 0) {
      next_part = token[i + 1]
      sub(/^[ \t\r\n]*/, "", next_part)
      if (substr(next_part, 1, 1) == ":") key[depth] = token[i]
      else value(token[i])
      continue
    }
    text = token[i]
    for (j = 1; j <= length(text); j++) {
      c = substr(text, j, 1)
      if (c == "{" || c == "[") {
        if (depth == 0 && (c != "{" || seen)) exit
        seen = 1
        kind[++depth] = c
        key[depth] = ""
        if (depth == 3 && c == "{" && kind[2] == "[" && key[1] == "background_tasks") {
          task = 1
          split("", field)
        }
      } else if (c == "}" || c == "]") {
        if (depth < 1 || (c == "}") != (kind[depth] == "{")) exit
        if (task && depth == 3) {
          settle()
          task = 0
        }
        depth--
      } else if (c == ":" && depth == 1 && key[1] == "stop_hook_active") {
        rest = substr(text, j + 1)
        sub(/^[ \t\r\n]*/, "", rest)
        if (rest ~ /^true([ \t\r\n,}]|$)/) active = 1
      } else if (c !~ /[ \t\r\n,:]/ && depth == 0) {
        exit
      }
    }
  }
  if (!seen || depth != 0 || active || !waiting) exit
  # The text of the message, with JSON escapes read and link delimiters spaced.
  gsub(/\\\//, "/", message)
  gsub(/\\u[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]/, " ", message)
  gsub(/\\[bfnrt]/, " ", message)
  gsub(/\001/, " ", message)
  gsub(/\002/, " ", message)
  # A single quote cannot sit in this program, so sprintf makes it.
  gsub("[<>()\"`*" sprintf("%c", 39) "]", " ", message)
  gsub(/\[/, " ", message)
  gsub(/]/, " ", message)
  hex = "[0-9a-fA-F]"
  id = repeat(hex, 8) "-" repeat(hex, 4) "-" repeat(hex, 4) "-" repeat(hex, 4) "-" repeat(hex, 12)
  landing = "^https?://[^/?#@ ]+/bills/" id "[?]company=" id "$"
  while (match(message, /https?:\/\/[^ \t\r\n]+/)) {
    link = substr(message, RSTART, RLENGTH)
    message = substr(message, RSTART + RLENGTH)
    sub(/[.,;:!?]+$/, "", link)
    if (link ~ landing) exit
  }
  printf "%s\n", "{\"decision\":\"block\",\"reason\":\"The person cannot act without the link. Give the person the link of their step from the last Arios result that has one, as a Markdown link. Say it opens their step in Arios, then end your turn. If no Arios result gave a link, end your turn.\"}"
}
' 2>/dev/null
exit 0
