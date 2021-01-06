*** Settings ***
Documentation  UpdateTrustPolicy fail

Library  MexMasterController  mc_address=%{AUTOMATION_MC_ADDRESS}   root_cert=%{AUTOMATION_MC_CERT}
Library  String
     
Test Setup  Setup
Test Teardown  Cleanup Provisioning

*** Variables ***
${region}=  US
${developer}=  mobiledgex

${operator_name_fake}=  dmuus
${cloudlet_name_fake}=  tmocloud-1
${operator_name_azure}=  azure
${cloudlet_name_azure}=  automationAzureCentralCloudlet 
${operator_name_gcp}=   gcp 
${cloudlet_name_gcp}=  automationGcpCentralCloudlet

*** Test Cases ***
# ECQ-3032
UpdateTrustPolicy - update without region shall return error
   [Documentation]
   ...  - send UpdateTrustPolicy without region
   ...  - verify error is returned

   Run Keyword and Expect Error  ('code=400', 'error={"message":"no region specified"}')  Update Trust Policy  token=${token}  use_defaults=${False}

# ECQ-3033
UpdateTrustPolicy - update without token shall return error
   [Documentation]
   ...  - send UpdateTrustPolicy without token
   ...  - verify error is returned

   Run Keyword and Expect Error  ('code=400', 'error={"message":"no bearer token found"}')  Update Trust Policy  region=${region}  use_defaults=${False}

# ECQ-3034
UpdateTrustPolicy - update without parms shall return error
   [Documentation]
   ...  - send UpdateTrustPolicy with no parms 
   ...  - verify error is returned 

   Run Keyword and Expect Error  ('code=400', 'error={"message":"Policy key {} not found"}')  Update Trust Policy  region=${region}  token=${token}  use_defaults=${False}

# ECQ-3035
UpdateTrustPolicy - update without policy name shall return error
   [Documentation]
   ...  - send UpdateTrustPolicy with no policy name 
   ...  - verify error is returned

   Run Keyword and Expect Error  ('code=400', 'error={"message":"Policy key {\\\\"organization\\\\":\\\\"mobiledgex\\\\"} not found"}')  Update Trust Policy  operator_org_name=mobiledgex  region=${region}  token=${token}  use_defaults=${False}

# ECQ-3036
UpdateTrustPolicy - update with unknown org name shall return error
   [Documentation]
   ...  - send UpdateTrustPolicy with unknown org name
   ...  - verify error is returned

   Run Keyword and Expect Error  ('code=400', 'error={"message":"Policy key {\\\\"organization\\\\":\\\\"xxxx\\\\"} not found"}')  Update Trust Policy  operator_org_name=xxxx  region=${region}  token=${token}  use_defaults=${False}

# ECQ-3037
UpdateTrustPolicy - update without org name shall return error
   [Documentation]
   ...  - send UpdateTrustPolicy with no org name
   ...  - verify error is returned

   Run Keyword and Expect Error  ('code=400', 'error={"message":"Policy key {\\\\"name\\\\":\\\\"x\\\\"} not found"}')  Update Trust Policy  policy_name=x  region=${region}  token=${token}  use_defaults=${False}

# ECQ-3038
UpdateTrustPolicy - update without protocol shall return error
   [Documentation]
   ...  - send UpdateTrustPolicy without protocol
   ...  - verify error is returned

   ${name}=  Get Default Trust Policy Name

   Create Org

   &{rule1}=  Create Dictionary  protocol=icmp  remote_cidr=1.1.1.1/1
   &{rule2}=  Create Dictionary  protocol=tcp  port_range_minimum=1  port_range_maximum=2  remote_cidr=1.1.1.1/1
   @{rulelist}=  Create List  ${rule1}  #${rule2}
   Create Trust Policy  region=${region}  rule_list=${rulelist}

   &{rule_update}=  Create Dictionary  remote_cidr=2.1.1.1/1
   @{rulelist_update}=  Create List  ${rule_update}
   Run Keyword and Expect Error  ('code=400', 'error={"message":"Protocol must be one of: (tcp,udp,icmp)"}')   Update Trust Policy  region=${region}  rule_list=${rulelist_update}

   @{rulelist}=  Create List  ${rule1}  ${rule2}
   Create Trust Policy  region=${region}  policy_name=${name}_1  rule_list=${rulelist}
   Run Keyword and Expect Error  ('code=400', 'error={"message":"Protocol must be one of: (tcp,udp,icmp)"}')   Update Trust Policy  region=${region}  policy_name=${name}_1  rule_list=${rulelist_update}

