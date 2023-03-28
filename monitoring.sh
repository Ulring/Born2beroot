#!bin/bash

# COLORS

# ARCH
arch=$(uname -a)

# CPU PHYSICAL
cpuf=$(grep "physical id" /proc/cpuinfo | wc -l)

# CPU VIRTUAL
cpuv=$(grep "processor" /proc/cpuinfo | wc -l)

# RAM
ram_total=$(free --mega | awk '$1 == "Mem:" {print $2}')
ram_use=$(free --mega | awk '$1 == "Mem:" {print $3}')
ram_percent=$(free --mega | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')

# DISK
disk_total=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_t += $2} END {printf ("%.1fGb\n"), disk_t/1024}')
disk_use=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_u += $3} END {print disk_u}')
disk_percent=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_u += $3} {disk_t+= $2} END {printf("%d"), disk_u/disk_t*100}')

# CPU LOAD
cpul=$(vmstat 1 2 | tail -1 | awk '{printf $15}')
cpu_op=$(expr 100 - $cpul)
cpu_fin=$(printf "%.1f" $cpu_op)

# LAST BOOT
lb=$(who -b | awk '$1 == "system" {print $3 " " $4}')

# LVM USE
lvmu=$(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then echo yes; else echo no; fi)

# TCP CONNEXIONS
tcpc=$(ss -ta | grep ESTAB | wc -l)

# USER LOG
ulog=$(users | wc -w)

# NETWORK
ip=$(hostname -I)
mac=$(ip link | grep "link/ether" | awk '{print $2}')

# SUDO
cmnd=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

printf "\e[31;5m%-5s\e[0m\e[32m%-10s\e[0m\n" "Architecture   :  " "$arch"
printf "\e[31;5m%-5s\e[0m\e[32m%-10s\e[0m\n" "CPU physical   :  " "$cpuf"
printf "\e[31;5m%-5s\e[0m\e[32m%-10s\e[0m\n" "vCPU           :  " "$cpuv"
printf "\e[31;5m%-5s\e[0m\e[32m%-10s\e[0m\n" "Memory Usage   :  " "$ram_use/$ram_total MB ($ram_percent%)"
printf "\e[31;5m%-5s\e[0m\e[32m%-10s\e[0m\n" "Disk Usage     :  " "$disk_use/$disk_total ($disk_percent%)"
printf "\e[31;5m%-5s\e[0m\e[32m%-10s\e[0m\n" "CPU load       :  " "$cpu_fin%"
printf "\e[31;5m%-5s\e[0m\e[32m%-10s\e[0m\n" "Last boot      :  " "$lb"
printf "\e[31;5m%-5s\e[0m\e[32m%-10s\e[0m\n" "LVM use        :  " "$lvmu"
printf "\e[31;5m%-5s\e[0m\e[32m%-10s\e[0m\n" "Connections TCP:  " "$tcpc ESTABLISHED"
printf "\e[31;5m%-5s\e[0m\e[32m%-10s\e[0m\n" "User log       :  " "$ulog"
printf "\e[31;5m%-5s\e[0m\e[32m%-10s\e[0m\n" "Network        :  " "IP $ip ($mac)"
printf "\e[31;5m%-5s\e[0m\e[32m%-10s\e[0m\n" "Sudo           :  " "$cmnd cmd"/
