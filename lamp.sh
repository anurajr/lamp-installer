#!/bin/bash
#--------------Anuraj--------------#
RED='\033[0;31m'
GRN='\033[0;32m' 
PRP='\033[0;35m'
NC='\033[0m'
clear
echo -e " "
echo -e "\t-------------------------------------"
echo -e "\t[${RED}          LAMP INSTALLER           ${NC}]"
echo -e "\t-------------------------------------"
echo -e " "
echo -ne "\tInternet Access \t:- "
	if ping -c 5 www.google.com  &> /dev/null ; then
		echo -e "${RED}YES${NC}"


echo -ne "\tInstalling Httpd \t:- "
	if	yum install httpd -y &> /dev/null; then
		echo -e "${RED}YES${NC}"
	else
		echo -e "${RED}NO${NC}"

	fi
echo -ne "\tInstalling Php \t\t:- "
	if	yum install php -y  &> /dev/null ; then
		echo -e "${RED}YES${NC}"
	else
		echo -e "${RED}NO${NC}"
	fi

echo -ne "\tInstalling Mysql \t:- "
	if	yum install mysql-server -y &> /dev/null; then
		echo -e "${RED}YES${NC}"
	else
		echo -e "${RED}NO${NC}"
	fi
pkill httpd &> /dev/null
	
echo -ne "\tStarting Httpd \t\t:- "
if /etc/init.d/httpd restart &> /dev/null ; then
	echo -e "${RED}YES${NC}"

		else 
			echo -e "${RED}NO${NC}"
fi

echo -ne "\tStarting Mysql \t\t:- "
if /etc/init.d/mysqld restart &> /dev/null ; then
	echo -e "${RED}YES${NC}"

		else 
			echo -e "${RED}NO${NC}"
fi

echo -ne "\tAdding to chkconfig \t:- "
chkconfig mysqld on &> /dev/null
chkconfig httpd on  &> /dev/null
echo -e "${RED}Done${NC}"
echo -e "\t-------------------------------------"
echo -e "\t     mysql secure installation"
echo -e "\t-------------------------------------"
read -p "        Enter Mysql root user password  :- "  PASS
mysql -e "UPDATE mysql.user SET Password = PASSWORD('${PASS}') WHERE User = 'root'"  &> /dev/null
mysql -e "DROP USER ''@'localhost'"  &> /dev/null
mysql -e "DROP USER ''@'$(hostname)'"  &> /dev/null
mysql -e "DROP DATABASE test"  &> /dev/null
mysql -e "FLUSH PRIVILEGES"  &> /dev/null

/etc/init.d/mysqld restart  &> /dev/null

echo -ne "\tRemoving Httpd Welcome page \t:- "

rm -rf /etc/httpd/conf.d/welcome.conf &> /dev/null
echo -e "${RED}Done${NC}"

echo -ne "\tCreating An index.php page \t:- "
cat > /var/www/html/index.php << eof
	<?php
	phpinfo();
	?>

eof

/etc/init.d/httpd restart &> /dev/null
/etc/init.d/mysqld restart &> /dev/null
echo -e "${RED}DONE${NC}"

echo " "
else 
	echo -e  "${RED}NO${NC}"
	echo -e " "
exit
fi


