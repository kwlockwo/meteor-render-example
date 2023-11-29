#!/bin/bash

#
# Meteor build script for Render
#

# fail fast.
set -e

if [ -n "$BUILD_VERBOSE" ]; then
  set -x
fi

echo "Building Meteor app on Render"

CACHE_DIR=$XDG_CACHE_HOME
METEOR_DIR=$CACHE_DIR/meteor
SRC_DIR=$RENDER_SRC_ROOT
BUILD_DIR=$RENDER_PROJECT_ROOT/build
APP_DIR=$RENDER_PROJECT_ROOT/app

ROOT_URL="${ROOT_URL:-http://$RENDER_EXTERNAL_HOSTNAME}"

if [ ! -d "$SRC_DIR/.meteor" ]; then
  echo "ERROR: No Meteor app found.  Your source is missing .meteor directory"
fi

if [ -z "$BUILD_VERBOSE" ]; then
  METEOR_PRETTY_OUTPUT=0
fi

mkdir -p $METEOR_DIR

if [ -e "$METEOR_DIR/.meteor/meteor" ]; then
  echo "... Existing Meteor installation found, using it."
else
  echo "... Installing Meteor"
  curl -sS "https://install.meteor.com/" | HOME="$METEOR_DIR" /bin/sh
fi

# Function to execute meteor with proper HOME.
function METEOR {
  ARGS=$@
  HOME="$METEOR_DIR" "$METEOR_DIR/.meteor/meteor" $ARGS
}

echo "... Installing dependencies"
npm install

echo "... Bundling app with ROOT_URL: $ROOT_URL to $BUILD_DIR"
METEOR build --server $ROOT_URL --server-only --directory $BUILD_DIR

echo "... Moving built app to runtime location: $APP_DIR"
mv $BUILD_DIR/bundle $APP_DIR
rmdir $BUILD_DIR

echo "... Installing production dependencies"
cd $APP_DIR/programs/server
npm install --production

echo "Meteor build complete on Render"
