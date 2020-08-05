*** Settings ***
Documentation   showDevice - request shall return devices for non-platos apps

Library  MexDmeRest     dme_address=%{AUTOMATION_DME_REST_ADDRESS}  root_cert=%{AUTOMATION_DME_CERT}
Library  MexMasterController  mc_address=%{AUTOMATION_MC_ADDRESS}  root_cert=%{AUTOMATION_MC_CERT}

Test Setup	Setup
Test Teardown	Cleanup provisioning

*** Variables ***
${platos_app_name}  NotplatosEnablingLayer2
${developer_name}  MobiledgeX 
${platos_org}  platos
${region}  US

${platos_s20_type}=  platos:SM-G988U:platosEnablingLayer
${platos_s6_type}=  platos:SAMSUNG-SM-G920A:HASHED_ID
${platos_s6_id}=  01dddc962bbf0ddedcd32c70caf39b50dfb045ace735bafde9c6fb1540ebe61b76f659250bd81fc441abaafd0f7371d7897410077038a29a14151c0b836176aa

*** Test Cases ***
#ECQ-2295
showDevice - request for non-platos app with uuidtype=platos shall return device information
    [Documentation]
    ...  registerClient with non-platos app with unique_id and type=platos
    ...  verify showDevice returns all information supported
    ...  key.uniqueidtype key.uniqueid firstseen.seconds firstseen.nanos lastseen.seconds lastseen.nanos and notify_id

      ${epoch}=  Get Time  epoch

      Register Client  developer_org_name=${developer_name}  app_name=${platos_app_name}  unique_id=${epoch}  unique_id_type=${platos_org} 

      ${device}=  Show Device  region=${region}  unique_id=${epoch}  unique_id_type=${platos_org}  

      Should Be Equal  ${device['data']['key']['unique_id_type']}  ${platos_org} 
      Should Be Equal As Numbers  ${device['data']['key']['unique_id']}  ${epoch} 
      Should Be True   ${device['data']['first_seen']['seconds']} > 0
      Should Be True   ${device['data']['first_seen']['nanos']} > 0

      Length Should Be   ${device}  1

#ECQ-2296
showDevice - request for non-platos app with uuidtype=xxxSamSungxxx shall return device information
    [Documentation]
    ...  registerClient with non-platos app with unique_id and type=xxxSamSungxxx
    ...  verify showDevice returns all information supported
    ...  key.uniqueidtype key.uniqueid firstseen.seconds firstseen.nanos lastseen.seconds lastseen.nanos and notify_id

      ${epoch}=  Get Time  epoch

      Register Client  developer_org_name=${developer_name}  app_name=${platos_app_name}  unique_id=${epoch}  unique_id_type=xxxSamSungxxx

      ${device}=  Show Device  region=${region}  unique_id=${epoch}  unique_id_type=xxxSamSungxxx

      Should Be Equal  ${device['data']['key']['unique_id_type']}  xxxSamSungxxx
      Should Be Equal As Numbers  ${device['data']['key']['unique_id']}  ${epoch}
      Should Be True   ${device['data']['first_seen']['seconds']} > 0
      Should Be True   ${device['data']['first_seen']['nanos']} > 0

      Length Should Be   ${device}  1

#ECQ-2297
showDevice - request for non-platos app with S20 shall return device information
    [Documentation]
    ...  registerClient with non-platos app with S20 unique_id and type
    ...  verify showDevice returns all information supported
    ...  key.uniqueidtype key.uniqueid firstseen.seconds firstseen.nanos lastseen.seconds lastseen.nanos and notify_id

      ${epoch}=  Get Time  epoch

      Register Client  developer_org_name=${developer_name}  app_name=${platos_app_name}  unique_id=${epoch}  unique_id_type=${platos_s20_type}

      ${device}=  Show Device  region=${region}  unique_id=${epoch}  unique_id_type=${platos_s20_type}

      Should Be Equal  ${device['data']['key']['unique_id_type']}  ${platos_s20_type} 
      Should Be Equal As Numbers  ${device['data']['key']['unique_id']}  ${epoch}
      Should Be True   ${device['data']['first_seen']['seconds']} > 0
      Should Be True   ${device['data']['first_seen']['nanos']} > 0

      Length Should Be   ${device}  1

#ECQ-2298
showDevice - request for non-platos app with S6 shall return device information
    [Documentation]
    ...  registerClient with non-platos app with S6 unique_id and type
    ...  verify showDevice returns all information supported
    ...  key.uniqueidtype key.uniqueid firstseen.seconds firstseen.nanos lastseen.seconds lastseen.nanos and notify_id

      Register Client  developer_org_name=${developer_name}  app_name=${platos_app_name}  unique_id=${platos_s6_id}  unique_id_type=${platos_s6_type}

      ${device}=  Show Device  region=${region}  unique_id=${platos_s6_id}  unique_id_type=${platos_s6_type}

      Should Be Equal  ${device['data']['key']['unique_id_type']}  ${platos_s6_type}
      Should Be Equal As Numbers  ${device['data']['key']['unique_id']}  ${platos_s6_id}
      Should Be True   ${device['data']['first_seen']['seconds']} > 0
      Should Be True   ${device['data']['first_seen']['nanos']} > 0

      Length Should Be   ${device}  1

*** Keywords ***
Setup
    Create Flavor  region=${region} 
    Create App  region=${region}  developer_org_name=${developer_name}  app_name=${platos_app_name}  access_ports=tcp:1  image_path=${docker_image}  #docker-qa.mobiledgex.net/${developer_name}/images/server_ping_threaded:6.0
