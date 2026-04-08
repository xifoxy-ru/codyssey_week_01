#!/bin/bash
BASE="$(cd "$(dirname "$0")" && pwd -P)"
rm -f "$BASE/cli_log" >/dev/null 2>&1
rm -rf "$BASE/answer_directory" >/dev/null 2>&1