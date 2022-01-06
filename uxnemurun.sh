#!/bin/bash

set -euo pipefail

f=${1:-}
shift

uxnasm $f ${f%.tal}.rom 2>&1 | grep -v 'Unused label'

< /dev/null UXNEMU_TOP_LEFT=1 UXNEMU_ON_TOP=1 uxnemu ${f%.tal}.rom "$@" &

for i in {1..20}; do
  osascript -l JavaScript -e 'iTerm = Application("iTerm2"); if(!iTerm.frontmost()) iTerm.activate()' > /dev/null
  sleep .1
done

wait
