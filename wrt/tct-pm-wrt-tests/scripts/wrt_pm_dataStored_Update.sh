#!/bin/bash
#
# Copyright (C) 2013 Intel Corporation
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# * Redistributions of works must retain the original copyright notice, this list
#   of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the original copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
# * Neither the name of Intel Corporation nor the names of its contributors
#   may be used to endorse or promote products derived from this work without
#   specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY INTEL CORPORATION "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL INTEL CORPORATION BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
# OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
# EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# Authors:
#        Yue, jianhui <jianhuix.a.yue@intel.com>

source $(dirname $0)/Common
uninstall_app widget-version-1
func_install_changename widget-version-1.wgt
if [ $? -eq 1 ];then
  echo "The installation is failed"
  exit 1
fi

func_launch widget-version.wgt
if [ $? -eq 1 ];then
  echo "The launch is failed"
  func_uninstall_changename widget-version-1.wgt
  exit 1
fi

find_appid widget-version
mkdir /home/$TIZEN_USER/apps_rw/xwalk-service/applications/$appids/data
myPath="/home/$TIZEN_USER/apps_rw/xwalk-service/applications/$appids/data"
if [ ! -d $myPath ];then
  echo -e  "created folder data failed!"
  exit 1
fi

func_install_changename widget-version-1-1.wgt
if [ $? -eq 1 ];then
  echo "The installation is failed"
  func_uninstall_changename widget-version-1.wgt
  exit 1
fi

if [ -d $myPath ];then
  echo -e  "the case is fail because the folder data exist!"
  exit 1
else
  echo -e  "the case is pass because the folder data dose not exist!"
  func_uninstall_changename widget-version-1.wgt
  func_uninstall_changename widget-version-1-1.wgt
  echo "The two widgets are uninstalled successfully"
  exit 0
fi
