#!/usr/bin/bash
#Prepare the tools for emory cbioportal automate process pipeline.
# Exit this script on any error.
set -euo pipefail
mv cbioportal cbioportal2
git clone https://github.com/cBioPortal/cbioportal.git
cd ~/.m2
mv repository repository2
cd ~/cbioportal
mvn -DskipTests clean install
sudo cp ~/cbioportal/portal/target/cbioportal-*.war $CATALINA_HOME/webapps/cbioportal.war
cd ~/cbioportal/core/src/main/scripts
python migrate_db.py --properties-file ~/cbioportal/src/main/resources/portal.properties --sql ~/cbioportal/db-scripts/src/main/resources/migration.sql
y 
sudo reboot
password

