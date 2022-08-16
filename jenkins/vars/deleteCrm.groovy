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

def openstack('cycle') {
    print('delete andy openstack ')
//    echo "openstack delete start build result ${currentBuild.result}"
//    echo "delete openstack"
//    catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE', message: 'delete openstack failed') {
        build job: 'runTestcases', parameters: [
            string(name: 'Components', value: 'Automated, CRM, DeleteCloudlet'), 
            string(name: 'Project', value: params.Project), 
            string(name: 'Cycle', value: cycle), 
            string(name: 'MasterController', value: params.MasterController),
            string(name: 'TestTarget', value: 'Openstack'),
            string(name: 'VariableFile', value: params.VariableFile), 
            string(name: 'CRMPoolOpenstack', value: ''),
            string(name: 'NumberParallelExecutions', value: '10')]
//    }
}

def anthos('cycle') {
    print('delete anthos ')

//    echo "anthos delete start build result ${currentBuild.result}"
//    echo "delete anthos"
//    catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE', message: 'delete anthos failed') {
        build job: 'runTestcases', parameters: [
            string(name: 'Components', value: 'Automated, CRM, DeleteCloudlet'), 
            string(name: 'Project', value: params.Project), 
            string(name: 'Cycle', value: cycle), 
            string(name: 'MasterController', value: params.MasterController),
            string(name: 'TestTarget', value: 'Anthos'),
            string(name: 'VariableFile', value: params.VariableFile), 
            string(name: 'NumberParallelExecutions', value: '10')]
//    }
}

def fake('cycle') {
    print('delete fake ')
//    echo "fake delete start build result ${currentBuild.result}"
//    echo "delete fake"
//    catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE', message: 'delete fake failed') {
        build job: 'runTestcases', parameters: [
            string(name: 'Components', value: 'Automated, CRM, DeleteCloudlet'), 
            string(name: 'Project', value: params.Project), 
            string(name: 'Cycle', value: cycle), 
            string(name: 'MasterController', value: params.MasterController),
            string(name: 'TestTarget', value: 'Controller'),
            string(name: 'VariableFile', value: params.VariableFile), 
            string(name: 'NumberParallelExecutions', value: '10')]
//    }
}

