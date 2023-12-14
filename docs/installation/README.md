# How to use

# Table of Contents
0. [Tested Environment](#section-0)
1. [Install dependencies](#section-1)
2. [Enroll github SSH Keys](#section-2)

3. [Clone this repo & change kernel to 6.0.0-nyx+](#section-3)
4. [Build the Windows VM Template](#section-4)
5. [Import the template into Vagrant](#section-5)
6. [Import into libvirt](#section-6)
7. [Run Fuzz](#section-7)


****
# 0. Tested Environment <a name="section-0"></a>
----------------------------------
```
CPU : Intel i-7 12700K
RAM : 84G
GPU : Nvidia Geforce 1060 super
OS : Ubuntu 20.04.6 LTS
```

# 1. Install dependencies <a name="section-1"></a>
----------------------------------
```
sudo apt-get update -y
sudo apt-get install gcc git make curl vim python3 python3.8-venv -y
```


# 2. Enroll github SSH Keys <a name="section-2"></a>
----------------------------------
```
$ ssh-keygen -t rsa -C <example@example.com>

$ cat .ssh/id_rsa.pub
ssh-rsa AAAAB3Nz...

put this string to github -> profile -> settings -> SSH and GPG Keys -> New SSH key
```



# 3. Clone this repo & change kernel to 6.0.0-nyx+ <a name="section-3"></a>
----------------------------------
```
cd ~
git clone git@github.com:0dayResearchLab/msFuzz.git kAFL
cd kAFL
make deploy
reboot
```

# 4. Build the Windows VM Template <a name="section-4"></a>
----------------------------------
```
cd ~/kAFL
make deploy -- --tags examples,examples-template-windows
cd ./kafl/examples/templates/windows
make build
```


# 5. Import the template into Vagrant <a name="section-5"></a>
----------------------------------
```
make import
```


# 6. Import into libvirt <a name="section-6"></a>
----------------------------------
```
cd ../../windows_x86_64
make init
```


# 7. Run Fuzz <a name="section-7"></a>
----------------------------------
```
cd ~/kAFL
make env
cd kafl/examples/windows_x86_64/
mkdir -p bin/driver 
cp ../../fuzzer/Utils/Harness_for_nyx.sys ./bin/driver


1. vi src/driver/vuln_test.c -> Change Symbolic Link Name / target sys ( Target Driver Name )

2. Qemu Booting
-> vagrant up --no-provision

3. Make Qemu Snapshot named 'ready_provision'
-> vagrant snapshot save --force 'ready_provision'

4.a
    make target -> automatic loading the Driver to Qemu that located in bin/driver/target.sys & bin/driver/vuln_test.exe
4.b
    make no_target -> automatic loading the Driver to Qemu that located in vuln_test.exe / call_stack.sys
4.c
    make environment yourself


6. mkdir -p ./seed

7. ./run.sh


8. Show GUI
cd ~/kAFL
make env
cd kafl/examples/windows_x86_64/
kafl gui -w work

9. make revoke -> Revoke the Snapshot from fuzzed to Stage #3 ( 'ready_provison' )
```


![Fuzz Success](fuzzing.png?raw=true)
