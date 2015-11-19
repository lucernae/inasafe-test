#!/bin/bash

cd /home/test/inasafe

. run-env-linux.sh /usr

make pep8
xvfb-run --server-args="-screen 0, 1024x768x24" nosetests -A 'not slow' -v --with-id --with-xcoverage --with-xunit --verbose --cover-package=safe safe
