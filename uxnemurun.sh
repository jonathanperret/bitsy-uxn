#!/bin/bash

set -euo pipefail

f=${1:-}
shift

uxnasm $f ${f%.tal}.rom 2>&1 | grep -v 'Unused label'

< /dev/null UXNEMU_TOP_LEFT=1 UXNEMU_ON_TOP=1 uxnemu -s 2 ${f%.tal}.rom "$@" &

if [ "${KEEP_FOCUS:-}" = 1 ]; then
  osascript -l JavaScript -e 'iTerm = Application("iTerm2");
    while(iTerm.frontmost()) { delay(0.1); }
    let i = 0;
    while(!iTerm.frontmost() || (i++<2)) { iTerm.activate(); delay(0.1); }
  '
fi

wait
