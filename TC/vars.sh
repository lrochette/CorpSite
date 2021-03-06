# Configuration parameters
#   teamcity.project.id	  CorpSiteTC                  $TEAMCITY_PROJECT_NAME
#   teamcity.build.id	    46

# System properties
#   system.teamcity.buildConfName	  CI                $TEAMCITY_BUILDCONF_NAME
#   system.teamcity.buildType.id	  CorpSiteTC_Ci
#   system.build.number	            37

export INSTANCENAME='lrochette1'
export TOOLID='4c00e9a81bac5410a9aec88c0a4bcb72'

export URLSTEPMAP="https://$INSTANCENAME.service-now.com/api/sn_devops/v1/devops/orchestration/stepMapping"
export URLNOTIF="https://$INSTANCENAME.service-now.com/api/sn_devops/v1/devops/tool/orchestration"
export URLCC="https://$INSTANCENAME.service-now.com/api/sn_devops/v1/devops/orchestration/changeControl"
export SNUSER='devops.integration.user'

export STAGE="Build"
export BRANCH="master"
export PIPELINE_NAME="${TEAMCITY_PROJECT_NAME}_${TEAMCITY_BUILDCONF_NAME}"
export ORCHESTRATION_TASK_URL="http://teamcity:8111/buyildConfiguration/$PIPELINE_NAME"

function step_mapping()  {
  echo "Mapping for stage $STAGE"
  export BODY="{\"branchName\":\"${BRANCH}\","
  BODY+="\"orchestrationTaskName\":\"${$PIPELINE_NAME}#$STAGE\","
  BODY+="\"orchestrationTaskURL\":\"$ORCHESTRATION_TASK_URL#$STAGE\"}"
  echo "BODY $BODY"
  curl -X POST -u ${SNUSER}:$SNPWD -H "Content-Type:application/json" "$URLSTEPMAP?toolId=$TOOLID&toolType=TeamCity" --data "$BODY"
}

function start_stage() {
  echo "Notification STARTED"
  export BODY="{\"toolId\":\"$TOOLID\",\"buildNumber\":\"$BUILDID\","
  BODY+="\"nativeId\":\"${PIPELINE_NAME}/${STAGE}#$CI_CONCURRENT_ID\",\"name\":\"${PIPELINE_NAME}/${STAGE}\","
  BODY+="\"id\":\"${PIPELINE_NAME}/${STAGE}#$CI_CONCURRENT_ID\",\"url\":\"$CI_JOB_URL/\","
  BODY+="\"isMultiBranch\":\"false\",\"orchestrationTaskUrl\":\"$ORCHESTRATION_TASK_URL#$STAGE\","
  BODY+="\"orchestrationTaskName\":\"${PIPELINE_NAME}#${STAGE}\","
  BODY+="\"upstreamTaskUrl\":\"$UPSTREAM_URL\",\"upstreamId\":\"$UPSTREAM_ID\","
  BODY+="\"result\":\"building\",\"startDateTime\":\""
  BODY+=`date +'%Y-%m-%d %H:%M:%S'`
  BODY+="\"}"
  echo $BODY
  curl -X POST -u ${SNUSER}:$SNPWD -H "Content-Type:application/json" "$URLNOTIF?toolId=$TOOLID&toolType=TeamCity" --data "$BODY"
}

function end_stage() {
  echo "Notification COMPLETED"
  export BODY="{\"toolId\":\"$TOOLID\",\"buildNumber\":\"$BUILDID\","
  BODY+="\"nativeId\":\"${PIPELINE_NAME}/${STAGE}#$CI_CONCURRENT_ID\",\"name\":\"${PIPELINE_NAME}/${STAGE}\","
  BODY+="\"id\":\"${PIPELINE_NAME}/${STAGE}#$CI_CONCURRENT_ID\",\"url\":\"$CI_JOB_URL/\","
  BODY+="\"isMultiBranch\":\"false\",\"orchestrationTaskUrl\":\"$ORCHESTRATION_TASK_URL#$STAGE\","
  BODY+="\"orchestrationTaskName\":\"${PIPELINE_NAME}#${STAGE}\","
  BODY+="\"upstreamTaskUrl\":\"$UPSTREAM_URL\",\"upstreamId\":\"$UPSTREAM_ID\","
  BODY+="\"result\":\"successful\",\"endDateTime\":\""
  BODY+=`date +'%Y-%m-%d %H:%M:%S'`
  BODY+="\"}"
  echo $BODY
  curl -X POST -u ${SNUSER}:$SNPWD -H "Content-Type:application/json" "$URLNOTIF?toolId=$TOOLID&toolType=TeamCity" --data "$BODY"
}
