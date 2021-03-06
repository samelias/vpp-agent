*** Settings ***
Library      OperatingSystem
#Library      RequestsLibrary
#Library      SSHLibrary      timeout=60s
#Library      String

Resource     ../../../variables/${VARIABLES}_variables.robot
Resource     ../../../libraries/all_libs.robot
Resource    ../../../libraries/pretty_keywords.robot

Suite Setup       Testsuite Setup
Suite Teardown    Testsuite Teardown

*** Variables ***
${VARIABLES}=               common
${ENV}=                     common
${NAME_VPP1_TAP1}=          vpp1_tap1
${NAME_VPP2_TAP1}=          vpp2_tap1
${NAME_VPP1_LINUX_TO_VPP2}=     vpp1linuxtovpp2
${NAME_VPP2_LINUX_TO_VPP1}=     vpp2linuxtovpp1
${MAC_VPP1_TAP1}=           12:21:21:11:11:11
${MAC_VPP2_TAP1}=           22:21:21:22:22:22
${IP_VPP1_TAP1}=            10.10.1.1
${IP_VPP2_TAP1}=            20.20.1.1
${IP_LINUX_VPP1_TAP1}=      10.10.1.2
${IP_LINUX_VPP2_TAP1}=      20.20.1.2
${IP_VPP1_TAP1_NETWORK}=    10.10.1.0
${IP_VPP2_TAP1_NETWORK}=    20.20.1.0
${NAME_VPP1_MEMIF1}=        vpp1_memif1
${NAME_VPP2_MEMIF1}=        vpp2_memif1
${MAC_VPP1_MEMIF1}=         13:21:21:11:11:11
${MAC_VPP2_MEMIF1}=         23:21:21:22:22:22
${IP_VPP1_MEMIF1}=          192.168.1.1
${IP_VPP2_MEMIF1}=          192.168.1.2
${PREFIX}=                  24
${UP_STATE}=                up
${SYNC_SLEEP}=         10s
# wait for resync vpps after restart
${RESYNC_WAIT}=        50s

*** Test Cases ***
Configure Environment
    [Tags]    setup
    Configure Environment 1

Show Interfaces Before Setup
    vpp_term: Show Interfaces    agent_vpp_1
    vpp_term: Show Interfaces    agent_vpp_2
    Write To Machine    vpp_agent_ctl    vpp-agent-ctl ${AGENT_VPP_ETCD_CONF_PATH} -ps

Add VPP1_TAP1 Interface And Check It Was Created
    vpp_term: Interface Not Exists  node=agent_vpp_1    mac=${MAC_VPP1_TAP1}
    vpp_ctl: Put TAPv2 Interface With IP    node=agent_vpp_1    name=${NAME_VPP1_TAP1}    mac=${MAC_VPP1_TAP1}    ip=${IP_VPP1_TAP1}    prefix=${PREFIX}    host_if_name=linux_${NAME_VPP1_TAP1}
    linux: Set Host TAP Interface    node=agent_vpp_1    host_if_name=linux_${NAME_VPP1_TAP1}    ip=${IP_LINUX_VPP1_TAP1}    prefix=${PREFIX}
    vpp_term: Interface Is Created    node=agent_vpp_1    mac=${MAC_VPP1_TAP1}
    ${actual_state}=    vpp_term: Check TAPv2 Interface State    agent_vpp_1    ${NAME_VPP1_TAP1}    mac=${MAC_VPP1_TAP1}    ipv4=${IP_VPP1_TAP1}/${PREFIX}    state=${UP_STATE}

Add VPP1_memif1 Interface
    vpp_term: Interface Not Exists    node=agent_vpp_1    mac=${MAC_VPP1_MEMIF1}
    vpp_ctl: Put Memif Interface With IP    node=agent_vpp_1    name=${NAME_VPP1_MEMIF1}    mac=${MAC_VPP1_MEMIF1}    master=true    id=1    ip=${IP_VPP1_MEMIF1}    prefix=24    socket=memif.sock
    vpp_term: Interface Is Created    node=agent_vpp_1    mac=${MAC_VPP1_MEMIF1}

