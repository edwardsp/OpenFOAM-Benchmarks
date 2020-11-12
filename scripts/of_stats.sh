#!/bin/sh

echo "LOGFILE ITERATIONS EXEC_START EXEC_END EXEC_DURATION CLOCK_START CLOCK_END CLOCK_DURATION TOTAL_ITER"
for fname in "$@"; do
	echo -n "$fname $(grep ExecutionTime $fname | wc -l)"
	for field in 3 8; do

		start_time=$(grep ExecutionTime $fname | head -n1 | cut -d' ' -f${field})
		end_time=$(grep ExecutionTime $fname | tail -n1 | cut -d' ' -f${field})
		duration=$(echo "$end_time - $start_time" | bc)
		echo -n " $start_time $end_time $duration"

	done

	echo " $(echo $(grep Iterations $fname | grep -o '[^ ]*$' | tr '\n' '+')0 | bc)"

done
