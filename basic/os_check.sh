#!/usr/bin/env bash

#==
#== this script is used to check os distribution/version/codename(eg: Ubuntu 12.10 quantal)
#==

:<<BLOCK
add the below line after #! declare line to import this shell:
. `pwd`/os_check.sh

sample code:
#!/usr/bin/env bash

. `pwd`/os_check.sh
echo $os_name

if is_centos
then
    echo 'it is centos!'
else
    echo 'it is NOT centos!'
fi
BLOCK

os_name=""
os_version=""
os_code=""

#check if lsb_release command is avaliable
which lsb_release >> /dev/null 2>&1
if [ $? -eq 0 ]
then
    os_name=`lsb_release -si`
    os_version=`lsb_release -sr`
    os_code=`lsb_release -sc`
else
    releaseFile="/etc/redhat-release"
    if [ -f "$releaseFile" ]
    then
        os_name=`cat $releaseFile | cut -d " " -f1`
        os_version=`cat $releaseFile | cut -d " " -f3`
        os_code=`cat $releaseFile | cut -d " " -f4`
    fi
fi

#echo $os_name $os_version $os_code

function is_centos() {
    if [ "CentOS" == $os_name ]    
    then
        return 0
    else
        return 1
    fi
}