# ECQ-3039
UpdateTrustPolicy - update with invalid CIDR shall return error 
   [Documentation]
   ...  - send UpdateTrustPolicy with invalid CIDR 
   ...  - verify error is returned

   Create Org

   &{rule}=  Create Dictionary  protocol=tcp  port_range_minimum=1  port_range_maximum=2  remote_cidr=1.1.1.1/1
   @{rulelist}=  Create List  ${rule}
   Create Trust Policy  region=${region}  rule_list=${rulelist}

   &{rule}=  Create Dictionary  protocol=tcp  port_range_minimum=1  remote_cidr=x 
   @{rulelist}=  Create List  ${rule}
   Run Keyword and Expect Error  ('code=400', 'error={"message":"Invalid CIDR address: x"}')  Update Trust Policy  region=${region}  token=${token}  rule_list=${rulelist} 

   &{rule}=  Create Dictionary  protocol=tcp  port_range_minimum=1  remote_cidr=1.1.1.1 
   @{rulelist}=  Create List  ${rule}
   Run Keyword and Expect Error  ('code=400', 'error={"message":"Invalid CIDR address: 1.1.1.1"}')  Update Trust Policy  region=${region}  token=${token}  rule_list=${rulelist} 

   &{rule}=  Create Dictionary  protocol=tcp  port_range_minimum=1  remote_cidr=256.1.1.1/1
   @{rulelist}=  Create List  ${rule}
   Run Keyword and Expect Error  ('code=400', 'error={"message":"Invalid CIDR address: 256.1.1.1/1"}')  Update Trust Policy  region=${region}  token=${token}  rule_list=${rulelist}

   &{rule}=  Create Dictionary  protocol=tcp  port_range_minimum=1  remote_cidr=1.1.1.1/33
   @{rulelist}=  Create List  ${rule}
   Run Keyword and Expect Error  ('code=400', 'error={"message":"Invalid CIDR address: 1.1.1.1/33"}')  Update Trust Policy  region=${region}  token=${token}  rule_list=${rulelist}

   &{rule}=  Create Dictionary  protocol=tcp  port_range_minimum=1
   @{rulelist}=  Create List  ${rule}
   Run Keyword and Expect Error  ('code=400', 'error={"message":"Invalid CIDR address: "}')  Update Trust Policy  region=${region}  token=${token}  rule_list=${rulelist}

