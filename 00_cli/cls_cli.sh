#!/bin/bash
set -e

BASE="$(cd "$(dirname "$0")" && pwd)"
rm -f "$BASE/cli_log" >/dev/null 2>&1
rm -rf "$BASE/answer_directory" >/dev/null 2>&1