#!/bin/bash
# Program:
#       This program install web app
#
#Copyright (c) 2013 Intel Corporation.
#
#Redistribution and use in source and binary forms, with or without modification,
#are permitted provided that the following conditions are met:
#
#* Redistributions of works must retain the original copyright notice, this list
#  of conditions and the following disclaimer.
#* Redistributions in binary form must reproduce the original copyright notice,
#  this list of conditions and the following disclaimer in the documentation
#  and/or other materials provided with the distribution.
#* Neither the name of Intel Corporation nor the names of its contributors
#  may be used to endorse or promote products derived from this work without
#  specific prior written permission.
#
#THIS SOFTWARE IS PROVIDED BY INTEL CORPORATION "AS IS"
#AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
#ARE DISCLAIMED. IN NO EVENT SHALL INTEL CORPORATION BE LIABLE FOR ANY DIRECT,
#INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
#BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
#DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
#OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
#NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
#EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# Author:
#        Yin, Haichao <haichaox.yin@intel.com>
#


local_path=$(cd $(dirname $0);pwd)
source $local_path/Common
xpk_path=$local_path/../testapp
webAppTest="web_app_test"

# uninstall app first, and then install app
getPkgid $webAppTest
get_uninstall=`pkgcmd -u -n  $pkg_id -q`
pkgcmd -i -t wgt -p  $xpk_path/$webAppTest.wgt -q
getAppid $webAppTest
if [[ -n $app_id ]]; then
                echo "Install Pass"
        else
                echo "Install Fail"
                exit 1
fi

# launch app
getAppid $webAppTest
get_runing_status=`app_launcher -s $app_id`
if [[ "$get_runing_status" =~ "successfully" ]];then
  echo "webapp launch Pass!"
else
  echo "webapp launch Fail!"
  exit 1
fi
sleep 2

# check cache
myPath="/home/$TIZEN_USER/apps_rw/xwalk-service/Storage/ext/$app_id/def/GPUCache"
getPkgid $webAppTest
if [ ! -d $myPath ]; then 
     echo "Fail,webapp have not isolated storage cache file when runing"
     get_uninstall=`pkgcmd -u -n  $pkg_id -q`
     exit 1
  else
     echo "Pass,webapp have isolated storage storage cache file when runing"
     get_uninstall=`pkgcmd -u -n  $pkg_id -q`
     exit 0
fi


