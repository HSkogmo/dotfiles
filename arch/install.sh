log_file=./install_log.txt

# Install pacman packages
# Helper function
function pacman_install {
	sudo pacman -S $1
	if type -p $1 > /dev/null; then
	    echo "$1 Installed" >> $log_file
	else
	    echo "$1 FAILED TO INSTALL!!!" >> $log_file
	fi
}

# Zsh
pacman_install zsh

# Install oh-my-zsh - run in bg to avoid breaking exit command
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" &
wait

# Install zsh plugins
# zsh-autosuggestions/ zsh-completions/ zsh-syntax-highlighting/
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install npm
pacman_install npm

# Configure ~/.npm-global
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
export PATH=~/.npm-global/bin:$PATH

# Install pure prompt
# npm install -g pure-prompt # issues running this
sudo npm install --global pure-prompt --allow-root --unsafe-perm=true
# source: https://github.com/sindresorhus/pure/issues/342#issuecomment-340291581

# Copy .zshrc and .aliases
cp ../confs/.zshrc ~/.zshrc
cp ../confs/.aliases ~/.aliases

# Set zsh as default shell
chsh -s $(which zsh)

# Install colorls
gem install colorls

pamac build nerd-fonts-complete --no-confirm

echo "Dracula theme: https://draculatheme.com/"
# TODO: Read 'env' and look for 'konsole' 'iterm' 'osx-terminal'
#       Link directly to corresponding dracula theme page

# Setup ssh keys
# Copy all files
mkdir -p ~/.ssh
cp ../dropins/ssh_keys/ ~/.ssh
# chmod 600 files with no extension (private keys)
find ~/.ssh -type f ! -name "*.*" -exec chmod 600 {} \;

# Add private keys to ssh-agent
eval $(ssh-agent)
find ~/.ssh -type f ! -name "*.*" -exec ssh-add {} \;

# Install nodejs
pacman_install nodejs

# Install Vim
pacman_install vim

# Install Docker
pacman_install docker

# Desktop apps

# Install sublime
curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf
sudo pacman -Sy
pacman_install sublime-text

# Spotify
pamac build spotify --no-confirm

# Deluge
pacman_install deluge
