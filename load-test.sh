#!/bin/bash

URL="http://localhost"
REQUESTS=1000
CONCURRENCY=20

echo "Starting load test..."
echo "Target: $URL"
echo "Requests: $REQUESTS"
echo "Concurrency: $CONCURRENCY"
echo ""

run_test () {
  for i in $(seq 1 $REQUESTS); do
    curl -s $URL > /dev/null &
    
    if (( $(jobs -r | wc -l) >= CONCURRENCY )); then
      wait -n
    fi
  done
  wait
}

start=$(date +%s)

run_test

end=$(date +%s)

echo ""
echo "Load test finished"
echo "Total time: $((end-start)) seconds"
