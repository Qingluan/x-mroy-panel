#!/bin/bash

#  test_if_running.sh
#  Panel
#
#  Created by dr on 2019/3/18.
#  Copyright © 2019 dr. All rights reserved.

ps aux | grep "$1"
