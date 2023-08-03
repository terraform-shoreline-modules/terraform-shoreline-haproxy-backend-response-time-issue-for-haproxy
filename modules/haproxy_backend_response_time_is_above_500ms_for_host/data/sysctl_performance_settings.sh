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