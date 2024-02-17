# bridge-restore-2

run as user tomcat on the duracloud bridge

chkrestore.sh - main script, calls others

duraverify.sh - verifies chronopolis preservation content against duracloud content-properties.json

link.sh - creates symlinks in restoration directory to content in chronopolis preservation

inform.sh - informs bridge app that restoration directory is ready (aka complete)

watchdb.sh - watches for changes in the bridge db, not part of restoration process, but might be useful or interesting to a sysadmin

restorevars - required usernames, passwords, and values

```
# assumes mysql/mariadb and port 3306
DBHOST=lib-mariadb-dev
DBUSER=xxxx
DBPASS=xxxx
DBNAME=xxxx

STATUS=RETRIEVING_FROM_STORAGE

RESTORATIONS=/duracloud/content/restorations
CHRONOPOLIS=/scratch1/chronopolis-preservation

BRIDGE=duraclouddev-bridge.ucsd.edu
USER=xxxx
PASS=xxxx
```
