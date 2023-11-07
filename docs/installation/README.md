## How to use


# 1. Install dependencies
----------------------------------
```
sudo apt-get update -y
sudo apt-get install gcc git make curl vim python3 python3.8-venv -y
```


# 2. Enroll github SSH Keys
----------------------------------
```
$ ssh-keygen -t rsa -C <example@example.com>

$ cat .ssh/id_rsa.pub
ssh-rsa AAAAB3Nz...

put this string to github -> profile -> settings -> SSH and GPG Keys -> New SSH key
```



# 3. Clone this repo & change kernel to 6.0.0-nyx+
----------------------------------
```
cd ~
git clone git@github.com:0dayResearchLab/kAFL.git
cd kAFL
make deploy
reboot
```

# 4. Build the Windows VM Template
----------------------------------
```
cd ~/kAFL
make deploy -- --tags examples,examples-template-windows
cd ./kafl/examples/templates/windows
make build
```


# 5. Import the template into Vagrant
----------------------------------
```
make import
```


# 6. Import into libvirt
----------------------------------
```
cd ../../windows_x86_64
make init
```


# 7. Run Fuzz
----------------------------------
```
cd ~/kAFL
make env
cd kafl/examples/windows_x86_64/

1. make snapshot -> 스냅샷 생성

2.a
    make target -> bin/driver경로에 target.sys 드라이버를 자동으로 로드시킴
2.b
    make no_target -> vuln_test.exe / call_stack만 로드시키고 타겟은 알아서 설치

3. make init -> Fuzzing용 snapshot생성

4. make revoke -> 복귀지점으로 복귀
```