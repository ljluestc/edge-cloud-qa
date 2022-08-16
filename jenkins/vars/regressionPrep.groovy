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

def regressionPrep1(dateValue, cycle) {
    try {
    parallel (
        'Create Cycle': {
//            steps {
//                script {
//                    dateValue = determineDateValue()
//                    cycle = dateValue + '_' + params.Version
//                    currentBuild.displayName = cycle
//                    slackMessage.good('Starting regression for ' + cycle)
//                    checkLoadExists(dateValue)
                    createCycle('cycle')
                    addTestsToFolder(params.Version, params.Project, cycle)
//                }
//            }
        },
        'Cleanup/Defrag': {
//            steps{
//                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE', message: 'cleanup provisioning failed') {
                      build job: 'cleanupAutomationProvisioning'
//                    script {
                        defragEtcd()
//                    }
//                }
//            }
        },
        'Deploy Chef': {
            if(params.RunDeploy == true) {
                deployChef(dateValue)
            } else {
                println("skipping Deploy Chef since RunDeploy=${params.RunDeploy}")
            }
        },
        'Pull Image': {
            pullImage(dateValue)
        } 
//        'Delete Openstack': {
//            if(params.RunDeploy == true) {
//                deleteCrm.openstack('cycle')
//            } else {
//                println("skipping Delete Openstack since RunDeploy=${params.RunDeploy}")
//            }
//
//        },
//        'Delete Anthos': {
//            if(params.RunDeploy == true) {
//                deleteCrm.anthos('cycle')
//            } else {
//                println("skipping Delete Anthos since RunDeploy=${params.RunDeploy}")
//            }
//        },
//        'Delete Fake': {
//            if(params.RunDeploy == true) {
//                deleteCrm.fake('cycle')
//            } else {
//                println("skipping Delete Fake since RunDeploy=${params.RunDeploy}")
//            }
//        }
    )
    } catch(e) {
//    post {
//        failure {
//            script {
//                slackMessage.fail("Load check failed or create cycle failed for " + dateValue + ':' + e + '. Aborting')
                //error('regressionprep 1 failed in parallel try/catch')
                  throw new Exception("regressionprep 1 failed in parallel try/catch")
//            }
//        }
//    }
}
}

def regressionPrep2(dateValue, cycle) {
    try {
    parallel (
//        stage('Deploy Chef') {
//            when { expression { params.RunDeploy == true } }
//            steps {
//                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE', message: 'deploy chef failed') {
//                    script { deployChef(dateValue) }
//                }
//            }
//        }
//
//        stage('Pull Image') {
//            steps {
//                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE', message: 'pull image failed') {
//                    script { pullImage(dateValue) }
//                }
//            }
//        }

        'Delete Openstack': {
            if(params.RunDeploy == true) {
                deleteCrm.openstack('cycle')
            } else {
                println("skipping Delete Openstack since RunDeploy=${params.RunDeploy}")
            }

        },
        'Delete Anthos': {
            if(params.RunDeploy == true) {
                deleteCrm.anthos('cycle')
            } else {
                println("skipping Delete Anthos since RunDeploy=${params.RunDeploy}")
            }
        },
        'Delete Fake': {
            if(params.RunDeploy == true) {
                deleteCrm.fake('cycle')
            } else {
                println("skipping Delete Fake since RunDeploy=${params.RunDeploy}")
            }
        }
    )
    } catch (e) { 
        error('regressionprep 2 failed in parallel try/catch')
        throw new Exception("regressionprep 2 failed in parallel try/catch")


//    post {
//        failure {
//            script {
//                currentBuild.result = 'SUCCESS'
//                 echo "SSSUUUUCCCCEEEESSS"
                 regression_prep_status = false
//            }
//        }
//        success {
//            script { slackMessage.good('Regression Prep successfull') }
//        }
//    }
}
}

def regressionPrepCheck(regression_prep_status) {
//    steps {
//        script {
            println("regressionprepcheck status=${regression_prep_status}")
            if(regression_prep_status == false) {
                slackMessage.warning('Regression Prep Failed. Waiting for input')
                input message: 'Regression Prep failed. Continue?'
                slackMessage.good('Regression proceeding')
                currentBuild.result = 'SUCCESS'
                echo "SSSUUUUCCCCEEEESSS22222"
            }
//        }
//    }
}
