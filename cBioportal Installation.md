Please check the below web link with the cBioportal database installation guidline.

https://github.com/maohuaxie/ETL-Tools-for-cBioportal-MySQL-database/new/master

Below are my comments might help you with your installation:

1) Java8 version is recommended for cBioportal database installtion, the following code will update your Java version to 8:

sudo apt-get -y autoremove

sudo add-apt-repository ppa:openjdk-r/ppa

sudo apt-get update

sudo apt-get install openjdk-8-jdk

sudo apt-get install openjdk-8-jre

https://www.oracle.com/java/index.html

get the java_home directory and set the java_home directory:

sudo update-alternatives --config java

2) Tomcat 7 is recommended for cBioportal database installtion. It will make the afterwards steps more easy.

3) Example for .bash_profile setup:

export CATALINA_HOME=/opt/tomcat

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre

export PORTAL_HOME=/home/maohuaxie/cbioportal

export PERL5LIB=/home/maohuaxie/perl/perl-5.22.2/lib/perl5:/home/maohuaxie/perl$

export PATH=/home/maohuaxie/perl/perl-5.22.2/bin:$PATH

export PATH=/home/maohuaxie/vep/samtools/bin:$PATH

4) In the "Add PORTAL_HOME to Tomcat" section: please change (export PORTAL_HOME= $CATALINA_HOME + "/webapps/cbioportal/WEB-INF/classes/") to (export PORTAL_HOME= "$CATALINA_HOME/webapps/cbioportal/WEB-INF/classes/") in order to address the error you may get.

5) when you get this error, you can try the following step to fix the error:
log4j:ERROR setFile(null,true) call failed.

java.io.FileNotFoundException: /opt/tomcat/logs/localhost.%d.log (Permission denied)

at java.io.FileOutputStream.open0(Native Method)

at java.io.FileOutputStream.open(FileOutputStream.java:270)

at java.io.FileOutputStream.<init>(FileOutputStream.java:213)

at java.io.FileOutputStream.<init>(FileOutputStream.java:133)

ls -lah /opt/tomcat/logs

ps -ef|grep httpd

ps -ef|grep tomcat

chmod 666 /opt/tomcat/logs

rm /opt/tomcat/logs/localhost.%d.log

cat /etc/passwd
