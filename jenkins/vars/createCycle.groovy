// Copyright 2022 MobiledgeX, Inc
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import groovy.transform.Field

@Field gitcred = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'

def call('cycle') {
    dir('go/src/github.com/mobiledgex') {
        checkout([$class: 'GitSCM',
            branches: [[name: 'master']],
            doGenerateSubmoduleConfigurations: false,
            extensions: [
                [$class: 'SparseCheckoutPaths',  sparseCheckoutPaths:[
                [$class:'SparseCheckoutPath', path:'jenkins/*'],
                [$class:'SparseCheckoutPath', path:'modules/*'],
                ]]
            ],
            submoduleCfg: [],
            userRemoteConfigs: [[credentialsId: gitcred,
            url: 'https://github.com/mobiledgex/edge-cloud-qa.git']]])
    }

    dir('go/src/github.com/mobiledgex/jenkins') {
        def add_pre = 'export PYTHONPATH=$WORKSPACE/go/src/github.com/mobiledgex/modules;./createCycleAddTestcases.py --version ' + params.Version + ' --project ' + params.Project + ' --cycle ' + cycle

        sh add_pre
    }
}

