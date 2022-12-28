#!/bin/sh -l

if [ "$DEBUG" = "false" ]; then
	set -e
elif [ "$DEBUG" = "true" ]; then
	set -exuo xtrace
fi

if [ -z "$AWS_S3_BUCKET" ]; then
  echo "AWS_S3_BUCKET is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_ACCESS_KEY_ID" ]; then
  echo "AWS_ACCESS_KEY_ID is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo "AWS_SECRET_ACCESS_KEY is not set. Quitting."
  exit 1
fi

# Default to us-east-1 if AWS_REGION not set.
if [ -z "$AWS_REGION" ]; then
  AWS_REGION="us-east-1"
fi

# Override default AWS endpoint if user sets AWS_S3_ENDPOINT.
if [ -n "$AWS_S3_ENDPOINT" ]; then
  ENDPOINT_APPEND="--endpoint-url $AWS_S3_ENDPOINT"
fi

# Create a dedicated profile for this action to avoid conflicts with past/future actions.
aws configure --profile s3-sync-action <<-EOF > /dev/null 2>&1
${AWS_ACCESS_KEY_ID}
${AWS_SECRET_ACCESS_KEY}
${AWS_REGION}
text
EOF

# Sync using our dedicated profile and suppress verbose messages.
sh -c "aws s3 sync ${SOURCE_DIR} s3://${AWS_S3_BUCKET}/${DESTINATION_DIR} \
--profile s3-sync-action --no-progress ${ENDPOINT_APPEND} $*"

# Clear out credentials after we're done.
aws configure --profile s3-sync-action <<-EOF > /dev/null 2>&1
null
null
null
text
EOF
