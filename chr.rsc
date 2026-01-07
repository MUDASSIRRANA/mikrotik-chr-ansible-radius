# 2026-01-07 14:02:27 by RouterOS 7.20.6
# system id = /Qo1MSrsXVN
#
/interface ethernet
set [ find default-name=ether1 ] advertise=\
    10M-baseT-half,10M-baseT-full,100M-baseT-half,100M-baseT-full \
    disable-running-check=no
set [ find default-name=ether2 ] advertise=\
    10M-baseT-half,10M-baseT-full,100M-baseT-half,100M-baseT-full \
    disable-running-check=no
/ip hotspot profile
set [ find default=yes ] use-radius=yes
add hotspot-address=10.5.50.1 name=hsprof1
add hotspot-address=192.168.56.1 name=hsprof2
/ip pool
add name=hs-pool-3 ranges=192.168.56.2-192.168.56.254
/ip dhcp-server
add address-pool=hs-pool-3 interface=ether2 name=dhcp1
/ip hotspot
add address-pool=hs-pool-3 disabled=no interface=ether2 name=hotspot1 \
    profile=hsprof2
/ip address
add address=192.168.56.1/24 comment="hotspot network" interface=ether2 \
    network=192.168.56.0
/ip dhcp-client
add interface=ether1
/ip dhcp-server network
add address=10.5.50.0/24 comment="hotspot network" gateway=10.5.50.1
add address=192.168.56.0/24 comment="hotspot network" gateway=192.168.56.1
/ip dns
set servers=8.8.8.8
/ip firewall filter
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=accept chain=forward dst-address=1.1.1.1 dst-port=443 protocol=tcp
add action=accept chain=output dst-port=1812,1813 protocol=udp
add action=accept chain=hs-input comment="Allow ping to router" protocol=icmp
/ip firewall nat
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=masquerade chain=srcnat comment="masquerade hotspot network" \
    src-address=10.5.50.0/24
add action=masquerade chain=srcnat comment="masquerade hotspot network" \
    src-address=192.168.56.0/24
/ip hotspot user
add name=test
/radius
add address=35.227.71.209 service=hotspot
