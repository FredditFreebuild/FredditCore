#!/bin/bash

source ../.config/.env-database

LUCKPERMS_PREFIX="luckperms_"
LUCKPERMS_TABLES=("groups" "group_permissions" "group_users" "players" "user_permissions" "tracks", "actions")
COREPROTECT_PREFIX="co_"
COREPROTECT_TABLES=("block" "blockdata" "container" "containerdata" "entity" "entitydata" "explosions" "explosionsdata" "player" "playerdata" "session" "sessiondata" "sign" "signchanges")

# mysql << EOF
# CREATE DATABASE IF NOT EXISTS Freebuild;
# CREATE DATABASE IF NOT EXISTS Survival;

# CREATE USER IF NOT EXISTS '$FREEBUILD_COREPROTECT_USER'@'localhost' IDENTIFIED BY '$FREEBUILD_COREPROTECT_PASSWORD';
# $(for table in "${COREPROTECT_TABLES[@]}"; do echo "GRANT ALL PRIVILEGES ON Freebuild.$table TO '$FREEBUILD_COREPROTECT_USER'@'localhost';"; done)

# CREATE USER IF NOT EXISTS '$FREEBUILD_LUCKPERMS_USER'@'localhost' IDENTIFIED BY '$FREEBUILD_LUCKPERMS_PASSWORD';
# $(for table in "${LUCKPERMS_TABLES[@]}"; do echo "GRANT ALL PRIVILEGES ON Freebuild.$LUCKPERMS_PREFIX$table TO '$FREEBUILD_LUCKPERMS_USER'@'localhost';"; done)

# CREATE USER IF NOT EXISTS '$SURVIVAL_COREPROTECT_USER'@'localhost' IDENTIFIED BY '$SURVIVAL_COREPROTECT_PASSWORD';
# $(for table in "${COREPROTECT_TABLES[@]}"; do echo "GRANT ALL PRIVILEGES ON Survival.$table TO '$SURVIVAL_COREPROTECT_USER'@'localhost';"; done)

# CREATE USER IF NOT EXISTS '$SURVIVAL_LUCKPERMS_USER'@'localhost' IDENTIFIED BY '$SURVIVAL_LUCKPERMS_PASSWORD';
# $(for table in "${LUCKPERMS_TABLES[@]}"; do echo "GRANT ALL PRIVILEGES ON Survival.$LUCKPERMS_PREFIX$table TO '$SURVIVAL_LUCKPERMS_USER'@'localhost';"; done)
# EOF

# if $<SERVER>_COREPROTECT_USER exists, create & grant privileges

create_and_grant () {
  local server=$1
  local user=$2
  local password=$3
  local prefix=$4
  local tables=("${!5}")

  if [ -z $user ]; then
    echo "User for $server not found"
    return
  fi

  mysql << EOF
CREATE DATABASE IF NOT EXISTS $server;

CREATE USER IF NOT EXISTS '$user'@'localhost' IDENTIFIED BY '$password';
$(for table in "${tables[@]}"; do echo "GRANT ALL PRIVILEGES ON $server.$prefix$table TO '$user'@'localhost';"; done)
EOF

    echo "Created and granted privileges for $server with exit code $?"
}

create_and_grant "Freebuild" $FREEBUILD_COREPROTECT_USER $FREEBUILD_COREPROTECT_PASSWORD $COREPROTECT_PREFIX COREPROTECT_TABLES[@]
create_and_grant "Freebuild" $FREEBUILD_LUCKPERMS_USER $FREEBUILD_LUCKPERMS_PASSWORD $LUCKPERMS_PREFIX LUCKPERMS_TABLES[@]
create_and_grant "Survival" $SURVIVAL_COREPROTECT_USER $SURVIVAL_COREPROTECT_PASSWORD $COREPROTECT_PREFIX COREPROTECT_TABLES[@]
create_and_grant "Survival" $SURVIVAL_LUCKPERMS_USER $SURVIVAL_LUCKPERMS_PASSWORD $LUCKPERMS_PREFIX LUCKPERMS_TABLES[@]