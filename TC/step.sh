#!/bin/bash
echo "TC: Starting Step registration"
source TC/vars.sh
echo "TC: Environment variable read"
env

echo "TC: Starting Step registration"

export CI_BRANCH="master"

echo "Mapping for stage $CI_JOB_STAGE"
export BODY="{\"branchName\":\"${CI_BRANCH}\","
BODY+="\"orchestrationTaskName\":\"${TEAMCITY_PROJECT_NAME}#$CI_JOB_STAGE\","
BODY+="\"orchestrationTaskURL\":\"$ORCHESTRATION_TASK_URL#$CI_JOB_STAGE\"}"
echo "BODY $BODY"
curl -X POST -u ${SNUSER}:$SNPWD -H "Content-Type:application/json" "$URLSTEPMAP?toolId=$TOOLID&toolType=GitLab" --data "$BODY"
