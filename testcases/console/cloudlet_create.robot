*** Settings ***
Documentation   Create new cloudlet

Library		MexConsole  url=%{AUTOMATION_CONSOLE_ADDRESS}
Library         MexMasterController  %{AUTOMATION_MC_ADDRESS}  %{AUTOMATION_MC_CERT}
Library         DateTime

Test Setup      Setup
Test Teardown   Close Browser

Test Timeout    20 minutes

*** Variables ***
${browser}           Chrome
${console_username}  mexadmin
${console_password}  mexadminfastedgecloudinfra

*** Test Cases ***
WebUI - user shall be able to create a new EU cloudlet
    [Documentation]
    ...  Create a new EU cloudlet
    ...  Verify cloudlet shows in list
    [Tags]  passing

    Open Cloudlets

    #Get Table Data

    Add New Cloudlet  region=EU  physical_name=hawkins  platform_type=Openstack  operator=GDDT  cloudlet_name=${cloudlet_name}

    FOR  ${x}  IN RANGE  0  60
        ${cloudlet_state}=    Show Cloudlets  region=EU  cloudlet_name=${cloudlet_name}  operator_org_name=GDDT
        Exit For Loop If  '${cloudlet_state[0]['data']['state']}' == '5'
        Sleep  10s
    END

    Change Number Of Rows
    Cloudlet Should Exist  cloudlet_name=${cloudlet_name}

    ${cloudlet_details}=    Show Cloudlets  region=EU  cloudlet_name=${cloudlet_name}  operator_org_name=GDDT
    ${time}=  Set Variable  ${cloudlet_details[0]['data']['created_at']['seconds']}
    Log to Console  ${time}
    ${timestamp}=  Convert Date  ${time}  exclude_millis=yes
    Log to Console  ${timestamp}

    ${details}=  Open Cloudlet Details
    Log to Console  ${details}
    Should Be Equal   ${details['Created']}   ${timestamp}
    Close Cloudlet Details

    Search Cloudlet
    MexConsole.Delete Cloudlet  cloudlet_name=${cloudlet_name}
    Sleep  30s
    Cloudlet Should Not Exist  cloudlet_name=${cloudlet_name}

WebUI - user shall be able to create a new US cloudlet
    [Documentation]
    ...  Create a new US cloudlet
    ...  Verify cloudlet shows in list
    [Tags]  passing

    Open Cloudlets
    Add New Cloudlet  region=US  operator=packet  physical_name=packet2  platform_type=Openstack  cloudlet_name=${cloudlet_name}

    FOR  ${x}  IN RANGE  0  60
        ${cloudlet_state}=    Show Cloudlets  region=US  cloudlet_name=${cloudlet_name}  operator_org_name=packet
        Exit For Loop If  '${cloudlet_state[0]['data']['state']}' == '5'
        Sleep  10s
    END

    Change Number Of Rows
    Cloudlet Should Exist  cloudlet_name=${cloudlet_name}

    Sleep  5s

    Search Cloudlet
    MexConsole.Delete Cloudlet  cloudlet_name=${cloudlet_name}
    Sleep  30s
    Cloudlet Should Not Exist  cloudlet_name=${cloudlet_name}

WebUI - user shall be able to create a cloudlet with trust policy
    [Documentation]
    ...  Create a cloudlet with trust policy
    ...  Verify cloudlet shows in list
    [Tags]  passing

    Open Cloudlets

    Add New Cloudlet  region=EU  physical_name=hawkins  platform_type=Openstack  operator=GDDT  cloudlet_name=${cloudlet_name}  trust_policy=automation_trust_policy

    FOR  ${x}  IN RANGE  0  60
        ${cloudlet_state}=    Show Cloudlets  region=EU  cloudlet_name=${cloudlet_name}  operator_org_name=GDDT
        Exit For Loop If  '${cloudlet_state[0]['data']['state']}' == '5'
        Sleep  10s
    END

    Should Be Equal  ${cloudlet_state[0]['data']['trust_policy']}   automation_trust_policy
    Change Number Of Rows
    Cloudlet Should Exist  cloudlet_name=${cloudlet_name}

    ${cloudlet_details}=    Show Cloudlets  region=EU  cloudlet_name=${cloudlet_name}  operator_org_name=GDDT
    ${time}=  Set Variable  ${cloudlet_details[0]['data']['created_at']['seconds']}
    Log to Console  ${time}
    ${timestamp}=  Convert Date  ${time}  exclude_millis=yes
    Log to Console  ${timestamp}

    ${details}=  Open Cloudlet Details
    Log to Console  ${details}
    Should Be Equal   ${details['Created']}   ${timestamp}
    Should Be Equal   ${details['Trust Policy']}  automation_trust_policy
    Close Cloudlet Details

    Search Cloudlet
    MexConsole.Delete Cloudlet  cloudlet_name=${cloudlet_name}
    Sleep  30s
    Cloudlet Should Not Exist  cloudlet_name=${cloudlet_name}

*** Keywords ***
Setup
    ${token}=  Get Supertoken
    ${epoch}=  Get Time  epoch
    ${cloudlet_name}=  Get Default Cloudlet Name
    Log to Console  Cloudlet name =  ${cloudlet_name}
    Open Browser
    Login to Mex Console  browser=${browser}  #username=${console_username}  password=${console_password}
    Open Compute
    Set Suite Variable  ${token}
    Set Suite Variable  ${cloudlet_name}
