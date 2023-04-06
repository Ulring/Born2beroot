# Born2beroot:

## How does a virtual machine work?
At a low level, a virtual machine (VM) is a software abstraction of a physical machine. It is created by a hypervisor, which is a layer of software that runs directly on the physical hardware and manages the virtualization of the resources.

The hypervisor creates one or more virtual machines, each of which has its own virtual CPU, memory, storage, and network interfaces.

The virtual CPU is emulated by the hypervisor, which intercepts and translates the instructions from the guest operating system to the underlying physical hardware. This allows multiple operating systems to run on the same physical machine, each in its own isolated virtual machine.

The virtual memory is also managed by the hypervisor, which maps the guest operating system's memory addresses to the physical memory addresses. This ensures that each virtual machine has its own isolated memory space and prevents one virtual machine from accessing another virtual machine's memory.

The virtual storage is provided by a virtual disk, which is stored as a file on the physical disk. The hypervisor manages the virtual disk and presents it to the guest operating system as if it were a physical disk. The virtual disk can be resized or even created on the fly, providing a flexible and scalable storage solution for virtual machines.

The virtual network interfaces are provided by the hypervisor, which manages the communication between the virtual machine and the physical network. The hypervisor provides a virtual switch that connects the virtual machines to the physical network, allowing them to communicate with each other and with other devices on the network.

Overall, a virtual machine is a software abstraction of a physical machine, created and managed by a hypervisor. The hypervisor provides a layer of abstraction between the guest operating system and the physical hardware, allowing multiple operating systems to run on the same physical machine in isolated virtual machines. The hypervisor manages the virtualization of the CPU, memory, storage, and network resources, providing a flexible and scalable solution for running multiple operating systems on a single physical machine.

## How is it different from Qemu?
Both virtual machines and QEMU (Quick Emulator) are virtualization technologies that allow multiple operating systems to run on the same physical machine. However, there are some key differences between the two.

Virtual machines use a hypervisor to create and manage virtual machines, as I explained in my previous answer. The hypervisor provides a layer of abstraction between the guest operating system and the physical hardware, allowing multiple operating systems to run on the same physical machine in isolated virtual machines.

QEMU, on the other hand, is an emulator that can emulate a complete computer system, including the CPU, memory, storage, and network interfaces. QEMU can run operating systems that are not designed to run on the physical hardware of the host machine. This is useful for running legacy operating systems or testing new operating systems.

QEMU can also be used as a virtualization tool, similar to a hypervisor, by providing a virtual machine environment for guest operating systems. However, QEMU uses a different approach than traditional hypervisors. Instead of creating a layer of abstraction between the guest operating system and the physical hardware, QEMU emulates the hardware of the virtual machine, including the CPU and memory. This can be slower than traditional virtualization because each instruction from the guest operating system must be translated and emulated by QEMU.

Another key difference between virtual machines and QEMU is that virtual machines require a compatible hypervisor to be installed on the host machine, while QEMU can be used on its own without a hypervisor. However, QEMU can also be used with a hypervisor, such as KVM (Kernel-based Virtual Machine), to provide better performance and security.

Overall, virtual machines and QEMU are both virtualization technologies that allow multiple operating systems to run on the same physical machine. However, virtual machines use a hypervisor to create and manage virtual machines, while QEMU is an emulator that can emulate a complete computer system.

## Why did I choose Debian?
Package Management: Debian uses the Advanced Package Tool (APT) to manage software packages, while CentOS uses the Yellowdog Updater Modified (YUM) package manager. Some users prefer the APT system because it is designed to handle dependencies and upgrades more efficiently.

Community Support: Debian has a large and active community of developers and users who provide support and contribute to the development of the operating system. This can be helpful for users who need assistance with troubleshooting or customizing their VM.

To be honest, I chose it because the subject was not up to date.

## The basic differences between CentOS and Debian?

Debian and CentOS are both popular operating systems based on Linux, but they have several key differences.

- **Origin and development:** Debian is developed by a non-profit organization and is based on the principles of free software and open-source development. In contrast, CentOS is a community-driven project that is derived from the commercial Red Hat Enterprise Linux (RHEL) operating system.

- **Package Management:** Debian uses the Advanced Package Tool (APT) as its default package manager, while CentOS uses Yellowdog Updater Modified (YUM) or its successor DNF (Dandified YUM). Both APT and YUM/DNF are powerful package managers that allow easy installation, removal, and upgrading of software packages.

