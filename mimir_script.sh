#!/bin/sh

# Assigning parameters to variables
event=$1
file=$2

LOG_LEVEL_SET="${LOG_LEVEL:-info}"
update_events="change add"
delete_events="unlink"

# Split the filename on the first underscore
filename_full=$(basename "$file")
filename="${filename_full%.*}"
namespace=$(echo "$filename" | cut -d '.' -f 1)
group=$(echo "$filename" | cut -d '.' -f 2-)

if [ "$LOG_LEVEL_SET" == "debug" ]; then
  # If everything is ok, echo the parameters
  echo "DEBUG MODE"
  echo "Event: $event"
  echo "File: $file"
  echo "Namespace: $namespace"
  echo "Group: $group"
fi


# Check if parameters are provided
if [ -z "$event" ] || [ -z "$file" ]; then
    echo "Error: Both 'event' and 'file' parameters must be provided."
    exit 1
fi

if [[ "$update_events[*]" =~ $event ]]; then
  # Check if file exists
  if [ ! -f "$file" ]; then
      echo "Error: File '$file' does not exist."
      exit 1
  fi
  echo "Add rules for Namespace: $namespace , Group: $group"
  /app/mimirtool rules load $file --address=$ENV_ENDPOINT --id=anonymous
else
  echo "Delete rules for Namespace: $namespace , Group: $group"
  /app/mimirtool rules delete --address=$ENV_ENDPOINT --id=anonymous $namespace $group
fi
