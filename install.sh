#!/bin/bash

# Bash script for building the IOI 2017 contest image
# Version: 1.4
# http://ioi2017.org/


set -xe

if [ -z $LIVE_BUILD ]
then
    export USER=ioi2017
    export HOME=/home/$USER
else
    export USER=root
    export HOME=/etc/skel
fi


# ----- Initilization -----

cat << EOF >/etc/apt/sources.list
deb http://archive.ubuntu.com/ubuntu/ xenial main restricted universe
deb http://security.ubuntu.com/ubuntu/ xenial-security main restricted universe
deb http://archive.ubuntu.com/ubuntu/ xenial-updates main restricted universe
EOF


# Add missing repositories
add-apt-repository -y ppa:damien-moore/codeblocks-stable
apt-add-repository -y ppa:mmk2410/intellij-idea


# Update packages list
apt-get -y update
apt-get -y purge thunderbird example-content

# Upgrade everything if needed
apt-get -y upgrade


# ----- Install software from Ubuntu repositories -----

# Compilers
apt-get -y install gcc-5 g++-5 openjdk-8-jdk openjdk-8-source fpc

# Editors and IDEs
apt-get -y install codeblocks codeblocks-contrib emacs geany geany-plugins
apt-get -y install gedit vim-gnome vim joe kate kdevelop lazarus nano
apt-get -y install intellij-idea-community

# Debuggers
apt-get -y install ddd libappindicator1 libindicator7 libvte9 valgrind visualvm

# Interpreters
apt-get -y install python2.7 python3.5 ruby

# Documentation
apt-get -y install stl-manual openjdk-8-doc fp-docs python2.7-doc python3.5-doc

# Other Software
apt-get -y install firefox konsole mc


# ----- Install software not found in Ubuntu repositories -----

cd /tmp/

# CPP Reference
wget http://upload.cppreference.com/mwiki/images/7/78/html_book_20151129.zip
unzip html_book_20151129.zip -d /opt/cppref

# Visual Studio Code
apt-get -y install git
wget -O vscode-amd64.deb https://vscode-update.azurewebsites.net/latest/linux-deb-x64/stable
dpkg -i vscode-amd64.deb
su $USER -c "mkdir -p $HOME/.config/Code/User"

# Visual Studio Code - extensions
su $USER -c "mkdir -p $HOME/.vscode/extensions"
su $USER -c "HOME=$HOME code --user-data-dir=$HOME/.config/Code/ --install-extension ms-vscode.cpptools"
su $USER -c "HOME=$HOME code --user-data-dir=$HOME/.config/Code/ --install-extension georgewfraser.vscode-javac"

# Eclipse 4.6 and CDT plugins
wget http://eclipse.mirror.rafal.ca/technology/epp/downloads/release/neon/2/eclipse-java-neon-2-linux-gtk-x86_64.tar.gz
tar xzvf eclipse-java-neon-2-linux-gtk-x86_64.tar.gz -C /opt/
mv /opt/eclipse /opt/eclipse-4.6
/opt/eclipse-4.6/eclipse -application org.eclipse.equinox.p2.director -noSplash -repository http://download.eclipse.org/releases/neon \
-installIUs \
org.eclipse.cdt.feature.group,\
org.eclipse.cdt.build.crossgcc.feature.group,\
org.eclipse.cdt.launch.remote,\
org.eclipse.cdt.gnu.multicorevisualizer.feature.group,\
org.eclipse.cdt.testsrunner.feature.feature.group,\
org.eclipse.cdt.visualizer.feature.group,\
org.eclipse.cdt.debug.ui.memory.feature.group,\
org.eclipse.cdt.autotools.core,\
org.eclipse.cdt.autotools.feature.group,\
org.eclipse.linuxtools.valgrind.feature.group,\
org.eclipse.linuxtools.profiling.feature.group,\
org.eclipse.remote.core,\
org.eclipse.remote.feature.group
ln -s /opt/eclipse-4.6/eclipse /usr/bin/eclipse

# Sublime Text 3
wget https://download.sublimetext.com/sublime-text_build-3126_amd64.deb
dpkg -i sublime-text_build-3126_amd64.deb
# Update C++ build command
wget http://ioi2017.org/files/htc/C++.sublime-package
mv C++.sublime-package /opt/sublime_text/Packages

