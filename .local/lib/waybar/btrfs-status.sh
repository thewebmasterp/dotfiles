#/usr/bin/env bash
# btrfs-status.sh

# Define the base path
BASE_PATH="/sys/fs/btrfs/${BTRFS_ROOT_FS_UUID}/devinfo"

json_first_row=$(cat <<EOF
{
	"dev": "Dev",
	"write_e": "Write",
	"read_e": "Read",
	"flush_e": "Flush", 
	"corrupt_e": "Corrupt",
	"gen_e": "Gen"
}
EOF
)

json_data=""
# Loop through the devices and gather error stats
for devid in {1..4}; do
  # Read error stats for each device
  error_stats=$(cat "$BASE_PATH/$devid/error_stats")

  # Parse the error stats
  write_errs=$(echo "$error_stats" | grep "write_errs" | awk '{print $2}' | xargs printf "%-5s")
  read_errs=$(echo "$error_stats" | grep "read_errs" | awk '{print $2}' | xargs printf "%-4s")
  flush_errs=$(echo "$error_stats" | grep "flush_errs" | awk '{print $2}' | xargs printf "%-5s")
  corruption_errs=$(echo "$error_stats" | grep "corruption_errs" | awk '{print $2}' | xargs printf "%-7s")
  generation_errs=$(echo "$error_stats" | grep "generation_errs" | awk '{print $2}' | xargs printf "%-3s")
  
  # Construct JSON object for this device without the "device" field
  json_object=$(cat <<EOF
{
  "dev": "$devid  ",
  "write_e": "$write_errs",
  "read_e": "$read_errs",
  "flush_e": "$flush_errs",
  "corrupt_e": "$corruption_errs",
  "gen_e": "$generation_errs"
}
EOF
)

  # Append the object to the JSON array
  json_data="$json_data$json_object"
  
  # Add a comma if it's not the last device
  if [[ $devid -lt 4 ]]; then
    json_data="$json_data,"
  fi
done

has_errors=$(echo "[$json_data]" | jq 'map(
  to_entries | 
  any(select(.key | test("_e$")) and ( .value | gsub("\\s+$"; "") | tonumber ) > 0)
) | any')

text="btrfs 󱘩"
class="normal"

if [[ "$has_errors" == "true" ]]; then
  text="btrfs degraded "
  class="urgent"
fi

tooltip=$(jq -r '.[] | "\n<span>\(.dev) \(.write_e) \(.read_e) \(.flush_e) \(.corrupt_e) \(.gen_e)</span>"' <<< "[$json_first_row,$json_data]" | jq -Rs .)

echo "{\"text\":\"$text\", \"class\": \"$class\", \"tooltip\":$tooltip}"
