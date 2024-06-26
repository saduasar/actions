#!/bin/bash

TOMURL="https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.75/bin/apache-tomcat-9.0.75.tar.gz"
sudo dnf -y install java-11-openjdk java-11-openjdk-devel
sudo dnf install git maven wget -y
cd /tmp/
sudo wget $TOMURL -O tomcatbin.tar.gz
tar xzvf tomcatbin.tar.gz

#EXTOUT=`tar xzvf tomcatbin.tar.gz`
#TOMDIR=`echo $EXTOUT | cut -d '/' -f1`
sudo mkdir /tmp/tomcat
sudo cp -r apache-tomcat-9.0.75/* tomcat/
sudo useradd --shell /sbin/nologin tomcat
sudo cp -r /tmp/tomcat/ /usr/local/

#sudo rsync -avzh /tmp/$TOMDIR/ /usr/local/tomcat/
sudo chown -R tomcat.tomcat /usr/local/tomcat
sudo rm -rf /etc/systemd/system/tomcat.service

cat <<EOT | sudo tee -a /etc/systemd/system/tomcat.service >/dev/null

[Unit]
Description=Tomcat
After=network.target

[Service]

User=tomcat
Group=tomcat

WorkingDirectory=/usr/local/tomcat

#Environment=JRE_HOME=/usr/lib/jvm/jre
Environment=JAVA_HOME=/usr/lib/jvm/jre

Environment=CATALINA_PID=/var/tomcat/%i/run/tomcat.pid
Environment=CATALINA_HOME=/usr/local/tomcat
Environment=CATALINE_BASE=/usr/local/tomcat

ExecStart=/usr/local/tomcat/bin/catalina.sh run
ExecStop=/usr/local/tomcat/bin/shutdown.sh


RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target

EOT


sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat

cd 
git clone -b main https://github.com/saduasar/vprofile-project.git
cd vprofile-project
mvn install
sudo systemctl stop tomcat
sleep 5
sudo rm -rf /usr/local/tomcat/webapps/ROOT
sudo rm -rf /usr/local/tomcat/webapps/ROOT.war
sudo cp target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war
sudo systemctl start tomcat
sleep 5
sudo systemctl stop firewalld
sudo systemctl disable firewalld
#cp /vagrant/application.properties /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/application.properties
sudo systemctl restart tomcat

sudo echo "the userdata worked yaaay" > /etc/motd
