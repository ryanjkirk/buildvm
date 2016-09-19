#!/usr/bin/env bash
# creates a CHM VM environment
set -euo pipefail

function usage {
cat << EOF
This script does not take parameters. Instead, supply vars in the supplied
newenv_configvars.yml which must be in CWD.
EOF
exit 0 
}

if [[ -n $* ]]; then
  usage
fi

serverclasses=(api bbx ebm exp img load mta nfs pref puppet qbs red ttb tt web)

export ANSIBLE_HOST_KEY_CHECKING=False
timestamp=`date "+%Y%m%d-%H%M"`
invfile="hosts.${timestamp}"

# ghetto method of parsing yaml dict to shell env vars
source <(sed -e 's/:[^:\/\/]/="/g;s/$/"/g;s/ *=/=/g' newenv_configvars.yml | grep "^[a-z]")

echo "Datacenter/environment is ${dc}${envtype}${envnumber}"

for serverclass in ${serverclasses[*]}; do
    newvmhostname="${dc}${envtype}${envnumber}v${serverclass}01"
    printf "Building ${newvmhostname}..."
#   ansible-playbook createvm.yml -i localhost, --extra-vars "@newenv_configvars.yml" --extra-vars="newvmhostname=$newvmhostname folder="${envtype}${envnumber}""
    echo "$newvmhostname" >> $invfile
    printf 'done!\n'
done

ansible-playbook newenv_postbuild.yml -i $invfile --ask-pass

rm $invfile
