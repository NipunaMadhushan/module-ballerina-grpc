#!/bin/bash -e
# Copyright 2021 WSO2 Inc. (http://wso2.org)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ----------------------------------------------------------------------------
# Execution script for ballerina performance tests
# ----------------------------------------------------------------------------
set -e
source base-scenario.sh

echo "----------Running load tests----------"
./ghz --insecure --proto $scriptsDir/route_guide.proto --duration 6s --concurrency $concurrent_users --duration-stop wait --call routeguide.RouteGuide.GetFeature -d '{"latitude": 406109563, "longitude": -742186778}' bal.perf.test:80 -O csv > $scriptsDir/ghz_output.csv
tail -50f $scriptsDir/ghz_output.csv