- **Release cycle and stability:** Debian is known for its stability and long release cycles, with major releases occurring every two to three years. On the other hand, CentOS releases are typically more frequent, and major updates may introduce new features and changes.

- **Support:** Debian has a large community of volunteers who provide support through online forums, wikis, and documentation. CentOS, on the other hand, has a strong corporate backing from Red Hat, which provides paid support options.

- **Default Desktop Environment:** Debian offers a wide variety of desktop environments to choose from, whereas CentOS is primarily designed for server use and does not come with a default desktop environment.

## What is the purpose of Virtual machines?
The main benefits of VMs are:

- **Isolation:** VMs allow multiple operating systems to run independently from each other, isolating each OS and its applications from the others.

- **Consolidation:** By running multiple VMs on a single physical machine, you can consolidate your hardware resources and improve hardware utilization, reducing the cost of purchasing and maintaining multiple physical machines.

- **Testing and Development:** VMs are commonly used in software testing and development environments, where multiple configurations and operating systems are required for testing software compatibility and functionality.

- **Disaster Recovery:** VMs can be used to create backups of entire systems, which can be restored quickly in case of hardware or software failures.

- **Security:** VMs can be used to run potentially insecure applications in a sandboxed environment, preventing them from compromising the host operating system or other applications.

## What's the difference between apt, aptitude, apt-get?

The .deb packaging format is the basic unit here, analogous to .rpm files. Packages come in two types, source and binary, but for simplicity I'm not going to touch on source packages. Binary packages are ar archives that contain 2 sub archives, control.tar.gz and data.tar.XX (usually xz nowadays), as well as a debian-binary file containing the package version. control.tar.gz contains, as it says, control files: conffiles lists configuration files, control lists the package information for dpkg to use, including dependencies and recommends, md5sums a list of file MD5 sums to verify files, and the postinst/postrm/preinst/prerm scripts that are executed when they sound like, which do things like create users, set up file ownership, start daemons, etc., and the inverse on removal. data.tar.XX contains a relative virtual filesystem starting from /, and containing the literal files that the package installs on the system, including the binaries, docs, config files/templates, and anything else. This is a big reason why you shouldn't be mucking about in places like /usr/bin or /lib, because dpkg ultimately manages all of these files for you.

With the package format out of the way, we get to the lowest level user-accessible tool, dpkg. It works mostly like the rpm command in a practical sense, in that it takes a single .deb archive and installs it. dpkg keeps track of the installed packages in its database under /var/lib/dpkg, which also includes all the control.tar.gz files mentioned above (under info/), as well as a massive concatenation of all the control text files (in available). This directory is really the heart of dpkg's knowledge of your system: any package you install is listed in here, along with all its control files, and this is the database that the dpkg too uses to know what you have installed. Managing the installed packages on your system is all it does: you give it that single .deb file, and, assuming all dependencies are satisfied, it will unarchive the control.tar.gz archive, add the control file to its database, execute the preinst script, extract the data.tar.XX file against /, then execute the postinst script. Voila, your package is installed. Removal happens in the reverse order but with a lot of rm, since the control files list what files are present in each package, and config files listed in conffiles are left alone by default (that's what purge does with apt-get/apt). dpkg only ever knows about packages that are actually installed, and you can for instance list installed packages with it (dpkg -l), or query the installed database in other more advanced ways. But for the most part, unless you're downloading an omnibus .deb, you never need to worry about dpkg.

So dpkg is really low-level, so someone wrote the first layer of abstraction: apt-get, and its cousin apt-cache. apt-get's job is to scan repository mirrors, sort out dependency trees (by looking in the control files), download files, and install them in a correct and sensible order with dpkg. Another poster derisively called it a "wrapper", which isn't really true: dpkg has no knowledge of repositories, downloading, or anything else; this is all apt-get's domain. Running its commands like update, install, and remove all trigger calls to dpkg eventually to actually do the grunt work of setting up the packages, but the command does a lot of its own stuff to handle dependencies, downloading over various protocols, and caching remote archive information for local use.

apt-cache is a cousin command that is used for querying information about the repositories via the locally cached copies fetched with apt-get update. This includes searching for packages, displaying information, etc. about packages that aren't yet installed. For most novices this was always a relatively rare command outside of searching but was useful for querying potential changes and showing package information.

apt-file is another optional part of the toolstack which is really useful for searching packages for individual files, for instance "what package has /usr/bin/foobar". I highly recommend it if you ever ask that question!

