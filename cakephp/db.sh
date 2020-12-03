#!/bin/bash

sudo sed -i "s/'username' => 'my_app'/'username' => '$mysqlUser'/" ${cakephpDir}/config/app_local.php
sudo sed -i "s/'password' => 'secret'/'password' => '$mysqlPassword'/" ${cakephpDir}/config/app_local.php
sudo sed -i "s/'database' => 'my_app'/'database' => '$mysqlDB'/" ${cakephpDir}/config/app_local.php

