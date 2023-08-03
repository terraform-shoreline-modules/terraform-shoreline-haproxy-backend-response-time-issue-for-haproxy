
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# HAProxy Backend response time is above 500ms for host.
---

This incident type occurs when the response time of the backend for a specific host in the HAProxy load balancing software exceeds 500 milliseconds. This can be an indication of a performance issue or bottleneck in the system that requires investigation and resolution to prevent further impact.

### Parameters
```shell
# Environment Variables

export HAPROXY_SERVER="PLACEHOLDER"

export HOST="PLACEHOLDER"

export BACKEND_SERVER_IP_ADDRESS="PLACEHOLDER"

export VALUE="PLACEHOLDER"
```

## Debug

### Check HAProxy status
```shell
systemctl status haproxy
```

### SSH into the server where HAProxy is running
```shell
ssh ${HAPROXY_SERVER}
```

### Check HAProxy logs for errors
```shell
tail -f /var/log/haproxy.log
```

### Check backend response time for a specific host
```shell
echo "show stat" | sudo socat /var/run/haproxy.sock stdio | grep ${HOST} | cut -d ',' -f 35
```

### Check backend response time for all hosts
```shell
echo "show stat" | sudo socat /var/run/haproxy.sock stdio | grep -E '^backend' | cut -d ',' -f 1,35
```
### Check CPU usage
```shell
CPU_USAGE=$(ssh $BACKEND_SERVER "top -b -n1 | grep 'Cpu(s)' | awk '{print $2+$4}'")

if [[ $(echo "$CPU_USAGE > 80" | bc -l) -eq 1 ]]; then

  echo "High CPU usage detected on $BACKEND_SERVER. Please investigate."

fi
```

### Check memory usage
```shell
MEMORY_USAGE=$(ssh $BACKEND_SERVER "free | awk '/Mem/{print $3/$2 * 100.0}'")

if [[ $(echo "$MEMORY_USAGE > 80" | bc -l) -eq 1 ]]; then

  echo "High memory usage detected on $BACKEND_SERVER. Please investigate."

fi
```

### Check network connectivity
```shell
ping -c 3 $BACKEND_SERVER > /dev/null

if [ $? -ne 0 ]; then

  echo "Unable to ping $BACKEND_SERVER. Please investigate network connectivity."

fi
```

## Repair

### Tune the server's operating system parameters to improve performance 
```shell
bash

#!/bin/bash



# Set the sysctl parameters for network performance

sudo sysctl -w net.core.somaxconn=${VALUE}

sudo sysctl -w net.ipv4.tcp_max_syn_backlog=${VALUE}

sudo sysctl -w net.ipv4.tcp_fin_timeout=${VALUE}



# Set the sysctl parameters for kernel performance

sudo sysctl -w kernel.pid_max=${VALUE}

sudo sysctl -w kernel.threads-max=${VALUE}

sudo sysctl -w kernel.sem=${VALUE}



# Set the sysctl parameters for file system performance

sudo sysctl -w fs.file-max=${VALUE}

sudo sysctl -w fs.nr_open=${VALUE}

sudo sysctl -w vm.max_map_count=${VALUE}



# Restart HAProxy to apply the changes

sudo systemctl restart haproxy.service


```