Finally in the "original APT toolstack", apt-key manages repository signing keys, which ensure cryptographic verification of any files you download via APT to protect against corruption and spoofing. In theory and (AFAIK) practice, they make sure you're downloading trusted packages from the people who gave you the keys (the Debian project master keys for the official repos, or a repo owner for a third-party APT repo).

Now it's worth stressing that these 3 tools are OLD. All of them have existed for 20 or more years (APT from 1998, dpkg from 1994), and that age should tell you a lot about the era they were designed in. Though they've all grown over the years, fundamentally they're the same as they always have been, and can show their age in a lot of ways (like having multiple commands to interface with the APT system...). And I'd be remiss if I didn't mention the precursor to them, dselect, which was the original "package manager" written alongside dpkg back in 1994.

apt is a newer, more functional, rewrite of the apt-get/apt-cache toolstack which aims to provide a single unified, modern, and "pretty" CLI command for interfacing with APT. It can do (as of at least Debian 9, as far as I can tell) everything those other commands do for 99.9% of administrative tasks. Personally I've jumped right in the front of this bandwagon, since I find the output far nicer and more unified. But fundamentally apt is the replacement for the other two going forward; just don't expect them to be deprecated any time soon.

Finally aptitude is an ncurses GUI tool (with CLI commands) that works as an alternative to apt-get, originally released in 1999 as an alternative to apt-get and friends. It has a slightly different dependency parsing system, including a very lovely multiple-choice dependency resolution option which is useful sometimes. But from a basic level it does the same thing as apt-get/apt-cache and apt, just in a GUI format. Similarly, synaptic is the official desktop environment GUI tool to fit a similar niche.

## What is AppArmor?

AppArmor is a security system that provides Mandatory Access Control (MAC) by limiting the resources that programs can access. AppArmor works by binding access control attributes to individual programs rather than to users. This means that AppArmor can be used to confine specific programs to a limited set of resources, even if the user has more general access to the system.

AppArmor is implemented as a kernel enhancement, using the Linux Security Modules (LSM) framework. When a system starts up, AppArmor loads profiles into the kernel that define the resources that each program can access. These profiles can be created manually, or generated automatically using tools like AppArmor's own profile generation tool or the aa-genprof utility.

AppArmor profiles can be in one of two modes: enforcement and complain. When a profile is in enforcement mode, AppArmor enforces the policy defined in the profile and will report any policy violation attempts via syslog or auditd. When a profile is in complain mode, AppArmor will not enforce policy, but instead will report policy violation attempts. This can be useful for testing and debugging profiles before deploying them in enforcement mode.

Overall, AppArmor provides an additional layer of security to a system by limiting the resources that individual programs can access. By binding access control attributes to programs rather than users, AppArmor can help prevent security breaches and limit the damage that can be caused by a compromised program.

## Ensure that the machine does not have a graphical environment at launch:

```console
ansoulim@ansoulim42:~$ ls /usr/bin/*session
```
Should return:
<span style="color:green">/usr/bin/dbus-run-session</span>

This command alone doesn't necessarily mean that you don't have a graphical environment. However, it suggests that you might not have a display manager installed on your system, or you might not have a default display manager set up.

A display manager is a program that manages graphical user sessions on Linux systems. It presents a login screen and starts the user's desktop environment after successful authentication. Some popular display managers include GDM (Gnome Display Manager), LightDM, and SDDM.

If you don't have a display manager installed on your system or it's not running, you won't be able to start a graphical user session, and you'll be limited to using the command-line interface.

## Check that the UFW service is started:
```console
ansoulim@ansoulim42:~$ sudo ufw status
ansoulim@ansoulim42:~$ sudo service ufw status
```

## Check that the SSH service is started:
```console
ansoulim@ansoulim42:~$ sudo service ssh status
```

## Check that the OS is Debian:
```console
ansoulim@ansoulim42:~$ uname -v
```
Or
```console
ansoulim@ansoulim42:~$ cat /etc/os-release
```
Or
```console
ansoulim@ansoulim42:~$ neofetch
```

## Check that the user belongs to "sudo" and "user42" groups:
```console
ansoulim@ansoulim42:~$ getent group sudo
ansoulim@ansoulim42:~$ getent group user42
```

## Create a new user:
```console
ansoulim@ansoulim42:~$ sudo adduser test
```

