ping -c 3 $BACKEND_SERVER > /dev/null

if [ $? -ne 0 ]; then

  echo "Unable to ping $BACKEND_SERVER. Please investigate network connectivity."

fi