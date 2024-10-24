#!/usr/bin/env bash
set -e

# Shared functions

pretty_print() {
  printf "\n%b\n" "$1"
}

# Start Installation

pretty_print "Here we go..."

# Check CPU Type for installation validation
pretty_print "################################################"
pretty_print "1.) Check CPU Type"
pretty_print "################################################"

	cpu="$(sysctl -n machdep.cpu.brand_string)"
	pretty_print "CPU Type: $cpu"

# Check XCode installation and confirm XCode Licenses
# pretty_print "################################################"
# pretty_print "2.) Confirm XCode Licenses"
# pretty_print "################################################"
#
#	pretty_print "Check XCode"
#	if command sudo xcodebuild -license accept; then
#		pretty_print "Command line tools are already installed"
#	else
#		pretty_print "XCode is not installed. Please install XCode."
#	fi

# Install Rosetta
pretty_print "################################################"
pretty_print "3.) Validate and install Rosetta"
pretty_print "################################################"

	pretty_print "Check for Apple M2 Rosetta Installation"
		if [[ "$cpu" == "Apple M2" ]]; then
			pretty_print "Installing Rosetta"
				softwareupdate --install-rosetta --agree-to-license
		else
			pretty_print "Check for Apple M1 Rosetta Installation"
				if [[ "$cpu" == "Apple M1" ]]; then
					pretty_print "Installing Rosetta"
						softwareupdate --install-rosetta --agree-to-license
				else
					pretty_print "No need to install Rosetta"
				fi
		fi

# Homebrew installation
pretty_print "################################################"
pretty_print "4.) Check Brew Install"
pretty_print "################################################"

	if ! command -v brew &>/dev/null; then
 		pretty_print "Installing Homebrew, an OSX package manager, follow the instructions..." 
	   		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  		if ! grep -qs "recommended by brew doctor" ~/.zshrc; then
    		pretty_print "Put Homebrew location earlier in PATH ..."
      	  		printf '\n# recommended by brew doctor\n' >> ~/.zshrc
      		  	printf 'export PATH="/usr/local/bin:$PATH"\n' >> ~/.zshrc
      		  	export PATH="/usr/local/bin:$PATH"
				echo '# Set PATH, MANPATH, etc., for Homebrew.' >> ~/.zprofile
				echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
				eval "$(/opt/homebrew/bin/brew shellenv)"
  		fi
	else
  		pretty_print "You already have Homebrew installed...good job!"
	fi

# Homebrew OSX libraries update
pretty_print "################################################"
pretty_print "5.) Update Brew Formulas and Casks"
pretty_print "################################################"

	pretty_print "Updating brew formulas"
		brew update

# Homebrew OSX libraries installation	
pretty_print "################################################"
pretty_print "6.) Install Brew Formulas and Casks"
pretty_print "################################################"

	# Install System Tools
	pretty_print "--- Install System Tools ---"
	
		pretty_print "Installing GNU core utilities..."
			brew install coreutils
			brew install wget
			brew install --cask wireshark
		
		pretty_print "Installing GNU find, locate, updatedb and xargs..."
			brew install findutils

		pretty_print "Installing Balena Etcher"
			brew install --cask balenaetcher

		pretty_print "Installing Raspberry PI Imager"
			brew install --cask raspberry-pi-imager

	# Install Password Safes
	pretty_print "--- Install Password Safes ---"

		pretty_print "Installing 1Password"
			brew install --cask 1password

		pretty_print "Installing KeePassXC"
			brew install --cask keepassxc

	# Install Office Packages
	pretty_print "--- Install Office Packages ---"
			
		pretty_print "Installing Libre Office"
			brew install --cask libreoffice
		
		pretty_print "Installing Microsoft Office"	
			brew install --cask microsoft-word
			brew install --cask microsoft-excel
			brew install --cask microsoft-powerpoint
			brew install --cask microsoft-teams
			brew install --cask microsoft-outlook

	# Install Developer Tools
	pretty_print "--- Install Developer Tools ---"

		pretty_print "Installing TextMate"
			brew install --cask textmate

		pretty_print "Installing iTerm2"
			brew install --cask iterm2
			
		pretty_print "Installing Camunda Modeler"	
			brew install --cask camunda-modeler
			
		pretty_print "Installing Py Charm CE"	
			brew install --cask pycharm-ce
			
		pretty_print "Installing Sublime"
			brew install --cask sublime-merge	
			brew install --cask sublime-text

	# Install Internet Service Tools
	pretty_print "--- Install Internet Service Tools ---"

		pretty_print "Installing FireFox"
			brew install --cask firefox
		
		pretty_print "Installing Thunderbird"	
			brew install --cask thunderbird
		
		pretty_print "Installing Brave Browser"
			brew install --cask brave-browser

	# Install Inhabit Cloud Tools		
	pretty_print "--- Install Inhabit Cloud Tools ---"	
	
		# pretty_print "Installing Home Assistant"
			#  	  brew install --cask home-assistant

		pretty_print "Installing Synology Packages"
			brew install --cask synology-chat
			brew install --cask synology-drive
			brew install --cask synologyassistant

		pretty_print "Remote Access"
			brew install --cask openvpn-connect
		
		pretty_print "Installing Apache Directory Studio"		
			brew install --cask apache-directory-studio

# Homebrew OSX libraries x86 64Bit installation
pretty_print "################################################"
pretty_print "7.) Installing x86 64Bit Formulas and Casks"
pretty_print "################################################"

	# Install System Tools
	pretty_print "--- Install System Tools ---"
		
		pretty_print "Installing Oracle JDK"			
			arch -x86_64 brew install oracle-jdk

# Homebrew OSX path deployment
pretty_print "################################################"
pretty_print "8.) Export Brew Formulas and Casks Paths"
pretty_print "################################################"

	printf 'export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"' >> ~/.zshrc
	export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
	
pretty_print "All set to go."