#!/bin/bash
BASE="$(cd "$(dirname "$0")" && pwd -P)"
rm -f "$BASE/permission_log" >/dev/null 2>&1
rm -f "$BASE/permission_test_file" >/dev/null 2>&1
rm -rf "$BASE/permission_test_dir" >/dev/null 2>&1