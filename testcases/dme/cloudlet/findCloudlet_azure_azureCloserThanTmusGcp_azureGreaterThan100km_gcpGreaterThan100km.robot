*** Settings ***
Documentation   FindCloudlet - request shall return azure with dmuus and gcp/azure cloudlet provisioned and dmuus farther and > 100km than azure and gcp and azure closer than gcp
...		dmuus tmocloud-2 cloudlet at: 35 -95
...             gcp gcpcloud-1  cloudlet at: 38 -96
...             azure azurecloud-1  cloudlet at: 37 -95
...		find cloudlet closest to   : 37 -96
...                239.89km from dmuus
...                111.19km  from gcp
...                88.80km  from azure
...             azure is closer by 151.09km which is more than 100km closer. return azure cloudlet
...             gcp is closer by 128.70km which is greater than 100km closer
...             ShowCloudlet
...             - key:
...                 operatorkey:
...                   name: dmuus
...                 name: tmocloud-2
...               location:
...                 lat: 35
...                 long: -95
...             - key:
...                 operatorkey:
...                   name: azure
...                 name: azurecloud-1
...               location:
...                 lat: 37
...                 long: -95
...             - key:
...                 operatorkey:
...                   name: gcp
...                 name: gcpcloud-1
...               location:
...                 lat: 38
...                 long: -96

...

Library         MexDme  dme_address=%{AUTOMATION_DME_ADDRESS}
Library		MexController  controller_address=%{AUTOMATION_CONTROLLER_ADDRESS}

Test Setup	Setup
Test Teardown	Cleanup provisioning

*** Variables ***
${dmuus_operator_name}  dmuus
${azure_operator_name}  azure
${gcp_operator_name}  gcp
${dmuus_cloudlet_name}  tmocloud-2  #has to match crm process startup parms
${gcp_cloudlet_name}  gcpcloud-1  #has to match crm process startup parms
${azure_cloudlet_name}  azurecloud-1  #has to match crm process startup parms
${app_name}  someapplication2   
${developer_name}  AcmeAppCo
${app_version}  1.0
${flavor}	  x1.medium
${number_nodes}	  3
${max_nodes}	  4
${num_masters}	  1

${dmuus_cloudlet_latitude}	  35
${dmuus_cloudlet longitude}	  -95
${azure_cloudlet_latitude}	  37
${azure_cloudlet longitude}	  -95
${gcp_cloudlet_latitude}	  38
${gcp_cloudlet longitude}	  -96

*** Test Cases ***
FindCloudlet - request shall return azure with dmuus and gcp/azure cloudlet provisioned and dmuus farther and > 100km than azure and gcp and azure closer than gcp
    [Documentation]
    ...  findCloudlet with dmuus/gcp/azure provisioned. dmuus farther than 100km from azure/gcp. azure closer than gcp by more than 100km. return azure
    ...             dmuus tmocloud-2 cloudlet at: 35 -95
    ...             gcp gcpcloud-1  cloudlet at: 38 -96
    ...             azure azurecloud-1  cloudlet at: 37 -95
    ...             find cloudlet closest to   : 37 -96
    ...                239.89km from dmuus
    ...                111.19km  from gcp
    ...                88.80km  from azure
    ...             azure is closer by 151.09km which is more than 100km closer. return azure cloudlet
    ...             gcp is closer by 128.70km which is greater than 100km closer
    ...             ShowCloudlet
    ...             - key:
    ...                 operatorkey:
    ...                   name: dmuus
    ...                 name: tmocloud-2
    ...               location:
    ...                 lat: 35
    ...                 long: -95
    ...             - key:
    ...                 operatorkey:
    ...                   name: azure
    ...                 name: azurecloud-1
    ...               location:
    ...                 lat: 37
    ...                 long: -95
    ...             - key:
    ...                 operatorkey:
    ...                   name: gcp
    ...                 name: gcpcloud-1
    ...               location:
    ...                 lat: 38
    ...                 long: -96

      Register Client	
      ${cloudlet}=  Find Cloudlet	carrier_name=${dmuus_operator_name}  latitude=37  longitude=-96

      Should Be Equal As Numbers  ${cloudlet.status}  1  #FIND_FOUND

      Should Be Equal             ${cloudlet.fqdn}   ${azure_appinst.uri}   #acmeappcosomeapplication210.tmocloud-2.azure.mobiledgex.net
      Should Be Equal As Numbers  ${cloudlet.cloudlet_location.latitude}   ${azure_cloudlet_latitude} 
      Should Be Equal As Numbers  ${cloudlet.cloudlet_location.longitude}  ${azure_cloudlet_longitude} 

      Should Be Equal As Numbers  ${cloudlet.ports[0].proto}               ${azure_appinst.mapped_ports[0].proto}  #LProtoTCP
      Should Be Equal As Numbers  ${cloudlet.ports[0].internal_port}       ${azure_appinst.mapped_ports[0].internal_port}
      Should Be Equal As Numbers  ${cloudlet.ports[0].public_port}         ${azure_appinst.mapped_ports[0].public_port}
      Should Be Equal             ${cloudlet.ports[0].fqdn_prefix}         ${azure_appinst.mapped_ports[0].fqdn_prefix}

*** Keywords ***
Setup
    #Create Operator             operator_name=${operator_name} 
    #Create Operator             operator_name=${gcp_operator_name} 
    #Create Operator             operator_name=${azure_operator_name} 
    Create Developer            
    Create Flavor
    Create Cloudlet		cloudlet_name=${azure_cloudlet_name}  operator_name=${azure_operator_name}  latitude=${azure_cloudlet_latitude}  longitude=${azure_cloudlet_longitude}
    Create Cloudlet		cloudlet_name=${gcp_cloudlet_name}  operator_name=${gcp_operator_name}    latitude=${gcp_cloudlet_latitude}     longitude=${gcp_cloudlet_longitude}
    #Create Cloudlet		cloudlet_name=${dmuus_cloudlet_name}  operator_name=${dmuus_operator_name}  latitude=${dmuus_cloudlet_latitude}  longitude=${dmuus_cloudlet_longitude}
    Create App			access_ports=tcp:1  
    Create App Instance		cloudlet_name=${dmuus_cloudlet_name}  operator_name=${dmuus_operator_name}  cluster_instance_name=autocluster
    ${azure_appinst}=           Create App Instance   cloudlet_name=${azure_cloudlet_name}  operator_name=${azure_operator_name}  cluster_instance_name=autocluster
    Create App Instance		cloudlet_name=${gcp_cloudlet_name}  operator_name=${gcp_operator_name}  cluster_instance_name=autocluster

    Set Suite Variable  ${azure_appinst} 
