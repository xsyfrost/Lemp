#!/bin/bash

sudo sed -Ei "s/'username' \=> '([a-z\_]*)'/'username' => '$mysqlUser'/" ${cakephpDir}/config/app_local.php
sudo sed -Ei "s/'password' \=> '([a-z\_]*)'/'password' => '$mysqlPassword'/" ${cakephpDir}/config/app_local.php
sudo sed -Ei "s/'database' \=> '([a-z\_]*)'/'database' => '$mysqlDB'/" ${cakephpDir}/config/app_local.php

