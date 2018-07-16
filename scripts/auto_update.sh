#!/bin/bash
set -xeo pipefail

cd $(dirname $0)
for script in [0-9][0-9]_*.sh; do
    ./${script}
done