#!/bin/bash
echo "TC: Starting Step registration"
echo "TC shell: $SHELL"
pwd
ls -ail
source TC/vars.sh

echo "TC: Environment variable read"
env

echo "TC: Starting Step registration"

echo "Mapping for stage $CI_JOB_STAGE"
export BODY="{\"branchName\":\"${teamcity.build.branch}\","
BODY+="\"orchestrationTaskName\":\"${TEAMCITY_PROJECT_NAME}#$CI_JOB_STAGE\","
BODY+="\"orchestrationTaskURL\":\"$ORCHESTRATION_TASK_URL#$CI_JOB_STAGE\"}"
echo "BODY $BODY"
curl -X POST -u ${SNUSER}:$SNPWD -H "Content-Type:application/json" "$URLSTEPMAP?toolId=$TOOLID&toolType=GitLab" --data "$BODY"