## Explain how the password was setup:
```console
ansoulim@ansoulim42:~$ vim /etc/login.defs
```
PASS_MAX_DAYS 99999 &rarr; PASS_MAX_DAYS 30

PASS_MIN_DAYS 0 &rarr; PASS_MIN_DAYS 2

<span style="color:red"> Note:</span>

PASS_MAX_DAYS: The max days until the password is expired.

PASS_MIN_DAYS: The min days until the password is expired.

PASS_WARN_AGE: How many days until a warning about the password is issued.

```console
ansoulim@ansoulim42:~$ vim /etc/pam.d/common-password
```
**minlen=10:** This parameter sets the minimum length of the password to 10 characters. This means that any password that is less than 10 characters long will be rejected.

**ucredit=-1:** This parameter requires the password to contain at least one uppercase letter. The value -1 means that this is a mandatory requirement. If the value was 1, it would mean that the password should contain at least one uppercase letter, but it's not mandatory.

**dcredit=-1:** This parameter requires the password to contain at least one digit. The value -1 means that this is a mandatory requirement.

**lcredit=-1:** This parameter requires the password to contain at least one lowercase letter. The value -1 means that this is a mandatory requirement.

**maxrepeat=3:** This parameter sets a limit on the number of times a character can be repeated in the password. In this case, the value is 3, which means that any character that appears more than 3 times in the password will be rejected.

**reject_username:** This parameter ensures that the password does not contain the user's username. This is important because passwords that contain the username are easier to guess.

**difok=7:** This parameter requires the password to contain at least 7 different characters from the previous password used. This helps to ensure that users are not reusing the same passwords over and over again.

**enforce_for_root:** This parameter enforces this password policy for the root user. This is important because the root user has full access to the system, and a weak password for the root user could compromise the entire system.

## Create a new group and assign it to this new user:
```console
ansoulim@ansoulim42:~$ sudo groupadd evaluating
ansoulim@ansoulim42:~$ sudo usermod -aG evaluating test
```

## Check if the user belongs to the "evaluating" group:
```console
ansoulim@ansoulim42:~$ getent group evaluating
```

## Explain the advantages of the password policy and disadvantages of its implementation:
Advantages of the password policy:

- **Increased security:** The password policy helps to ensure that passwords are more secure, making it harder for attackers to gain access to systems or sensitive data.
- **Standardization:** The policy provides a standard set of rules for password creation and maintenance, which can help to prevent confusion and inconsistencies.
- **User awareness:** By requiring users to adhere to a specific password policy, it helps to increase their awareness of the importance of password security and encourages them to adopt best practices.

Advantages of the implementation:

- **Customization:** The implementation allows for the customization of the password policy to meet the specific needs of the organization.
- **Automation:** The implementation can be automated, which reduces the workload of IT administrators and makes it easier to manage password policies at scale.
- **Enforced compliance:** The implementation enforces compliance with the password policy, which helps to ensure that all users are following the same security standards.

Disadvantages of the implementation:

- **Complexity:** Implementing and managing a password policy can be complex, especially for larger organizations with many users and systems.
- **User resistance:** Users may find the password policy too restrictive or difficult to follow, leading to resistance and noncompliance.
- **False sense of security:** While the password policy can increase security, it is not a foolproof solution and may create a false sense of security if other security measures are not in place.

## Check that the hostname is "login42":
```console
ansoulim@ansoulim42:~$ hostnamectl
```

## Replace the hostname with the evaluator's login:
```console
ansoulim@ansoulim42:~$ sudo vim /etc/hostname
ansoulim@ansoulim42:~$ sudo vim /etc/hosts
ansoulim@ansoulim42:~$ sudo reboot
```

## Restore to the original hostname:
```console
ansoulim@ansoulim42:~$ sudo vim /etc/hostname
ansoulim@ansoulim42:~$ sudo vim /etc/hosts
ansoulim@ansoulim42:~$ sudo reboot
```

## Check the partitions of this virtual machine:
```console
ansoulim@ansoulim42:~$ lsblk
```

## Explain how LVM works:
LVM stands for Logical Volume Manager, and it is a software layer that allows the management of physical storage devices as logical volumes. The main purpose of LVM is to provide flexible and dynamic management of storage devices by abstracting the physical storage from the logical storage.

LVM works by creating layers of abstraction between physical storage devices and the file systems that use them. These layers consist of physical volumes (PVs), volume groups (VGs), logical volumes (LVs), and file systems.

