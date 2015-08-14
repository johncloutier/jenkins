#! /bin/bash
export SHELL=/bin/sh

# Parse a support-core plugin -style txt file as specification for jenkins plugins to be installed
# in the reference directory, so user can define a derived Docker image with just :
#
# FROM jenkins
# COPY plugins.txt /plugins.txt
# RUN /usr/local/bin/plugins.sh /plugins.txt
#

set -e

declare -a cmds
declare -i cmd_ctr=0

REF=plugins
JENKINS_UC_DOWNLOAD=https://updates.jenkins-ci.org/download
mkdir -p $REF


while read spec || [ -n "$spec" ]; do
    plugin=(${spec//:/ });
    [[ ${plugin[0]} =~ ^# ]] && continue
    [[ ${plugin[0]} =~ ^\s*$ ]] && continue
    [[ -z ${plugin[1]} ]] && plugin[1]="latest"
    cmds[$cmd_ctr]="curl -L -f ${JENKINS_UC_DOWNLOAD}/plugins/${plugin[0]}/${plugin[1]}/${plugin[0]}.hpi -o $REF/${plugin[0]}.jpi"
    cmd_ctr=$[cmd_ctr + 1]
done  < $1

parallel -j 0 --eta ::: "${cmds[@]}"