Add VPP2_TAP1 Interface And Check It Was Created
    vpp_term: Interface Not Exists  node=agent_vpp_2    mac=${MAC_VPP2_TAP1}
    vpp_ctl: Put TAPv2 Interface With IP    node=agent_vpp_2    name=${NAME_VPP2_TAP1}    mac=${MAC_VPP2_TAP1}    ip=${IP_VPP2_TAP1}    prefix=${PREFIX}    host_if_name=linux_${NAME_VPP2_TAP1}
    linux: Set Host TAP Interface    node=agent_vpp_2    host_if_name=linux_${NAME_VPP2_TAP1}    ip=${IP_LINUX_VPP2_TAP1}    prefix=${PREFIX}
    vpp_term: Interface Is Created    node=agent_vpp_2    mac=${MAC_VPP2_TAP1}
    ${actual_state}=    vpp_term: Check TAPv2 Interface State    agent_vpp_2    ${NAME_VPP2_TAP1}    mac=${MAC_VPP2_TAP1}    ipv4=${IP_VPP2_TAP1}/${PREFIX}    state=${UP_STATE}

Add VPP2_memif1 Interface
    vpp_term: Interface Not Exists    node=agent_vpp_2    mac=${MAC_VPP2_MEMIF1}
    vpp_ctl: Put Memif Interface With IP    node=agent_vpp_2    name=${NAME_VPP2_MEMIF1}    mac=${MAC_VPP2_MEMIF1}    master=false    id=1    ip=${IP_VPP2_MEMIF1}    prefix=24    socket=memif.sock
    vpp_term: Interface Is Created    node=agent_vpp_1    mac=${MAC_VPP1_MEMIF1}

Add Static Route From VPP1 Linux To VPP2
    vpp_ctl: Put Linux Route    node=agent_vpp_1    namespace=${EMPTY}    interface=${NAME_VPP1_TAP1}    routename=${NAME_VPP1_LINUX_TO_VPP2}    ip=${IP_VPP2_TAP1_NETWORK}    next_hop=${EMPTY}
#    Create Route    node=agent_vpp_1    routename=vpp1linuxtovpp2    ip=${IP_VPP2_TAP1_NETWORK}    interface=${NAME_VPP1_TAP1}

Add Static Route From VPP1 To VPP2
    Create Route On agent_vpp_1 With IP 20.20.1.0/24 With Next Hop 192.168.1.2 And Vrf Id 0

Add Static Route From VPP2 Linux To VPP1
    vpp_ctl: Put Linux Route    node=agent_vpp_2    namespace=${EMPTY}    interface=${NAME_VPP2_TAP1}    routename=${NAME_VPP2_LINUX_TO_VPP1}    ip=${IP_VPP1_TAP1_NETWORK}    next_hop=${EMPTY}
#    Create Route    node=agent_vpp_2    routename=vpp2linuxtovpp1    ip=${IP_VPP1_TAP1_NETWORK}    interface=${NAME_VPP2_TAP1}

Add Static Route From VPP2 To VPP1
    Create Route On agent_vpp_2 With IP 10.10.1.0/24 With Next Hop 192.168.1.1 And Vrf Id 0

Show Routes On VPP1 Linux
    ${out}=    Execute In Container     agent_vpp_1    ip addr show linux_${NAME_VPP1_TAP1}
    Log    ${out}
    ${linux_vpp1_tap1_route1}=    Get Lines Containing String    ${out}    linux_${NAME_VPP1_TAP1}
    Set Suite Variable    ${linux_vpp1_tap1_route1}

Show Route To VPP2 Configured On VPP1
    ${out}=    vpp_term: Show Ip Fib    agent_vpp_1    ${IP_VPP2_TAP1_NETWORK}/${PREFIX}
    Log    ${out}
    Should Contain    ${out}    via ${IP_VPP2_MEMIF1}

Show Routes On VPP2 Linux
    ${out}=    Execute In Container     agent_vpp_2    ip addr show linux_${NAME_VPP2_TAP1}
    Log    ${out}
    ${linux_vpp2_tap1_route1}=    Get Lines Containing String    ${out}    linux_${NAME_VPP2_TAP1}
    Set Suite Variable    ${linux_vpp2_tap1_route1}

Show Route To VPP1 Configured On VPP2
    ${out}=    vpp_term: Show Ip Fib    agent_vpp_2    ${IP_VPP1_TAP1_NETWORK}/${PREFIX}
    Log    ${out}
    Should Contain    ${out}    via ${IP_VPP1_MEMIF1}

