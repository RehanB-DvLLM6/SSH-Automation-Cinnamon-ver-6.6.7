#CUSTOM BASH SCRIPT for killswitch
TARGET_PROCESSES=("firefox")

echo "Initiating process termination..."
for process in "${TARGET_PROCESSES[@]}"; do
    # Check if the process is running
    if pgrep -f "$process" > /dev/null; then
        echo "Found $process running. Terminating..."
        pkill -f "$process"
        echo "$process has been closed."
    else
        echo "$process is not currently running."
    fi
done

echo "Killswitch executed successfully."