# ECQ-3040
UpdateTrustPolicy - update with invalid minport shall return error
   [Documentation]
   ...  - send UpdateTrustPolicy with invalid min port 
   ...  - verify error is returned

   Create Org

   &{rule}=  Create Dictionary  protocol=tcp  port_range_minimum=1  port_range_maximum=2  remote_cidr=1.1.1.1/1
   &{rule2}=  Create Dictionary  protocol=tcp  port_range_minimum=1  port_range_maximum=2  remote_cidr=1.1.1.1/1

   @{rulelist}=  Create List  ${rule}  ${rule2}
   Create Trust Policy  region=${region}  rule_list=${rulelist}

   &{rule}=  Create Dictionary  protocol=tcp
   @{rulelist}=  Create List  ${rule}
   Run Keyword and Expect Error  ('code=400', 'error={"message":"Invalid min port range: 0"}')  Update Trust Policy  region=${region}  token=${token}  rule_list=${rulelist}

   &{rule}=  Create Dictionary  protocol=udp  port_range_minimum=0  remote_cidr=1.1.1.1/1 
   @{rulelist}=  Create List  ${rule}
   Run Keyword and Expect Error  ('code=400', 'error={"message":"Invalid min port range: 0"}')  Update Trust Policy  region=${region}  token=${token}  rule_list=${rulelist} 

   &{rule}=  Create Dictionary  protocol=udp  port_range_minimum=x  remote_cidr=1.1.1.1/1 
   @{rulelist}=  Create List  ${rule}
   ${error}=  Run Keyword and Expect Error  *   Update Trust Policy  region=${region}  token=${token}  rule_list=${rulelist}
   Should Contain  ${error}  ('code=400', 'error={"message":"Invalid data: code=400, message=Unmarshal type error: expected=uint32, got=string, field=TrustPolicy.outbound_security_rules.port_range_min, offset

   &{rule}=  Create Dictionary  protocol=udp  port_range_minimum=-1  remote_cidr=1.1.1.1/1 
   @{rulelist}=  Create List  ${rule}
   ${error}=  Run Keyword and Expect Error  *   Update Trust Policy  region=${region}  token=${token}  rule_list=${rulelist}
   Should Contain  ${error}  ('code=400', 'error={"message":"Invalid data: code=400, message=Unmarshal type error: expected=uint32, got=number -1, field=TrustPolicy.outbound_security_rules.port_range_min, offset

   &{rule}=  Create Dictionary  protocol=udp  port_range_minimum=65536  remote_cidr=1.1.1.1/1 
   @{rulelist}=  Create List  ${rule}
   Run Keyword and Expect Error  ('code=400', 'error={"message":"Invalid min port range: 65536"}')  Update Trust Policy  region=${region}  token=${token}  rule_list=${rulelist} 

# ECQ-3041
UpdateTrustPolicy - update with invalid maxport shall return error
   [Documentation]
   ...  - send UpdateTrustPolicy with invalid max port
   ...  - verify error is returned

   Create Org

   &{rule}=  Create Dictionary  protocol=tcp  port_range_minimum=1  port_range_maximum=2  remote_cidr=1.1.1.1/1
   @{rulelist}=  Create List  ${rule}
   Create Trust Policy  region=${region}  rule_list=${rulelist}

   &{rule}=  Create Dictionary  protocol=udp  port_range_minimum=1  port_range_maximum=x  remote_cidr=1.1.1.1/1 
   @{rulelist}=  Create List  ${rule}
   ${error}=  Run Keyword and Expect Error  *   Update Trust Policy  region=${region}  token=${token}  rule_list=${rulelist}
   Should Contain  ${error}  ('code=400', 'error={"message":"Invalid data: code=400, message=Unmarshal type error: expected=uint32, got=string, field=TrustPolicy.outbound_security_rules.port_range_max, offset

   &{rule}=  Create Dictionary  protocol=udp  port_range_minimum=1  port_range_maximum=-1  remote_cidr=1.1.1.1/1 
   @{rulelist}=  Create List  ${rule}
   ${error}=  Run Keyword and Expect Error  *   Update Trust Policy  region=${region}  token=${token}  rule_list=${rulelist}
   Should Contain  ${error}  ('code=400', 'error={"message":"Invalid data: code=400, message=Unmarshal type error: expected=uint32, got=number -1, field=TrustPolicy.outbound_security_rules.port_range_max, offset

   &{rule}=  Create Dictionary  protocol=udp  port_range_minimum=1  port_range_maximum=65536  remote_cidr=1.1.1.1/1 
   @{rulelist}=  Create List  ${rule}
   Run Keyword and Expect Error  ('code=400', 'error={"message":"Invalid max port range: 65536"}')  Update Trust Policy  region=${region}  token=${token}  rule_list=${rulelist} 

# ECQ-3042
UpdateTrustPolicy - update with icmp and port range shall return error
   [Documentation]
   ...  - send UpdateTrustPolicy with icmp and port range
   ...  - verify error is returned

   Create Org

   &{rule}=  Create Dictionary  protocol=tcp  port_range_minimum=1  port_range_maximum=2  remote_cidr=1.1.1.1/1
   @{rulelist}=  Create List  ${rule}
   Create Trust Policy  region=${region}  rule_list=${rulelist}

   &{rule}=  Create Dictionary  protocol=icmp  port_range_minimum=10  port_range_maximum=0  remote_cidr=1.1.1.1/1 
   @{rulelist}=  Create List  ${rule}
   Run Keyword and Expect Error  ('code=400', 'error={"message":"Port range must be empty for icmp"}')  Update Trust Policy  region=${region}  token=${token}  rule_list=${rulelist} 

   &{rule}=  Create Dictionary  protocol=icmp  port_range_minimum=10  remote_cidr=1.1.1.1/1 
   @{rulelist}=  Create List  ${rule}
   Run Keyword and Expect Error  ('code=400', 'error={"message":"Port range must be empty for icmp"}')  Update Trust Policy  region=${region}  token=${token}  rule_list=${rulelist} 

   &{rule}=  Create Dictionary  protocol=icmp  port_range_maximum=10  remote_cidr=1.1.1.1/1 
   @{rulelist}=  Create List  ${rule}
   Run Keyword and Expect Error  ('code=400', 'error={"message":"Port range must be empty for icmp"}')  Update Trust Policy  region=${region}  token=${token}  rule_list=${rulelist} 

   &{rule}=  Create Dictionary  protocol=icmp  port_range_minimum=0  port_range_maximum=10  remote_cidr=1.1.1.1/1 
   @{rulelist}=  Create List  ${rule}
   Run Keyword and Expect Error  ('code=400', 'error={"message":"Port range must be empty for icmp"}')  Update Trust Policy  region=${region}  token=${token}  rule_list=${rulelist} 

# ECQ-3043
UpdateTrustPolicy - update with minport>maxport shall return error
   [Documentation]
   ...  - send UpdateTrustPolicy with minport>maxport
   ...  - verify error is returned

   Create Org

   &{rule}=  Create Dictionary  protocol=tcp  port_range_minimum=1  port_range_maximum=2  remote_cidr=1.1.1.1/1
   @{rulelist}=  Create List  ${rule}
   Create Trust Policy  region=${region}  rule_list=${rulelist}

   &{rule}=  Create Dictionary  protocol=udp  port_range_minimum=10  port_range_maximum=1  remote_cidr=1.1.1.1/1 
   @{rulelist}=  Create List  ${rule}
   Run Keyword and Expect Error  ('code=400', 'error={"message":"Min port range: 10 cannot be higher than max: 1"}')  Update Trust Policy  region=${region}  token=${token}  rule_list=${rulelist} 

   &{rule}=  Create Dictionary  protocol=tcp  port_range_minimum=10  port_range_maximum=1  remote_cidr=1.1.1.1/1
   @{rulelist}=  Create List  ${rule}
   Run Keyword and Expect Error  ('code=400', 'error={"message":"Min port range: 10 cannot be higher than max: 1"}')  Update Trust Policy  region=${region}  token=${token}  rule_list=${rulelist}

# ECQ-3044
UpdateTrustPolicy - update with policy not found shall return error
   [Documentation]
   ...  - send UpdateTrustPolicy with a policy that does not exist 
   ...  - verify error is returned

   ${name}=  Get Default Trust Policy Name
   ${org}=   Get Default Operator Name

   &{rule}=  Create Dictionary  protocol=udp  port_range_minimum=10  port_range_maximum=1  remote_cidr=1.1.1.1/1
   @{rulelist}=  Create List  ${rule}
   Run Keyword and Expect Error  ('code=400', 'error={"message":"Policy key {\\\\"organization\\\\":\\\\"${org}\\\\",\\\\"name\\\\":\\\\"${name}\\\\"} not found"}')  Update Trust Policy  region=${region}  token=${token}  rule_list=${rulelist}

*** Keywords ***
Setup
   ${token}=  Get Super Token
   Set Suite Variable  ${token}
