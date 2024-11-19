#!/bin/bash

set -e

if [ "$RUN_MIGRATIONS" == "true" ]; then
    echo 'Migration in progress...'
    python manage.py migrate 
    python manage.py dumpdata --database=sqlite --natural-foreign --natural-primary -e contenttypes -e auth.Permission --indent 4 > datadump.json
    python manage.py loaddata datadump.json
else
    python manage.py migrate;
fi

python manage.py runserver 0.0.0.0:8000
