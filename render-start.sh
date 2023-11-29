#!/bin/bash

#
# Meteor run script for Render
#

echo "Starting Meteor application"

APP_DIR=$RENDER_PROJECT_ROOT/app
export MONGO_URL="${MONGO_URL:-mongodb://$MONGO_HOST:$MONGO_PORT}"
export ROOT_URL="${ROOT_URL:-http://$RENDER_EXTERNAL_HOSTNAME}"

cd $APP_DIR
node main.js
