export INSTANCENAME='lrochette1'
export TOOLID='e6ae5961db2d0850e1155c55dc9619ed'

export URLSTEPMAP="https://$INSTANCENAME.service-now.com/api/sn_devops/v1/devops/orchestration/stepMapping"
export URLNOTIF="https://$INSTANCENAME.service-now.com/api/sn_devops/v1/devops/tool/orchestration"
export URLCC="https://$INSTANCENAME.service-now.com/api/sn_devops/v1/devops/orchestration/changeControl"
export SNUSER='devops.integration.user'

export CI_JOB_STAGE="Build"
export ORCHESTRATION_TASK_URL="http://teamcity:8111/viewType.html?buildTypeId=CorpSiteTC_Ci"
export CI_BRANCH="master"

function step_mapping()  {
  echo "Mapping for stage $CI_JOB_STAGE"
  export BODY="{\"branchName\":\"${CI_BRANCH}\","
  BODY+="\"orchestrationTaskName\":\"${TEAMCITY_PROJECT_NAME}#$CI_JOB_STAGE\","
  BODY+="\"orchestrationTaskURL\":\"$ORCHESTRATION_TASK_URL#$CI_JOB_STAGE\"}"
  echo "BODY $BODY"
  curl -X POST -u ${SNUSER}:$SNPWD -H "Content-Type:application/json" "$URLSTEPMAP?toolId=$TOOLID&toolType=GitLab" --data "$BODY"
}

function start_stage() {
  echo "Notification STARTED"
  export BODY="{\"toolId\":\"$TOOLID\",\"buildNumber\":\"$CI_PIPELINE_ID\","
  BODY+="\"nativeId\":\"${CI_PROJECT_NAME}/${CI_JOB_STAGE}#$CI_CONCURRENT_ID\",\"name\":\"${CI_PROJECT_NAME}/${CI_JOB_STAGE}\","
  BODY+="\"id\":\"${CI_PROJECT_NAME}/${CI_JOB_STAGE}#$CI_CONCURRENT_ID\",\"url\":\"$CI_JOB_URL/\","
  BODY+="\"isMultiBranch\":\"false\",\"orchestrationTaskUrl\":\"$ORCHESTRATION_TASK_URL#$CI_JOB_STAGE\","
  BODY+="\"orchestrationTaskName\":\"${CI_PROJECT_NAME}#${CI_JOB_STAGE}\","
  BODY+="\"upstreamTaskUrl\":\"$UPSTREAM_URL\",\"upstreamId\":\"$UPSTREAM_ID\","
  BODY+="\"result\":\"building\",\"startDateTime\":\""
  BODY+=`date +'%Y-%m-%d %H:%M:%S'`
  BODY+="\"}"
  echo $BODY
  curl -X POST -u ${SNUSER}:$SNPWD -H "Content-Type:application/json" "$URLNOTIF?toolId=$TOOLID&toolType=GitLab" --data "$BODY"
}

function end_stage() {
  echo "Notification COMPLETED"
  export BODY="{\"toolId\":\"$TOOLID\",\"buildNumber\":\"$CI_PIPELINE_ID\","
  BODY+="\"nativeId\":\"${CI_PROJECT_NAME}/${CI_JOB_STAGE}#$CI_CONCURRENT_ID\",\"name\":\"${CI_PROJECT_NAME}/${CI_JOB_STAGE}\","
  BODY+="\"id\":\"${CI_PROJECT_NAME}/${CI_JOB_STAGE}#$CI_CONCURRENT_ID\",\"url\":\"$CI_JOB_URL/\","
  BODY+="\"isMultiBranch\":\"false\",\"orchestrationTaskUrl\":\"$ORCHESTRATION_TASK_URL#$CI_JOB_STAGE\","
  BODY+="\"orchestrationTaskName\":\"${CI_PROJECT_NAME}#${CI_JOB_STAGE}\","
  BODY+="\"upstreamTaskUrl\":\"$UPSTREAM_URL\",\"upstreamId\":\"$UPSTREAM_ID\","
  BODY+="\"result\":\"successful\",\"endDateTime\":\""
  BODY+=`date +'%Y-%m-%d %H:%M:%S'`
  BODY+="\"}"
  echo $BODY
  curl -X POST -u ${SNUSER}:$SNPWD -H "Content-Type:application/json" "$URLNOTIF?toolId=$TOOLID&toolType=GitLab" --data "$BODY"
}