Check Ping From VPP1 To VPP2_memif1
    vpp_term: Check Ping    node=agent_vpp_1    ip=${IP_VPP2_MEMIF1}

Check Ping From VPP2 To VPP1_memif1
    vpp_term: Check Ping    node=agent_vpp_2    ip=${IP_VPP1_MEMIF1}

Check Ping From VPP1 Linux To VPP2_TAP1 And LINUX_VPP2_TAP1
    linux: Check Ping    node=agent_vpp_1    ip=${IP_VPP2_TAP1}
    linux: Check Ping    node=agent_vpp_1    ip=${IP_LINUX_VPP2_TAP1}

Check Ping From VPP2 Linux To VPP1_TAP1 And LINUX_VPP1_TAP1
    linux: Check Ping    node=agent_vpp_2    ip=${IP_VPP1_TAP1}
    linux: Check Ping    node=agent_vpp_2    ip=${IP_LINUX_VPP1_TAP1}

Remove Nodes And Stop Containers
    Testsuite Teardown

Start Containers And Add Nodes
    Testsuite Setup

Configure Environment 2
    [Tags]    setup
    Configure Environment 1

Show Interfaces Before Setup 2
    vpp_term: Show Interfaces    agent_vpp_1
    vpp_term: Show Interfaces    agent_vpp_2
    Write To Machine    vpp_agent_ctl    vpp-agent-ctl ${AGENT_VPP_ETCD_CONF_PATH} -ps

Add Static Route From VPP1 Linux To VPP2 2
    vpp_ctl: Put Linux Route    node=agent_vpp_1    namespace=${EMPTY}    interface=${NAME_VPP1_TAP1}    routename=${NAME_VPP1_LINUX_TO_VPP2}    ip=${IP_VPP2_TAP1_NETWORK}    next_hop=${EMPTY}

Add Static Route From VPP1 To VPP2 2
    Create Route On agent_vpp_1 With IP 20.20.1.0/24 With Next Hop 192.168.1.2 And Vrf Id 0

Add Static Route From VPP2 Linux To VPP1 2
    vpp_ctl: Put Linux Route    node=agent_vpp_2    namespace=${EMPTY}    interface=${NAME_VPP2_TAP1}    routename=${NAME_VPP2_LINUX_TO_VPP1}    ip=${IP_VPP1_TAP1_NETWORK}    next_hop=${EMPTY}

Add Static Route From VPP2 To VPP1 2
    Create Route On agent_vpp_2 With IP 10.10.1.0/24 With Next Hop 192.168.1.1 And Vrf Id 0

Add VPP1_TAP1 Interface And Check It Was Created 2
    vpp_term: Interface Not Exists  node=agent_vpp_1    mac=${MAC_VPP1_TAP1}
    vpp_ctl: Put TAPv2 Interface With IP    node=agent_vpp_1    name=${NAME_VPP1_TAP1}    mac=${MAC_VPP1_TAP1}    ip=${IP_VPP1_TAP1}    prefix=${PREFIX}    host_if_name=linux_${NAME_VPP1_TAP1}
    linux: Set Host TAP Interface    node=agent_vpp_1    host_if_name=linux_${NAME_VPP1_TAP1}    ip=${IP_LINUX_VPP1_TAP1}    prefix=${PREFIX}
    vpp_term: Interface Is Created    node=agent_vpp_1    mac=${MAC_VPP1_TAP1}
    ${actual_state}=    vpp_term: Check TAPv2 Interface State    agent_vpp_1    ${NAME_VPP1_TAP1}    mac=${MAC_VPP1_TAP1}    ipv4=${IP_VPP1_TAP1}/${PREFIX}    state=${UP_STATE}

Add VPP1_memif1 Interface 2
    vpp_term: Interface Not Exists    node=agent_vpp_1    mac=${MAC_VPP1_MEMIF1}
    vpp_ctl: Put Memif Interface With IP    node=agent_vpp_1    name=${NAME_VPP1_MEMIF1}    mac=${MAC_VPP1_MEMIF1}    master=true    id=1    ip=${IP_VPP1_MEMIF1}    prefix=24    socket=memif.sock
    vpp_term: Interface Is Created    node=agent_vpp_1    mac=${MAC_VPP1_MEMIF1}

