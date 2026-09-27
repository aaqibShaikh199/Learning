#!/bin/sh
# Send N requests with curl and print how traffic split across the two deployments.
# Run this inside the mesh, where traffic-demo.default.svc.cluster.local resolves.

set -eu

URL="traffic-demo.default.svc.cluster.local"

printf "How many requests do you want to send? "
read -r total

case "$total" in
  ''|*[!0-9]*)
    echo "Enter a positive whole number."
    exit 1
    ;;
esac

if [ "$total" -eq 0 ]; then
  echo "Enter a positive whole number."
  exit 1
fi

count80=0
count20=0
failed=0
i=1

echo "Sending ${total} requests to ${URL}"
echo

while [ "$i" -le "$total" ]; do
  if body=$(curl -sS --max-time 10 "$URL"); then
    case "$body" in
      *"receiving 80% of the traffic"*)
        count80=$((count80 + 1))
        echo "Request ${i}: traffic-80"
        ;;
      *"receiving 20% of the traffic"*)
        count20=$((count20 + 1))
        echo "Request ${i}: traffic-20"
        ;;
      *)
        failed=$((failed + 1))
        echo "Request ${i}: unrecognized response"
        ;;
    esac
  else
    failed=$((failed + 1))
    echo "Request ${i}: request failed"
  fi
  i=$((i + 1))
done

# Nearest whole percent of the total requests sent.
percent() {
  echo $(( ($1 * 1000 / total + 5) / 10 ))
}

echo
echo "Traffic distribution:"
echo "- Deployment traffic-80: $(percent "$count80")% (${count80}/${total})"
echo "- Deployment traffic-20: $(percent "$count20")% (${count20}/${total})"

if [ "$failed" -ne 0 ]; then
  echo "- Failed or unrecognized: $(percent "$failed")% (${failed}/${total})"
fi
