#!/bin/sh -e

# 24 Dec 2015 : GWA : Minimal box is very minimal. Use to get
# add-apt-repository, updatedb, tmux.
apt-get -y update
apt-get -y install software-properties-common locate tmux bash-completion man lsof iotop dos2unix

echo "set grub-pc/install_devices /dev/sda" | debconf-communicate
apt-get -y update
apt-get -y upgrade



# 24 Dec 2015 : GWA : Bootstrap jebr224 user.
if ! id -u jebr224 > /dev/null 2>&1 ; then
	useradd jebr224 -u 10000 -m -s /bin/bash > /dev/null 2>&1
	rsync -a /etc/skel/ /home/jebr224/

	mkdir /home/jebr224/.ssh
	cp /home/vagrant/.ssh/authorized_keys /home/jebr224/.ssh/
	chmod 0700 /home/jebr224/.ssh

	echo "jebr224 ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/jebr224

	touch /home/jebr224/.hushlogin
	#mv /tmp/.bashrc /home/jebr224/
	dos2unix /home/jebr224/.bashrc >/dev/null 2>&1
	chown jebr224:jebr224 -R /home/jebr224/

	# 24 Dec 2015 : GWA : Try to speed up SSH. Doesn't help much.
	echo >> /etc/ssh/sshd_config
	echo "UseDNS no" >> /etc/ssh/sshd_config
	echo "GSSAPIAuthentication no" >> /etc/ssh/sshd_config
	service ssh reload

	echo "America/New_York" > /etc/timezone
	dpkg-reconfigure --frontend noninteractive tzdata 2>/dev/null
fi

# 24 Dec 2015 : GWA : Remount shared folders with correct ownership on
# every boot.
mv /tmp/sharedfolders.conf /etc/init/
chown root:root /etc/init/sharedfolders.conf
mount -t vboxsf -o uid=10000,gid=10000 home_jebr224_src /home/jebr224/src

updatedb
