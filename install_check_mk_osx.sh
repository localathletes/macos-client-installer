#!/usr/bin/env bash
set -e

# Shared functions

pretty_print() {
  printf "\n%b\n" "$1"
}

# Start Installation

pretty_print "Here we go..."

# Clone Repo
pretty_print "################################################"
pretty_print "1.) Clone Check_MK Repo"
pretty_print "################################################"

cd ~/Repositories/GitHub

if test -d Check_MK; then
	cd Check_MK
	pretty_print "Pull https://gitea.inhabit.place/inhabit/Check_MK.git"
	git pull
	cd ..
else
	pretty_print "Clone https://gitea.inhabit.place/inhabit/Check_MK.git"
	git clone https://gitea.inhabit.place/inhabit/Check_MK.git
fi

# Copy and fix Check_MK Repo
pretty_print "################################################"
pretty_print "2.) Copy and fix Check_MK Repo"
pretty_print "################################################"

if test -d checkmk; then
	pretty_print "Folder exists"
	rm -rf checkmk
fi

pretty_print "Copy Check_MK to checkmk"
cp -r Check_MK checkmk



cd checkmk

# Remove less common plugins
pretty_print "Remove less common plugins"
rm -f agents/plugins/monitor-jss-and-macos-updates agents/plugins/city-temperatures agents/plugins/monitor-kerio agents/plugins/smart*

pretty_print "################################################"
pretty_print "3.) Install dependencies"
pretty_print "################################################"

# Install dependencies
pretty_print "Install dependencies from homebrew"
brew install smartmontools osx-cpu-temp

# Once lnx_if fix is merged into the agent, the below is required (see: https://github.com/ThomasKaiser/Check_MK/pull/2)
pretty_print "Install iproute2mac from homebrew"
brew install iproute2mac

pretty_print "################################################"
pretty_print "3.) Fix plist"
pretty_print "################################################"

# Modify the plist file (remove cwd)
pretty_print "Modify the plist file (remove cwd)"
sed -i '' '/<key>WorkingDirectory/{N;d;}' LaunchDaemon/de.mathias-kettner.check_mk.plist

pretty_print "################################################"
pretty_print "3.) Built structure"
pretty_print "################################################"

# Create directories needed and copy files to required location
pretty_print "Create directories needed and copy files to required location"
pretty_print "Create folder /usr/local/lib/check_mk_agent"
if test -d /usr/local/lib/check_mk_agent; then
	pretty_print "Folder exists"
else
	mkdir /usr/local/lib/check_mk_agent
	pretty_print "Folder created"
fi
pretty_print "Create folder /usr/local/lib/check_mk_agent/local"
if test -d /usr/local/lib/check_mk_agent/local; then
	pretty_print "Folder exists"
else
	mkdir /usr/local/lib/check_mk_agent/local
	pretty_print "Folder created"
fi

sudo cp agents/check_mk_agent.macosx /usr/local/lib/check_mk_agent/
sudo cp -r agents/plugins/ /usr/local/lib/check_mk_agent/
sudo cp LaunchDaemon/de.mathias-kettner.check_mk.plist /Library/LaunchDaemons/
if test -h /usr/local/bin/check_mk_agent; then
	pretty_print "check_mk_agent link in place"
else
	sudo ln -s /usr/local/lib/check_mk_agent/check_mk_agent.macosx /usr/local/bin/check_mk_agent
	pretty_print "Created check_mk_agent link"
fi
if test -d /etc/check_mk; then
	pretty_print "Folder exists"
else
	sudo mkdir /etc/check_mk
	pretty_print "Folder created"
fi

sudo touch /var/run/de.arts-others.softwareupdatecheck
sudo touch /var/log/check_mk.err

# Permissions
pretty_print "Set permissions"
sudo chmod +x /usr/local/lib/check_mk_agent/check_mk_agent.macosx
sudo chmod o+rw /var/run/de.arts-others.softwareupdatecheck
sudo chmod 666 /var/log/check_mk.err
sudo chown -R root:admin /usr/local/lib/check_mk_agent
sudo chmod 644 /Library/LaunchDaemons/de.mathias-kettner.check_mk.plist

# Install LaunchDaemon
pretty_print "Launch daemon"
sudo launchctl load -w /Library/LaunchDaemons/de.mathias-kettner.check_mk.plist

pretty_print "################################################"
pretty_print "3.) Clear repo"
pretty_print "################################################"

pretty_print "Remove checkmk folder"
cd ..
rm -rf checkmk
