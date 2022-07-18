#!/usr/bin/env sh
# docs: https://vuepress.vuejs.org/guide/deploy.html#github-pages
# abort on errors
set -e

cd ./src

# cleanup
rm -rf ./build
rm -rf ./node_modules

# build
npm ci --cache .npm --prefer-offline --silent --no-optional
npm ci @vue/cli --cache .npm --prefer-offline --silent
npm run build-prod

# navigate into the build output directory
cd build

echo 'live-shopping-ui.agoston.io' > CNAME

git init
git add -A
git commit -m 'deploy'

git push -f git@github.com:agoston-io/live-shopping-ui.git master:gh-pages

cd -