Physical Volume (PV): A physical volume is a disk partition or an entire disk that has been assigned to LVM. LVM combines multiple physical volumes into a volume group.

Volume Group (VG): A volume group is a collection of physical volumes that are combined into a single storage pool. Volume groups can be resized by adding or removing physical volumes, and they can be divided into logical volumes.

Logical Volume (LV): A logical volume is a virtual disk that is created by combining free space from a volume group. A logical volume can be resized while it is online and in use by a file system.

File System: A file system is created on top of a logical volume, and it is used to store and manage data on the logical volume.

By using LVM, administrators can add, remove, or resize storage volumes without the need to take the system offline. This flexibility is particularly useful in situations where storage requirements change over time.

Another advantage of LVM is that it allows for improved storage utilization. LVM can allocate storage space on-demand, which means that physical storage devices can be used more efficiently.

On the other hand, the disadvantages of LVM are that it adds an additional layer of complexity to storage management, and it may add some performance overhead. Additionally, if LVM metadata becomes corrupted, it can be difficult to recover data.

## Check that sudo is installed:
```console
ansoulim@ansoulim42:~$ dpkg -s sudo | grep sudo
```

## Assign the new user to the "sudo" group:
```console
ansoulim@ansoulim42:~$ sudo usermod -aG sudo test
```

## Check if the user belongs to the "sudo" group:
```console
ansoulim@ansoulim42:~$ getent group sudo
```

## Explain the value and operation of sudo using examples:
sudo stands for "superuser do" and is a command in Unix/Linux systems that allows a user to execute commands with the privileges of another user, usually the superuser or root user. The purpose of sudo is to provide a way for authorized users to perform administrative tasks without giving them permanent root access.

Here is an example of how sudo works:

Suppose a user wants to install a package on their Linux system, which requires administrative privileges. Without sudo, the user would have to switch to the root user account by logging in as the root user or using the su command. However, this is not recommended as it poses a security risk.

Instead, the user can use sudo to execute the installation command with root privileges. For example:
```console
ansoulim@ansoulim42:~$ sudo apt-get install package_name
```

## Show the implementation of the rules imposed by the subject:
```console
ansoulim@ansoulim42:~$ vim /etc/sudoers.d/sudo_config
```
- **Defaults passwd_tries=3:** This line sets the default value for the number of times a user can enter a wrong password before getting locked out. In this case, it's set to 3.

- **Defaults badpass_message="Bad password.Try again":** This line sets a custom error message that will be displayed to the user if they enter an incorrect password.

- **Defaults logfile="/var/log/sudo/sudo_config":** This line specifies the location and name of the log file where sudo will record its activities.

- **Defaults log_input, log_output:** This line tells sudo to log both the commands being executed (log_input) and the output of those commands (log_output).

- **Defaults iolog_dir="/var/log/sudo":** This line sets the directory where sudo will store I/O logs for each executed command.

- **Defaults requiretty:** This line requires that users run sudo commands from a terminal, rather than from a script or other automated process.

- **Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin":** This line sets the path for the sudo command. By default, sudo restricts the command path to a secure set of directories to prevent users from accidentally or intentionally running malicious commands.

## Check that the sudo log works:
```console
ansoulim@ansoulim42:~$ su -
ansoulim@ansoulim42:~$ cat /var/log/sudo/sudo_log
ansoulim@ansoulim42:~$ sudo ls
ansoulim@ansoulim42:~$ cat /var/log/sudo/sudo_log
```

## Check that UFW is installed and is working:
```console
ansoulim@ansoulim42:~$ dpkg -s ufw | grep ufw
ansoulim@ansoulim42:~$ sudo ufw status
ansoulim@ansoulim42:~$ sudo service ufw status
```

## Explain what UFW is and the value of using it:
**UFW (Uncomplicated Firewall)** is a command-line tool that provides an easy-to-use interface for managing netfilter (iptables) firewall rules on Linux systems. It allows users to create, modify, and delete firewall rules and provides a simple syntax that abstracts the complexity of netfilter rules.

Using UFW provides several values for system administrators and users, including:

- **Security:** UFW allows users to easily configure firewall rules to limit network traffic, reducing the risk of unauthorized access to the system and protecting against potential attacks.

- **Simplicity:** UFW provides an easy-to-use interface for managing firewall rules, allowing users to quickly create and modify rules without requiring a deep understanding of netfilter syntax.

