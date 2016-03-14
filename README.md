# My neovim config
## I - Changelog
- 14/03/2016 :
    - add ag.nvim plugin
- 03/02/2016 :
    - replace bling/vim-airline with vim-airline/vim-airline
    - add vim-airline-themes
- 22/12/2015 :
    - autoinstall plug and do not put it in git repo
- 21/12/2015 :
    - modify neomake configuration (doesn't run make now)
- 05/12/2015 :
    - remove mouse
- 23/11/2015 :
    - add word search shortcut (<Leader>s)
- 13/11/2015 :
    - change ctrlp source (you need to delete current ctrlp dir and redo PlugInstall)
    - move from ~/.nvim to ~/.config/nvim even for plugins
    - ctrlp now ignore files listed in .gitignore

## II - Neovim installation
This step may take some time, you should do III-1, III-3 and III-4 at the same time.
### Linux
#### Manual
```bash
cd
git clone git@github.com:neovim/neovim.git
cd neovim
make CMAKE_BUILD_TYPE=Release
make install
```
#### Distro specific
Some distro have a way to install neovim using their package manager, report to doc.
https://github.com/neovim/neovim/wiki/Installing-Neovim
### Mac os x
```bash
brew tap neovim/neovim
brew install --HEAD neovim
```
## III - Add my neovim config
### 1 - Get the config
```bash
cd
if [[ ! -d "$HOME/.config" ]]; then
	mkdir $HOME/.config
fi
git clone git@github.com:geam/config_neovim.git $HOME/.config/nvim
```
### 2 - Install the packages
Start neovim
```bash
nvim
```
Then use the command
```vim
:PlugInstall
```
### 3 - Add the correct font for the status line
The fonts need to be installed on the client pc, so if you use neovim on a server, the font need to be installed on your computer and not on the serveur/
#### 3.1 Archlinux
```bash
yaourt -S powerline-fonts-git
```
#### 3.2 Others
Note that I only test that on mac os x cause I only have an archlinux and mac os X at school..
```bash
cd
git clone https://github.com/powerline/fonts temp_fonts
cd temp_fonts
./install.sh
```
The fonts should be installed. If not, check your os documentation for the fonts.
Use one of these font in your terminal emulator.
##### 3.2.1 Mac os x
On mac os x, you may have an error stating that ~/Library/Fonts doesn't exist, create the dir then relaunch the script
```bash
mkdir ~/Library/Fonts
cd ~/temp_fonts/
./install.sh
```
Then, you need to add the font in your font book, to do so, do the following
```
<command-space>font Book
```
In the font book, create a new lib (right clic, new lib) and add add the font to this library (right clic, add fonts)
### 4 - Set the font in your terminal emulator
#### 4.1 - iTerm on Mac os x
```
<command-o>
```
Édit your config and choose the non-ascii font : you can choose any font that contain "powerline" in it's name and that's it.
#### 4.2 - other term
Same as above but I don't know the way to do it. If you've got an issue, report to this : https://powerline.readthedocs.org/en/latest/installation.html#fonts-installation
### IV - Licence
#### autoload/plug.vim
autoload/plug.vim is an asynchronous plugin manager (https://github.com/junegunn/vim-plug), it comes under the MIT licence
#### The rest
The files nvimrc and README.md are under the beer-ware licence.
```
----------------------------------------------------------------------------
"THE BEER-WARE LICENSE" (Revision 42):
<mdelage@student.42.fr> wrote this file. As long as you retain this notice
you can do whatever you want with this stuff. If we meet some day, and you
think this stuff is worth it, you can buy me a beer in return Marc Delage
----------------------------------------------------------------------------
```
