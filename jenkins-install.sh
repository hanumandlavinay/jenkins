#!/usr/bin/env bash

# SHELL SCRIPT FOR JENKINS SETUP

clear
echo "============ SHELL SCRIPT To Setup JENKINS ==============="
echo "                                               "
echo "============ Options to choose =================="
echo "1. To Install Jenkins"
echo "2. To Uninstall Jenkins"
echo "3. To Start Jenkins Service"
echo "4. To Restart Jenkins Service"
echo "5. To Check Status of Jenkins Service"
echo "==============================================="

read -p "Please select your desired choice: " opt
echo "-----------------------------------------------"

case $opt in
	1)

install()
{
  java -version
  	 if [[ $? -eq 0 ]]
 	 then
                echo -e "\e[33m**********java is already installed************\e[0m"
 	       	echo "		"
		
	 else [[ $? -ne 0 ]]
		
		echo "---------------------------------------------------------------------"
       	        echo "Insatlling java"
		echo "---------------------------------------------------------------------"
       	        sudo yum install -y java-1.8* &>/dev/null
		echo -e "\e[33m**********java is successfully installed************\e[0m"
         fi
  mvn --version
  if [[ $? -eq 0 ]]
  then
	  echo "Maven is already installed"
  else [[ $? -ne 0 ]]
	  
  	echo "---------------------------------------------------------------------"
  	echo "INSTALLING MAVEN"
	echo "---------------------------------------------------------------------"
  	cd /opt/ 
	echo "Downloading apache maven package"
	sudo yum install -y wget
	sudo wget https://dlcdn.apache.org/maven/maven-3/3.8.5/binaries/apache-maven-3.8.5-bin.tar.gz &>/dev/null
  	#sudo wget https://dlcdn.apache.org/maven/maven-3/3.8.4/binaries/apache-maven-3.8.4-bin.tar.gz
	echo "Unzipping apache-maven"
 	sudo tar -xvzf apache-maven-3.8.5-bin.tar.gz &>/dev/null
  	if [[ $? -eq 0 ]]
  	then
		echo -e  "\e[33mMaven is successfully installed\e[0m"
		echo "-------------------------------------------------------"
	else
		echo "Maven installation is unsuccessful"
		echo "======================================================="
		exit 1
	fi
  fi

  echo "-----------------------------------------------------------------------"
  echo "Setting Path for JAVA and MAVEN"
  echo "-----------------------------------------------------------------------"
  cd ~ : sudo sed -i '7 i JAVA_HOME=$(find /usr/lib/jvm/java-1.8* | head -n 3 | tail -1)' .bash_profile
  cd ~ ; sudo sed -i '8 i M2_HOME=/opt/apache-maven-3.8.4' .bash_profile
  cd ~ ; sudo sed -i '9 i M2=/opt/apache-maven-3.8.4/bin' .bash_profile
  cd ~ ; sudo sed -i 's/PATH=$PATH:$HOME\/.local\/bin:$HOME\/bin/PATH=$PATH:$HOME\/.local\/bin:$HOME\/bin:$JAVA_HOME:$M2_HOME:$M2/' .bash_profile
  source ~/.bash_profile
  echo -e "Path setting completed\nJava installed path is: $JAVA_HOME\nMaven installed path is: $M2_HOME"
  sleep 5
  

  echo "---------------------------------------------------------------------"
  echo "INSTALLING JENKINS" 
  echo "---------------------------------------------------------------------"
  echo "Downloading Jenkins Repository"
  sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo &>/dev/null
  echo "Download Completed"
  sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key &>/dev/null 
  echo "Installing Jenkins"
  sudo yum install jenkins -y &>/dev/null
 
  if [[ $? -eq 0 ]]
  then
	  echo " 		"
	  echo -e "\e[33m*******************Jenkins is successfully installed****************\e[0m"
	  echo "		"
	  sleep 5
	  sudo systemctl start jenkins
	  awk 'BEGIN {print "------------Jenkins Status-------------"}' ; sudo systemctl status jenkins | grep -i active
  else [[ $? -ne 0 ]]
	  	  echo "Jenkins installation unsuccessful"
		  echo "--------------------------------------------------------"
		  sudo systemctl status jenkins | grep -i  active
		  echo "--------------------------------------------------------"
		  echo "Jenkins failed to start"
		  echo "--------------------------------------------------------"
		  exit 1
  fi
  myip=$(dig +short myip.opendns.com @resolver1.opendns.com)
  echo -e "\e[33mJenkins server is started and you can login by using below link\e[0m\n$myip:8080"

}

install
;;

	2)
uninstall()

{
	echo "-----------Uninstalling Jenkins-------------"
	sudo yum remove jenkins -y &>/dev/null
        sudo systemctl status jenkins | grep active
	echo "Jenkins uninstalled"


}

uninstall
;;

	3)
start()
{
	echo "Starting Jenkins Service"
	sudo systemctl start jenkins
	awk 'BEGIN {print "------------Jenkins Status-------------"}' ; sudo systemctl status jenkins | grep -i active

}

start
;;


	4)
restart()
{
	echo "Re-starting jenkins service"
	sudo systemctl restart jenkins
        echo -e "\e[33mJenkins Service Restarted\e[0m"	
}

restart
;;
	5)
status()
{
	echo "-----------Jenkins Status------------"
	sudo systemctl status jenkins | grep -i  active
}

status
;;


esac

