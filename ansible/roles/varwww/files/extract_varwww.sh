#!/bin/bash

# Extract www.oxborrow.net working copy from local git bare repository

set -o errexit
set -o pipefail
set -o nounset

cd /srv/www.oxborrow.net/
git archive --format=tar HEAD docroot/ | \
    tar -xf - --strip=1 -C /var/www/html/
