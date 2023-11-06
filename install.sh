

system_deps()
{
	echo
	echo "[*] Install Packages"
	sudo apt-get update -y
	sudo apt install curl git wget file zsh sudo vim libssl-dev libffi-dev build-essential libssl-dev libc6-i386 libc6-dbg gcc-multilib make gcc gdb -y
	sudo apt install python git curl wget vim zsh gdb python3 python3-pip make -y
	sudo apt install gawk bison flex openssl libssl-dev libelf-dev lz4 dwarves -y
	sudo apt install qemu-utils qemu-system-x86 python3 python3-venv g++-mingw-w64-x86-64 zstd -y
	sudo apt install python3 python3-venv -y
	sudo apt install gawk bison flex openssl libssl-dev libelf-dev lz4 dwarves zstd -y

	echo "[*] Installing essentials tools ..."
	sudo apt-get install git make gcc bc libssl-dev pax-utils libelf-dev \
		libgraphviz-dev gnuplot ruby libgtk-3-dev libc6-dev flex bison \
		python3 python3-pip python3-all-dev python3-setuptools python3-wheel -y

	echo "[*] Installing build dependencies for QEMU ..."
	sudo apt-get build-dep qemu-system-x86 -y
	# libcapstone is an optional qemu feature but a hard requirement for kAFL
	sudo apt-get install libcapstone-dev libcapstone3

	echo "[*] Installing kAFL python dependencies ..."
	pip3 install --user mmh3 lz4 psutil fastrand ipdb inotify msgpack toposort pygraphviz pgrep tqdm six python-dateutil

    sudo apt-get install git -y
    echo "[*] install vagrant"
    wget  https://github.com/hashicorp/vagrant/releases/download/2.3.8.dev%2B000032-f72cda8b/vagrant_2.3.8.dev-1_amd64.deb
    sudo dpkg -i vagrant_2.3.8.dev-1_amd64.deb
    sudo rm vagrant_2.3.8.dev-1_amd64.deb



    echo "[*] install packer"
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AA16FCBCA621E701
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    sudo apt-get update
    sudo apt-get install packer
}

system_init(){
    echo "[*] clone kAFL"
    cd ~
    git clone https://github.com/0dayResearchLab/kAFL.git
    cd kAFL

    echo "[+] build nyx+ kernel.."
    sudo make deploy
}

check_gitconfig()
{
	if [ ! "`git config --get user.name`" ] || [ ! "`git config --get user.email`" ]; then
		echo "[-] Error: The installer uses git in order to manage local patches against qemu and linux sources."
		echo "           Please setup a valid git config in order for this to work:"
		echo
		echo " $ git config --global user.name Joe User"
		echo " $ git config --global user.email joe.user@invalid.local"
		echo
		exit 1
	fi
}

system_check()
{
	echo
	echo "[*] Performing basic sanity checks..."

	if [ ! "`uname -s`" = "Linux" ]; then
		echo "[-] Error: KVM-PT is supported only on Linux ..."
		exit 1
	fi


	dist_id="$(lsb_release -si)"
	if [ "$dist_id" != "Debian" -a "$dist_id" != "Ubuntu" ]; then
		echo "[-] Error: This installer was tested using recent Debian and Ubuntu."
		echo
		echo "Other recent Linux distributions will generally work as well but"
		echo "the installer will not be able to resolve the required dependencies."
		echo
		echo "It is recommended to abort the installer and instead follow this"
		echo "script by hand, resolving any build/runtime errors as they come up."
		echo
		echo "Press [Ctrl-c] to abort or [Return] to continue.."
		read
	fi

	for i in dpkg apt-get sudo; do
		T=`which "$i" 2>/dev/null`
		if [ "$T" = "" ]; then
			echo "[-] Error: '$i' not found, please install first."
			exit 1
		fi
	done

	check_gitconfig
    echo "[*] Sanitiy check Done"
}

vm_build()
{
    echo "[*] install windows templates..."
    cd /home/$currentUser/kAFL
    sudo make deploy

    echo "[+] install templates done!"

    sudo make deploy -- --tags examples,examples-template-windows1

    sudo vagrant plugin install vagrant-host-shell
    sudo apt-get install libvirt-dev -y
    sudo vagrant plugin install vagrant-libvirt

    cd /home/$currentUser/kAFL/kafl/examples/templates/windows

    echo "[*] Qemu Image build..."
    echo "[*] You Can see progress By [VNC:port]"
    sudo make build
}

vm_import()
{
    cd /home/$currentUser/kAFL/kafl/examples/templates/windows
    echo "[+] Image Build Done!"
    sudo make import

    sudo apt install qemu qemu-kvm libvirt-clients libvirt-daemon-system virtinst bridge-utils
    sudo systemctl enable libvirtd
    sudo systemctl start
    reboot
}

initial_snapshot()
{
    cd /home/$currentUser/kAFL/kafl/examples/windows_x86_64
    sudo make init
}

edit_vm_dir()
{
    # Check if the script is being run as root
    if [ "$EUID" -ne 0 ]; then
        echo "This script must be run as root."
        exit 1
    fi

    sudo chmod 777 /root/.local/share/libvirt/images/*
    sudo cp /root/.local/share/libvirt/images/* /var/lib/libvirt/images 
    sudo rm -rf /root/.local/share/libvirt/images/*

    sudo virsh pool-define-as --name newpool --type dir --target /var/lib/libvirt/images
    sudo virsh pool-autostart newpool
    sudo virsh pool-start newpool

    echo "[+] reboot after 10 sec.."
    sudo reboot
}

initial_snapshot()
{
    cd /home/$currentUser/kAFL/kafl/examples/windows_x86_64
    sudo make snapshot
}

target_setting()
{
    cd /home/$currentUser/kAFL/kafl/examples/windows_x86_64
    sudo make gui
}

fuzz_snapshot()
{
    cd /home/$currentUser/kAFL/kafl/examples/windows_x86_64
    sudo make init
}
revoke_snapshot()
{
    cd /home/$currentUser/kAFL/kafl/examples/windows_x86_64
    sudo make revoke
}
# Auto-scale building with number of CPUs. Override with ./install -j N <action>
jobs=$(nproc)
currentUser=$(whoami)

#echo "Detected $(nproc) cores, building with -j $jobs..."




case $1 in
    ## dependency
	"deps")
		system_deps
		;;
    ## build kAFL.sh
    "init")
		system_init
		;;
    "check")
        system_check
        ;;
    ## build Qemu 1
    "vm_build")
        vm_build
        ;;
    ## build Qemu 2
    "vm_import")
        vm_import
        ;;
    ## itwill be error
    "initial_snapshot")
        initial_snapshot
        ;;
    ## edit Image.sh
    "edit_vm_dir")
        edit_vm_dir
        ;;
        ## init snapshot
    "init_snapshot")
        initial_snapshot
        ;;
        ## edit Image.sh
    "target_setting")
        target_setting
        ;;
        ## edit Image.sh
    "fuzz_snapshot")
        fuzz_snapshot
        ;;
    "revoke_snapshot")
        revoke_snapshot
        ;;
esac