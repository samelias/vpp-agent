*** Settings ***
Library      OperatingSystem
#Library      RequestsLibrary
#Library      SSHLibrary      timeout=60s
#Library      String

Resource     ../../../variables/${VARIABLES}_variables.robot

Resource     ../../../libraries/all_libs.robot

Suite Setup       Testsuite Setup
Suite Teardown    Testsuite Teardown
Test Setup        TestSetup
Test Teardown     TestTeardown

*** Variables ***
${VARIABLES}=          common
${ENV}=                common
${MAC_GOOD}=      a2:01:01:01:01:01
${MAC_BAD}=       a2:01:01:01:01:01:xy

*** Test Cases ***
Configure Environment
    [Tags]    setup
    Add Agent VPP Node    agent_vpp_1

Show Interfaces Before Setup
    vpp_term: Show Interfaces    agent_vpp_1

Interface Should Not Be Present
    vpp_term: Interface Not Exists    node=agent_vpp_1    mac=${MAC_GOOD}
    ${int_key}=    Set Variable    /vnf-agent/agent_vpp_1/vpp/status/v1/interface/vpp1_memif1
    ${int_error_key}=    Set Variable    /vnf-agent/agent_vpp_1/vpp/status/v1/interface/error/vpp1_memif1
    Log Many    ${int_key}    ${int_error_key}
    ${out}=    vpp_ctl: Read Key    ${int_key}
    Should Be Empty    ${out}
    ${out}=    vpp_ctl: Read Key    ${int_error_key}
    Should Be Empty    ${out}

Add Memif With Wrong MAC
    vpp_ctl: Put Memif Interface With IP    node=agent_vpp_1    name=vpp1_memif1    mac=${MAC_BAD}    master=true    id=1    ip=192.168.1.1    prefix=24    socket=default.sock
    vpp_term: Interface Not Exists    node=agent_vpp_1    mac=${MAC_BAD}
    ${int_error_key}=    Set Variable    /vnf-agent/agent_vpp_1/vpp/status/v1/interface/error/vpp1_memif1
    Log Many    ${int_error_key}
    ${out}=    vpp_ctl: Read Key    ${int_error_key}
    Should Contain    ${out}    error_data

Correct MAC In Memif
    vpp_ctl: Put Memif Interface With IP    node=agent_vpp_1    name=vpp1_memif1    mac=${MAC_GOOD}    master=true    id=1    ip=192.168.1.1    prefix=24    socket=default.sock
    vpp_term: Interface Is Created    node=agent_vpp_1    mac=${MAC_GOOD}
    ${int_key}=    Set Variable    /vnf-agent/agent_vpp_1/vpp/status/v1/interface/vpp1_memif1
    ${int_error_key}=    Set Variable    /vnf-agent/agent_vpp_1/vpp/status/v1/interface/error/vpp1_memif1
    Log Many    ${int_key}    ${int_error_key}
    ${out}=    vpp_ctl: Read Key    ${int_key}
    Should Not Be Empty    ${out}
    ${out}=    vpp_ctl: Read Key    ${int_error_key}
    Should Be Empty    ${out}

Set Wrong MAC To Memif Again
    vpp_ctl: Put Memif Interface With IP    node=agent_vpp_1    name=vpp1_memif1    mac=${MAC_BAD}    master=true    id=1    ip=192.168.1.1    prefix=24    socket=default.sock
    vpp_term: Interface Is Deleted    node=agent_vpp_1    mac=${MAC_GOOD}   
    ${int_key}=    Set Variable    /vnf-agent/agent_vpp_1/vpp/status/v1/interface/vpp1_memif1
    ${int_error_key}=    Set Variable    /vnf-agent/agent_vpp_1/vpp/status/v1/interface/error/vpp1_memif1
    Log Many    ${int_key}    ${int_error_key}
    ${out}=    vpp_ctl: Read Key    ${int_key}
    Should Be Empty    ${out}
    ${out}=    vpp_ctl: Read Key    ${int_error_key}
    Should Contain    ${out}    error_data

Delete Memif
    vpp_ctl: Delete VPP Interface    node=agent_vpp_1    name=vpp1_memif1
    Sleep    5s
    ${int_key}=    Set Variable    /vnf-agent/agent_vpp_1/vpp/status/v1/interface/vpp1_memif1
    ${int_error_key}=    Set Variable    /vnf-agent/agent_vpp_1/vpp/status/v1/interface/error/vpp1_memif1
    Log Many    ${int_key}    ${int_error_key}
    ${out}=    vpp_ctl: Read Key    ${int_key}
    Should Be Empty    ${out}
    ${out}=    vpp_ctl: Read Key    ${int_error_key}
    Should Be Empty    ${out}


test_end
   sleep   5

Show Interfaces And Other Objects After Setup
    vpp_term: Show Interfaces    agent_vpp_1
    Write To Machine    agent_vpp_1_term    show int addr
    Write To Machine    agent_vpp_1_term    show h
    Write To Machine    agent_vpp_1_term    show memif
    Write To Machine    agent_vpp_1_term    show err
    vat_term: Interfaces Dump    agent_vpp_1
    Write To Machine    vpp_agent_ctl    vpp-agent-ctl ${AGENT_VPP_ETCD_CONF_PATH} -ps
    Execute In Container    agent_vpp_1    ip a

*** Keywords ***
TestSetup
    Make Datastore Snapshots    ${TEST_NAME}_test_setup

TestTeardown
    Make Datastore Snapshots    ${TEST_NAME}_test_teardown