- **Automation:** UFW rules can be easily integrated into automated deployment scripts, allowing administrators to easily configure firewalls for large-scale deployments.

- **Monitoring:** UFW provides logging functionality that allows users to monitor network traffic and detect potential security threats.

## List all active rules in UFW:
```console
ansoulim@ansoulim42:~$ sudo ufw status numbered
```

## Add a new rule to open 8080 and check that is has been added:
```console
ansoulim@ansoulim42:~$ sudo ufw allow 8080
ansoulim@ansoulim42:~$ sudo ufw status numbered
```

## Delete this new rule:
```console
ansoulim@ansoulim42:~$ sudo ufw delete 4
ansoulim@ansoulim42:~$ sudo ufw delete 2
ansoulim@ansoulim42:~$ sudo ufw status numbered
```

## Check that SSH is installed and is working:
```console
ansoulim@ansoulim42:~$ dpkg -s ssh | grep ssh
ansoulim@ansoulim42:~$ sudo ssh status
ansoulim@ansoulim42:~$ sudo service ssh status
```

## Explain what SSH is and the value of using it:
**SSH (Secure Shell)** is a cryptographic network protocol used to securely connect to and manage remote servers and devices over an unsecured network. It provides a secure channel over an unsecured network by encrypting all data transmitted between the two endpoints, thereby preventing unauthorized access, eavesdropping, and tampering.

The value of using SSH is that it provides a secure way to remotely access and manage servers, devices, and data without the risk of exposing sensitive information or compromising the security of the network. It is commonly used by system administrators, developers, and other IT professionals to remotely access and manage servers, run commands, transfer files, and troubleshoot issues.

Some of the benefits of using SSH include:

- **Security:** SSH provides a high level of security through encryption of data, and it also supports authentication and access control mechanisms.

- **Remote access:** SSH enables users to remotely access and manage servers, devices, and data, without requiring physical access to the server or device.

- **Flexibility:** SSH can be used for a wide range of purposes, including remote shell access, file transfer, and tunneling, making it a versatile tool for IT professionals.

- **Efficiency:** SSH provides a fast and efficient way to manage remote servers and devices, reducing the need for physical travel or on-site visits.

## Verify that SSH only uses the port 4242:
```console
ansoulim@ansoulim42:~$ ssh test@localhost -p 8989
ansoulim@ansoulim42:~$ ssh test@localhost -p 4242
```

## Explain the script:
This is a Bash script that collects various system information and displays it on the command line. Here is a line-by-line explanation of the script:
```console
#!/bin/bash
```
This is known as the shebang line. It specifies the shell that should be used to interpret the script. In this case, it specifies that the script should be run with the Bash shell.
```console
# COLORS
PURPLE='\e[0;35m'
ENDCOLOR='\e[0m'
CYAN='\e[1;96m'
```
These lines define variables that are used to colorize the output text of the script. Specifically, they define the following three variables:

