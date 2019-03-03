#!/bin/bash

tmpDir=./.target

if [ -z "$concordApiKey" ]; then
    echo "'concordApiKey' variable isn't set!"
    exit 1
fi

if [ -z "$serverAddress" ]; then
    echo "'concordApiKey' variable isn't set!"
    exit 1
fi


rm -rf ${tmpDir} && mkdir ${tmpDir}
rsync -aq --exclude=.git --exclude-from=.gitignore --progress . ${tmpDir} --exclude ${tmpDir}
# cp concord.yml ${tmpDir}

pushd ${tmpDir} && zip -r payload.zip ./* > /dev/null && popd

curl -s \
    -H "Authorization: ${concordApiKey}" \
    -F org=Default \
    -F project=ben-site \
    -F archive=@${tmpDir}/payload.zip \
    "${serverAddress}/api/v1/process"
