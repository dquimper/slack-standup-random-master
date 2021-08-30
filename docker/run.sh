#!/usr/bin/env bash

if [ "$1" = "-s" ]
then
  docker run -it --mount source=runtime,target=/tmp/standup_rollout --env-file .env adgear/standup_rollout:v1 bash
else
  docker run --mount source=runtime,target=/tmp/standup_rollout --env-file .env adgear/standup_rollout:v1
fi
