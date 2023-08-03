MEMORY_USAGE=$(ssh $BACKEND_SERVER "free | awk '/Mem/{print $3/$2 * 100.0}'")

if [[ $(echo "$MEMORY_USAGE > 80" | bc -l) -eq 1 ]]; then

  echo "High memory usage detected on $BACKEND_SERVER. Please investigate."

fi