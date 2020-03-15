#!/bin/bash -eu
#
# Put the output of "jstat -gcutil" to CloudWatch.
# CloudWatch's namespace is "Middleware".
# CloudWatch's dimmentions is "AutoscalingGroup" and "InstanceId".
#
# Arguments:
#   - $1: target java proccess name.  ex) Bootstrap
#   - $2: target java proccess owner. ex) tomcat
# Returns:
#   None

# ------------------------------------------------------------------------------
# function
# ------------------------------------------------------------------------------
#######################################
# Get jstat -gcutil output.
# Arguments:
#   - $1: target java proccess name.
#   - $2: target java proccess owner.
# Returns:
#   None
#######################################
function get_jstat(){
  local TARGET_PID=$(sudo -u $2 jps | grep $1 | awk '{print $1}')
  echo $(sudo -u $2 jstat -gcutil ${TARGET_PID} | tail -1)
}

#######################################
# Put jstat infomation to Cloudwatch.
# Grobals:
#   - jstat_json
# Arguments:
#   - $1: Region
#   - $2: NameSpace
#   - $3: DimensionName
#   - $4: DimensionValue
# Returns:
#   None
#######################################
function put_jstat_metrics(){
  local dimension_name=$3
  local dimension_value=$4

  local jstat_json=$(cat << EOS
  [
    {
      "MetricName": "S0",
      "Value": ${S0},
      "Dimensions": [{"Name": "${dimension_name}", "Value": "${dimension_value}"}]
    },
    {
      "MetricName": "S1",
      "Value": ${S1},
      "Dimensions": [{"Name": "${dimension_name}", "Value": "${dimension_value}"}]
    },
    {
      "MetricName": "E",
      "Value": ${E},
      "Dimensions": [{"Name": "${dimension_name}", "Value": "${dimension_value}"}]
    },
    {
      "MetricName": "O",
      "Value": ${O},
      "Dimensions": [{"Name": "${dimension_name}", "Value": "${dimension_value}"}]
    },
    {
      "MetricName": "M",
      "Value": ${M},
      "Dimensions": [{"Name": "${dimension_name}", "Value": "${dimension_value}"}]
    },
    {
      "MetricName": "CCS",
      "Value": ${CCS},
      "Dimensions": [{"Name": "${dimension_name}", "Value": "${dimension_value}"}]
    },
    {
      "MetricName": "YGC",
      "Value": ${YGC},
      "Dimensions": [{"Name": "${dimension_name}", "Value": "${dimension_value}"}]
    },
    {
      "MetricName": "YGCT",
      "Value": ${YGCT},
      "Dimensions": [{"Name": "${dimension_name}", "Value": "${dimension_value}"}]
    },
    {
      "MetricName": "FGC",
      "Value": ${FGC},
      "Dimensions": [{"Name": "${dimension_name}", "Value": "${dimension_value}"}]
    },
    {
      "MetricName": "FGCT",
      "Value": ${FGCT},
      "Dimensions": [{"Name": "${dimension_name}", "Value": "${dimension_value}"}]
    },
    {
      "MetricName": "GCT",
      "Value": ${GCT},
      "Dimensions": [{"Name": "${dimension_name}", "Value": "${dimension_value}"}]
    }
  ]
EOS
  )

  aws cloudwatch put-metric-data \
    --region $1 \
    --namespace=$2 \
    --metric-data "$(echo ${jstat_json})"
}

# ------------------------------------------------------------------------------
# main
# ------------------------------------------------------------------------------
# setting AWS variables.
readonly AWS_METADATA_URL='http://169.254.169.254/latest/meta-data'
readonly INSTANCE_ID=$(curl -s ${AWS_METADATA_URL}/instance-id/)
readonly REGION=$(curl -s ${AWS_METADATA_URL}/placement/availability-zone/ | sed -e 's/.$//')
readonly HOST_NAME=$(hostname)

# setting cloudwatch namesape.
readonly NAME_SPACE='Middleware'

# get jstat infomation.
readonly TARGET_PROC=$1
readonly USER=$2
readonly JSTAT_OUTPUT=$(get_jstat ${TARGET_PROC} ${USER})

# setting jstat variables.
read S0 S1 E O M CCS YGC YGCT FGC FGCT GCT \
	<<< $(echo ${JSTAT_OUTPUT} | awk '{for (i = 1; i <= NF; i++) print $i;}')

# put metrics to cloudwatch.
put_jstat_metrics ${REGION} ${NAME_SPACE} "HostName" "${HOST_NAME}"
put_jstat_metrics ${REGION} ${NAME_SPACE} "InstanceID" "${INSTANCE_ID}"
