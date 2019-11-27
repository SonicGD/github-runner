echo $GITHUB_REPO
echo $GITHUB_TOKEN
./config.sh --url ${GITHUB_REPO} --token ${GITHUB_TOKEN}
./run.sh
