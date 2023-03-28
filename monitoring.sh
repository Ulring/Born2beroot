#!bin/bash

# COLORS
PURPLE='\e[0;35m'
ENDCOLOR='\e[0m'
CYAN='\e[1;96m'

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

wall "$(
echo -e "$PURPLE#Architecture   : $CYAN $arch$ENDCOLOR"
echo -e "$PURPLE#CPU physical   : $CYAN $cpuf$ENDCOLOR"
echo -e "$PURPLE#vCPU		: $CYAN $cpuv$ENDCOLOR"
echo -e "$PURPLE#Memory Usage   : $CYAN $ram_use/$ram_total MB ($ram_percent%)$ENDCOLOR"
echo -e "$PURPLE#Disk Usage     : $CYAN $disk_use/$disk_total ($disk_percent%)$ENDCOLOR"
echo -e "$PURPLE#CPU load       : $CYAN $cpu_fin$ENDCOLOR"
echo -e "$PURPLE#Last boot      : $CYAN $lb$ENDCOLOR"
echo -e "$PURPLE#LVM use        : $CYAN $lvmu$ENDCOLOR"
echo -e "$PURPLE#Connections TCP: $CYAN $tcpc ESTABLISHED$ENDCOLOR"
echo -e "$PURPLE#User log       : $CYAN $ulog$ENDCOLOR"
echo -e "$PURPLE#Network        : $CYAN IP $ip ($mac)$ENDCOLOR"
echo -e "$PURPLE#Sudo           : $CYAN $cmnd cmd$ENDCOLOR")"