# AltGr
mkdir -p /usr/local/share/altgr/
wget http://ioi2017.org/files/htc/icon.png -O /usr/local/share/altgr/icon.png
wget http://ioi2017.org/files/htc/enable_altgr.sh -O /opt/enable_altgr.sh
wget http://ioi2017.org/files/htc/disable_altgr.sh -O /opt/disable_altgr.sh
chmod +x /opt/*.sh


# ----- Create desktop entries -----

cd /usr/share/applications/

cat << EOF > python3.5-doc.desktop
[Desktop Entry]
Type=Application
Name=Python 3.5 Documentation
Comment=Python 3.5 Documentation
Icon=firefox
Exec=firefox /usr/share/doc/python3.5/html/index.html
Terminal=false
Categories=Documentation;Python3.5;
EOF

cat << EOF > python2.7-doc.desktop
[Desktop Entry]
Type=Application
Name=Python 2.7 Documentation
Comment=Python 2.7 Documentation
Icon=firefox
Exec=firefox /usr/share/doc/python2.7/html/index.html
Terminal=false
Categories=Documentation;Python2.7;
EOF

cat << EOF > eclipse.desktop
[Desktop Entry]
Type=Application
Name=Eclipse Neon
Comment=Eclipse Integrated Development Environment
Icon=/opt/eclipse-4.6/icon.xpm
Exec=eclipse
Terminal=false
Categories=Development;IDE;Java;
EOF

cat << EOF > disable_altgr.desktop
[Desktop Entry]
Type=Application
Name=Disable Menu\non Alt Gr
Comment=Disable AltGr
Exec=/opt/disable_altgr.sh
Icon=/usr/local/share/altgr/icon.png
Terminal=true
Categories=AltGr;
EOF

cat << EOF > enable_altgr.desktop
[Desktop Entry]
Type=Application
Name=Enable Menu\non Alt Gr
Comment=Enable AltGr
Exec=/opt/enable_altgr.sh
Icon=/usr/local/share/altgr/icon.png
Terminal=true
Categories=AltGr;
EOF

cat << EOF > cpp-doc.desktop
[Desktop Entry]
Type=Application
Name=C++ Documentation
Comment=C++ Documentation
Icon=firefox
Exec=firefox /opt/cppref/reference/en/index.html
Terminal=false
Categories=Documentation;C++;
EOF

cat << EOF > fp-doc.desktop
[Desktop Entry]
Type=Application
Name=FreePascal Documentation
Comment=FreePascal Documentation
Icon=firefox
Exec=firefox /usr/share/doc/fp-docs/3.0.0/fpctoc.html
Terminal=false
Categories=Documentation;FP;
EOF

cat << EOF > java-doc.desktop
[Desktop Entry]
Type=Application
Name=Java Documentation
Comment=Java Documentation
Icon=firefox
Exec=firefox /usr/share/doc/openjdk-8-doc/api/index.html
Terminal=false
Categories=Documentation;Java;
EOF

cat << EOF > stl-manual.desktop
[Desktop Entry]
Type=Application
Name=STL Manual
Comment=STL Manual
Icon=firefox
Exec=firefox /usr/share/doc/stl-manual/html/index.html
Terminal=false
Categories=Documentation;STL;
EOF

mkdir -p "$HOME/Desktop/Editors & IDEs"
mkdir -p "$HOME/Desktop/Utils"
mkdir -p "$HOME/Desktop/Docs"

chown $USER "$HOME/Desktop/Editors & IDEs"
chown $USER "$HOME/Desktop/Utils"
chown $USER "$HOME/Desktop/Docs"

# Copy Editors and IDEs
for i in gedit codeblocks emacs24 geany lazarus-1.6 org.kde.kate sublime_text eclipse code vim gvim kde4/kdevelop intellij-idea-community
do
    cp "$i.desktop" "$HOME/Desktop/Editors & IDEs"
done

# Copy Docs
for i in cpp-doc stl-manual java-doc fp-doc python2.7-doc python3.5-doc
do
    cp "$i.desktop" "$HOME/Desktop/Docs"
done

# Copy Utils
for i in ddd disable_altgr enable_altgr gnome-calculator gnome-terminal mc org.kde.konsole visualvm
do
    cp "$i.desktop" "$HOME/Desktop/Utils"
done

chmod a+x "$HOME/Desktop/Editors & IDEs"/*
chmod a+x "$HOME/Desktop/Utils"/*
chmod a+x "$HOME/Desktop/Docs"/*


# Set desktop settings
apt-get install -y xvfb
if [ -z $LIVE_BUILD ]
then
    wget -O /opt/wallpaper.png "http://ioi2017.org/files/htc/wallpaper.png"
fi
xvfb-run gsettings set org.gnome.desktop.background primary-color "#000000000000"
xvfb-run gsettings set org.gnome.desktop.background picture-options "spanned"
xvfb-run gsettings set org.gnome.desktop.background picture-uri "file:///opt/wallpaper.png"
