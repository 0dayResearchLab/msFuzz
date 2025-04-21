# How to use

# Table of Contents
0. [Tested Environment](#section-0)
1. [Install dependencies](#section-1)
2. [Clone this repo & change kernel to 6.0.0-nyx+](#section-2)
3. [Build the Windows VM Template](#section-3)
4. [Import the template into Vagrant](#section-4)
5. [Import into libvirt](#section-5)
6. [Run Fuzz](#section-6)


****
# 0. Tested Environment <a name="section-0"></a>
----------------------------------
```
CPU : Intel i-7 12700K
RAM : 84G
GPU : Nvidia Geforce 1060 super
OS : Ubuntu 20.04.6 LTS, Ubuntu 22.04.6 LTS  
```

# 1. Install dependencies <a name="section-1"></a>
----------------------------------
```bash
sudo apt-get update -y
sudo apt-get install gcc git make curl vim python3 python3-venv -y
```

# 2. Clone this repo & change kernel to 6.0.0-nyx+ <a name="section-2"></a>
----------------------------------
```bash
cd ~
git clone https://github.com/0dayResearchLab/msFuzz.git kAFL
cd kAFL
make deploy
reboot
```

# 3. Build the Windows VM Template <a name="section-3"></a>
----------------------------------
```bash
cd ~/kAFL
make deploy -- --tags examples,examples-template-windows
cd ./kafl/examples/templates/windows
make build
```


# 4. Import the template into Vagrant <a name="section-4"></a>
----------------------------------
```bash
make import
```


# 5. Import into libvirt <a name="section-5"></a>
----------------------------------
```bash
cd ../../windows_x86_64
make init
```


# 6. Run Fuzz <a name="section-6"></a>
----------------------------------
```bash
cd ~/kAFL
make env
cd kafl/examples/windows_x86_64/
mkdir -p bin/driver 
cp ../../fuzzer/Utils/Harness_for_nyx.sys ./bin/driver


1. vi src/driver/vuln_test.c -> Change Symbolic Link Name / target sys (Target Driver Name)

2. Qemu Booting
-> vagrant up --no-provision

3. Make Qemu Snapshot named 'ready_provision'
-> vagrant snapshot save --force 'ready_provision'

4. Select one of the following targets to push and load the driver and/or harness into the guest VM via WinRM:
   - make target
     Automatically copies **both** the test driver (`bin/driver/target.sys`) and the harness executable (`bin/driver/vuln_test.exe`) into the VM and loads them.

   - make no_target
     Copies **only** the harness executable (`vuln_test.exe`) into the VM and loads it, no test driver is deployed.

   - make environment
     Skips the built‑in WinRM scripts. Use this if you prefer to configure the QEMU/WinRM environment manually.


6. mkdir -p ./seed

7. ./run.sh
    you can get the result.json file at angrPT(https://github.com/0dayResearchLab/angrPT)
    And result.json have the information about the each IoControl Constraint and Global Variable dependencies.

8. Show GUI
cd ~/kAFL
make env
cd kafl/examples/windows_x86_64/
kafl gui -w work

9. make revoke -> Revoke the Snapshot from fuzzed to Stage #3 ('ready_provison')
```

# 7. How to reproduce bugs <a name="section-7"></a>
----------------------------------
kAFL includes a replay utility to rerun a specific payload against your driver:

```bash
# Build and run the replay tool
cd $kAFL/docs/installation
[you compiler] replay.cpp -o replay

# Usage:
./replay <SymbolicLinkName> <PayloadFile>
```
![Fuzz Success](fuzzing.png?raw=true)