Add VPP2_TAP1 Interface And Check It Was Created 2
    vpp_term: Interface Not Exists  node=agent_vpp_2    mac=${MAC_VPP2_TAP1}
    vpp_ctl: Put TAPv2 Interface With IP    node=agent_vpp_2    name=${NAME_VPP2_TAP1}    mac=${MAC_VPP2_TAP1}    ip=${IP_VPP2_TAP1}    prefix=${PREFIX}    host_if_name=linux_${NAME_VPP2_TAP1}
    linux: Set Host TAP Interface    node=agent_vpp_2    host_if_name=linux_${NAME_VPP2_TAP1}    ip=${IP_LINUX_VPP2_TAP1}    prefix=${PREFIX}
    vpp_term: Interface Is Created    node=agent_vpp_2    mac=${MAC_VPP2_TAP1}
    ${actual_state}=    vpp_term: Check TAPv2 Interface State    agent_vpp_2    ${NAME_VPP2_TAP1}    mac=${MAC_VPP2_TAP1}    ipv4=${IP_VPP2_TAP1}/${PREFIX}    state=${UP_STATE}

Add VPP2_memif1 Interface 2
    vpp_term: Interface Not Exists    node=agent_vpp_2    mac=${MAC_VPP2_MEMIF1}
    vpp_ctl: Put Memif Interface With IP    node=agent_vpp_2    name=${NAME_VPP2_MEMIF1}    mac=${MAC_VPP2_MEMIF1}    master=false    id=1    ip=${IP_VPP2_MEMIF1}    prefix=24    socket=memif.sock
    vpp_term: Interface Is Created    node=agent_vpp_1    mac=${MAC_VPP1_MEMIF1}

Show Routes On VPP1 Linux 2
    ${out}=    Execute In Container     agent_vpp_1    ip addr show linux_${NAME_VPP1_TAP1}
    Log    ${out}
    ${linux_vpp1_tap1_route2}=    Get Lines Containing String    ${out}    linux_${NAME_VPP1_TAP1}
    Set Suite Variable    ${linux_vpp1_tap1_route2}

Show Route To VPP2 Configured On VPP1 2
    ${out}=    vpp_term: Show Ip Fib    agent_vpp_1    ${IP_VPP2_TAP1_NETWORK}/${PREFIX}
    Log    ${out}
    Should Contain    ${out}    via ${IP_VPP2_MEMIF1}

Show Routes On VPP2 Linux 2
    ${out}=    Execute In Container     agent_vpp_2    ip addr show linux_${NAME_VPP2_TAP1}
    Log    ${out}
    ${linux_vpp2_tap1_route2}=    Get Lines Containing String    ${out}    linux_${NAME_VPP2_TAP1}
    Set Suite Variable    ${linux_vpp2_tap1_route2}

Show Route To VPP1 Configured On VPP2 2
    ${out}=    vpp_term: Show Ip Fib    agent_vpp_2    ${IP_VPP1_TAP1_NETWORK}/${PREFIX}
    Log    ${out}
    Should Contain    ${out}    via ${IP_VPP1_MEMIF1}

Check Ping From VPP1 To VPP2_memif1 Again
    vpp_term: Check Ping    node=agent_vpp_1    ip=${IP_VPP2_MEMIF1}

Check Ping From VPP2 To VPP1_memif1 Again
    vpp_term: Check Ping    node=agent_vpp_2    ip=${IP_VPP1_MEMIF1}

Check Ping From VPP1 Linux To VPP2_TAP1 And LINUX_VPP2_TAP1 2
    linux: Check Ping    node=agent_vpp_1    ip=${IP_VPP2_TAP1}
    linux: Check Ping    node=agent_vpp_1    ip=${IP_LINUX_VPP2_TAP1}

Check Ping From VPP2 Linux To VPP1_TAP1 And LINUX_VPP1_TAP1 2
    linux: Check Ping    node=agent_vpp_2    ip=${IP_VPP1_TAP1}
    linux: Check Ping    node=agent_vpp_2    ip=${IP_LINUX_VPP1_TAP1}

Linux_VPP1_TAP1 Routes Are Configured Equally In Both Config Orders
    Should Be Equal    ${linux_vpp1_tap1_route1}    ${linux_vpp1_tap1_route2}

Linux_VPP2_TAP1 Routes Are Configured Equally In Both Config Orders
    Should Be Equal    ${linux_vpp2_tap1_route1}    ${linux_vpp2_tap1_route2}

*** Keywords ***
