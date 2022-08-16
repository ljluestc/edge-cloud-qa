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

def openstack('cycle') {
    print('create openstack ')
    build job: 'runTestcases', parameters: [
        string(name: 'Components', value: 'Automated, CRM, CreateCloudlet'), 
        string(name: 'Project', value: params.Project), 
        string(name: 'Cycle', value: cycle), 
        string(name: 'MasterController', value: params.MasterController),
        string(name: 'TestTarget', value: 'Openstack'),
        string(name: 'VariableFile', value: params.VariableFile), 
        string(name: 'CRMPool', value: params.CRMPoolOpenstack),
        string(name: 'NumberParallelExecutions', value: '10')]
}

def anthos('cycle') {
    print('create anthos ')
    build job: 'runTestcases', parameters: [
        string(name: 'Components', value: 'Automated, CRM, CreateCloudlet'), 
        string(name: 'Project', value: params.Project), 
        string(name: 'Cycle', value: cycle), 
        string(name: 'MasterController', value: params.MasterController),
        string(name: 'TestTarget', value: 'Anthos'),
        string(name: 'VariableFile', value: params.VariableFile), 
        string(name: 'NumberParallelExecutions', value: '10')]
}

def fake('cycle') {
    print('create fake ')
    build job: 'runTestcases', parameters: [
        string(name: 'Components', value: 'Automated, CRM, CreateCloudlet'), 
        string(name: 'Project', value: params.Project), 
        string(name: 'Cycle', value: cycle), 
        string(name: 'MasterController', value: params.MasterController),
        string(name: 'TestTarget', value: 'Controller'),
        string(name: 'VariableFile', value: params.VariableFile), 
        string(name: 'NumberParallelExecutions', value: '10')]
}

def upgrade(cycle, dateValue) {
    print('upgrade cloudlets')
//    dir('go/src/github.com/mobiledgex/edge-cloud-infra') {
//        sh 'rm -rf $WORKSPACE/go/src/github.com/mobiledgex/edge-cloud-infra/*'
//        checkout([$class: 'GitSCM',
//            branches: [[name: 'master']],
//            doGenerateSubmoduleConfigurations: false,
//            extensions: [
//                [$class: 'SparseCheckoutPaths',  sparseCheckoutPaths:[[$class:'SparseCheckoutPath', path:'chef/*']
//                ]]
//            ],
//            submoduleCfg: [],
//            userRemoteConfigs: [[credentialsId: gitcred,
//            url: 'https://github.com/mobiledgex/edge-cloud-infra.git']]])
//    }

    build job: 'runTestcases', parameters: [
        string(name: 'Components', value: 'Automated, CRM, UpgradeCloudlet'),
        string(name: 'Project', value: params.Project),
        string(name: 'Cycle', value: cycle),
        string(name: 'MasterController', value: params.MasterController),
        string(name: 'TestTarget', value: 'Openstack'),
        string(name: 'VariableFile', value: params.VariableFile),
        string(name: 'CRMUpgradeVersion', value: dateValue),
        string(name: 'NumberParallelExecutions', value: '10')]
}

def createUpgrade(cycle, dateValue) {
    parallel (
        'Create Openstack' : {
            openstack('cycle')
        },
        'Create Anthos': {
            anthos('cycle')
        },
        'Create Fake': {
            fake('cycle')
        },
        'Upgrade Cloudlets': {
            upgrade(cycle, dateValue)
        }
    )
}

def createUpgradeCheck(create_cloudlet_status) {
    println("create_cloudlet_status status=${create_cloudlet_status}")
    if(create_cloudlet_status == false) {
        slackMessage.warning('Create/Upgrade CRMs Failed. Waiting for input')
        input message: 'Create/Upgrade CRMs failed. Continue?'
        slackMessage.good('Regression proceeding')
    }
}

