#!/bin/bash

# Bash script for building IOI 2017 contestant image
# Version: 1.0
# http://ioi2017.org/

set -e
USER=ioi2017


# ----- Initilization -----

# Add missing repositories
add-apt-repository -y ppa:damien-moore/codeblocks-stable

# Update packages list
apt-get -y update

# Upgrade everything if needed
apt-get -y upgrade


# ----- Install software from Ubuntu repositories -----

# IDEs, editors, debuggers, and documentations
apt-get -y install codeblocks codeblocks-contrib emacs geany geany-plugins gedit vim-gnome joe kate kdevelop lazarus nano vim ddd mc libappindicator1 libindicator7 stl-manual konsole libvte9 valgrind 

# OpenJDK 
apt-get -y install openjdk-8-jdk openjdk-8-doc openjdk-8-source visualvm

# FreePascal
apt-get -y install fpc fp-docs

# Install Python
apt-get -y install python2.7 python2.7-doc
apt-get -y install python3 python3-doc

# Install Ruby
apt-get -y install ruby


# ----- Install software not found in Ubuntu repositories -----

cd /tmp/

# CPP Reference
wget http://upload.cppreference.com/mwiki/images/7/78/html_book_20151129.zip
unzip html_book_20151129.zip -d /opt/cppref

# Visual Studio Code
apt-get -y install git
wget -O vscode-amd64.deb https://vscode-update.azurewebsites.net/latest/linux-deb-x64/stable
dpkg -i vscode-amd64.deb
sudo -H -u $USER bash -c "mkdir -p /home/$USER/.config/Code/User" 

# Visual Studio Code - extensions
sudo -H -u $USER bash -c "mkdir -p /home/$USER/.vscode/extensions" 
sudo -u $USER bash -c "DISPLAY=:0 XAUTHORITY=/home/$USER/.Xauthority HOME=/home/$USER/ code --install-extension ms-vscode.cpptools"
sudo -u $USER bash -c "DISPLAY=:0 XAUTHORITY=/home/$USER/.Xauthority HOME=/home/$USER/ code --install-extension georgewfraser.vscode-javac"

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
wget http://ioi2017.org/files/htc/icon.png
wget http://ioi2017.org/files/htc/enable_altgr.sh
wget http://ioi2017.org/files/htc/disable_altgr.sh
cp enable_altgr.sh /opt/
cp disable_altgr.sh /opt/
mkdir -p /usr/local/share/altgr/
cp icon.png /usr/local/share/altgr/
chmod +x /opt/*.sh


# ----- Create desktop entries -----

cd /usr/share/applications/

cat << EOF > python3-doc.desktop
[Desktop Entry]
Type=Application
Name=Python 3.5 Documentation
Comment=Python 3.5 Documentation
Icon=firefox
Exec=firefox /usr/share/doc/python3.5/html/index.html
Terminal=false
Categories=Documentation;Python3;
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

cat << EOF > python-doc.desktop
[Desktop Entry]
Type=Application
Name=Python 2.7 Documentation
Comment=Python 2.7 Documentation
Icon=firefox
Exec=firefox /usr/share/doc/python-doc/html/index.html
Terminal=false
Categories=Documentation;Python2;
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

mkdir "/home/$USER/Desktop/Editors & IDEs"
mkdir "/home/$USER/Desktop/Utils"
mkdir "/home/$USER/Desktop/Docs"

chown $USER "/home/$USER/Desktop/Editors & IDEs"
chown $USER "/home/$USER/Desktop/Utils"
chown $USER "/home/$USER/Desktop/Docs"

# Copy Editors and IDEs 
for i in gedit codeblocks emacs24 geany lazarus-1.6 org.kde.kate sublime_text eclipse code vim gvim kde4/kdevelop
do
    cp "$i.desktop" "/home/$USER/Desktop/Editors & IDEs"
done

# Copy Docs
for i in cpp-doc fp-doc java-doc python3-doc python-doc stl-manual
do
    cp "$i.desktop" "/home/$USER/Desktop/Docs"
done

# Copy Utils
for i in ddd disable_altgr enable_altgr gnome-calculator gnome-terminal mc org.kde.konsole
do
    cp "$i.desktop" "/home/$USER/Desktop/Utils"
done

chmod a+x "/home/$USER/Desktop/Editors & IDEs"/*
chmod a+x "/home/$USER/Desktop/Utils"/*
chmod a+x "/home/$USER/Desktop/Docs"/*
