#!/usr/bin/env bash

set -x

CUR_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

CONTRIBUTORS_FILE=${CONTRIBUTORS_FILE=$CUR_DIR/StorageSystemContributors.generated.cpp}

git shortlog --summary | perl -lnE 's/^\s+\d+\s+(.+)/"$1",/; next unless $1; say $_' > $CONTRIBUTORS_FILE.tmp

# If git history not available - dont make target file
if [ ! -s $CONTRIBUTORS_FILE.tmp ]; then
    echo Empty result of git shortlog
    git status
    exit
fi

echo "// autogenerated by $0"             >  $CONTRIBUTORS_FILE
echo "const char * auto_contributors[] {" >> $CONTRIBUTORS_FILE
cat  $CONTRIBUTORS_FILE.tmp               >> $CONTRIBUTORS_FILE
echo "nullptr };"                         >> $CONTRIBUTORS_FILE

echo "Collected `cat $CONTRIBUTORS_FILE.tmp | wc -l` contributors."
rm $CONTRIBUTORS_FILE.tmp