PURPLE: a variable that contains the escape sequence \e[0;35m, which sets the terminal color to purple.
ENDCOLOR: a variable that contains the escape sequence \e[0m, which resets the terminal color to its default value.
CYAN: a variable that contains the escape sequence \e[1;96m, which sets the terminal color to cyan.

```console
# ARCH
arch=$(uname -a)
```
This line runs the "uname -a" command, which prints information about the system's architecture, kernel version, and other details. The output is saved to the "arch" variable.

```console
# CPU PHYSICAL
cpuf=$(grep "physical id" /proc/cpuinfo | wc -l)
```
This line runs the "grep" command to search the "/proc/cpuinfo" file for lines containing the string "physical id", which indicates the number of physical CPUs. The "wc -l" command counts the number of lines containing this string, and the result is saved to the "cpuf" variable.
```console
# CPU VIRTUAL
cpuv=$(grep "processor" /proc/cpuinfo | wc -l)
```
This line is similar to the previous one, but it counts the number of logical CPUs (also known as virtual CPUs) instead of physical CPUs.
```console
# RAM
ram_total=$(free --mega | awk '$1 == "Mem:" {print $2}')
ram_use=$(free --mega | awk '$1 == "Mem:" {print $3}')
ram_percent=$(free --mega | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')
```
These lines use the "free" command to display information about the system's memory usage. The "--mega" option specifies that the output should be in megabytes. The "awk" command is used to extract the relevant information from the output. The "ram_total" variable stores the total amount of memory, "ram_use" stores the amount of memory currently in use, and "ram_percent" calculates the percentage of memory currently in use.
```console
# DISK
disk_total=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_t += $2} END {printf ("%.1fGb\n"), disk_t/1024}')
disk_use=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_u += $3} END {print disk_u}')
disk_percent=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_u += $3} {disk_t+= $2} END {printf("%d"), disk_u/disk_t*100}')
```
These lines use the "df" command to display information about the system's disk usage. The output is filtered using "grep" to exclude non-relevant partitions (e.g., boot partitions), and "awk" is used to calculate the total disk space, disk usage, and disk usage percentage.
```console
# CPU LOAD
cpul=$(vmstat 1 2 | tail -1 | awk '{printf $15}')
cpu_op=$(expr 100 - $cpul)
cpu_fin=$(printf "%.1f" $cpu_op)
```
 The script uses the vmstat command to get information about the system's CPU usage. The command is set to run twice with a 1-second delay (vmstat 1 2), and the output is piped to tail -1 to get the second line (the first line is a header). Then, awk is used to print the 15th column, which represents the percentage of time the CPU is idle. The script then subtracts this value from 100 to get the CPU usage percentage and rounds it to one decimal place.
```console
# LAST BOOT
lb=$(who -b | awk '$1 == "system" {print $3 " " $4}')
```
The script uses the who command to get information about the system's last boot. awk is used to print the third and fourth columns (the date and time).
```console
# LVM USE
lvmu=$(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then echo yes; else echo no; fi)
```
The script checks if there are any LVM volumes by running the lsblk command and filtering for lines that contain "lvm". If there are any LVM volumes, the script sets the lvmu variable to "yes"; otherwise, it sets it to "no".
```console
# TCP CONNEXIONS
tcpc=$(ss -ta | grep ESTAB | wc -l)
```
The script uses the ss command to get information about TCP connections. grep is used to filter for lines that contain "ESTAB" (established connections), and wc -l is used to count the number of lines.
```console
# USER LOG
ulog=$(users | wc -w)
```
The script uses the users command to get a list of users currently logged in, and wc -w is used to count the number of words in the output (which represents the number of users).
```console
# NETWORK
ip=$(hostname -I)
mac=$(ip link | grep "link/ether" | awk '{print $2}')
```
The script uses the hostname command to get the system's hostname and the -I option to print its IP addresses. ip link is used to get information about network interfaces, and grep and awk are used to filter for lines that contain "link/ether" (Ethernet interfaces) and print the second column (the MAC address).
```console
# SUDO
cmnd=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
```
The script uses the journalctl command to get information about sudo commands. _COMM=sudo filters for lines that contain "sudo" in the command name, and grep COMMAND filters for lines that contain the word "COMMAND". wc -l is used to count the number of lines.

## What is cron:

Cron is a daemon (a background process that runs continuously) that checks the system's crontab files every minute to see if there are any scheduled tasks that need to be executed. If a task is scheduled, Cron executes the corresponding command or script as the user who created the crontab entry.

The format of a crontab entry consists of six fields, separated by spaces, which define the schedule of the task. The fields are:

- **Minute:** The minute of the hour when the task should be executed (0-59).

- **Hour:** The hour of the day when the task should be executed (0-23).

- **Day of the month:** The day of the month when the task should be executed (1-31).

- **Month:** The month of the year when the task should be executed (1-12).

- **Day of the week:** The day of the week when the task should be executed (0-6, where Sunday is 0 or 7).

- **Command:** The command or script to be executed.

The crontab file can be edited using the "crontab" command, which allows users to create, modify, or delete their scheduled tasks. Users can also use special characters, such as asterisks (*) and slashes (/), to define more complex schedules, such as running a task every 5 minutes, or running a task on weekdays only.

Cron also provides logging and error reporting, which can be useful for debugging and troubleshooting tasks that fail to execute or produce errors. The system administrator can configure Cron to send email notifications to users when a task fails or produces output, allowing them to take corrective action if necessary.

Overall, Cron is a powerful and flexible tool for automating recurring tasks in Unix-like operating systems, offering a wide range of scheduling options and customization features.

## Start and stop the cron service:
```console
ansoulim@ansoulim42:~$ sudo service cron stop
ansoulim@ansoulim42:~$ sudo service cron status
ansoulim@ansoulim42:~$ sudo service cron start
ansoulim@ansoulim42:~$ sudo service cron status
```
