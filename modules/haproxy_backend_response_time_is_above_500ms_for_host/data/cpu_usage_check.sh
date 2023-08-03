CPU_USAGE=$(ssh $BACKEND_SERVER "top -b -n1 | grep 'Cpu(s)' | awk '{print $2+$4}'")

if [[ $(echo "$CPU_USAGE > 80" | bc -l) -eq 1 ]]; then

  echo "High CPU usage detected on $BACKEND_SERVER. Please investigate."

fi