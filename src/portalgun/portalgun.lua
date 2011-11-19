#!/usr/bin/lua

--------------------------------------
-- portalgun.lua
-- a mesh network access controller
--
-- Because we found the cake to be a lie
-- Every damn time
--


--[[ limitations
 
  . mac address is only known on client's connecting node
  . at gateway we know only the ip
  . rules are block by default so arbitrary client-assigned ip's won't work
  . client can hijack someone elses ip unless we also implement mac rules on client's node
  
]]--

--[[ firewall setup

  -- state
  gw       = eth0
  mesh     = wlan1
  client_1 = 2001:470:1f07:c42:1e4b:d6ff:fe80:dada

  -- base config
  ip6tables -F   
  ip6tables -P FORWARD ACCEPT
  ip6tables -I FORWARD -j REJECT -i ${mesh}
  
  -- open a portal
  ip6tables -I FORWARD -i ${mesh} -s ${client_1}/128 -j ACCEPT -m comment --comment "portalgun user"

  -- close a portal
  ip6tables -D FORWARD -i ${mesh} -s ${client_1}/128 -j ACCEPT -m comment --comment "portalgun user"


]]--

--[[ useful

  LuCI sources: http://luci.subsignal.org/trac/browser/luci/trunk
  http://luci.subsignal.org/trac/browser/luci/trunk/libs/core/luasrc/util.lua
  http://luci.subsignal.org/trac/browser/luci/trunk/libs/sys/luasrc/sys.lua
  http://luci.subsignal.org/trac/browser/luci/trunk/libs/sys/luasrc/sys/iptparser.lua

  LuCId: http://luci.subsignal.org/trac/browser/luci/trunk/libs/lucid/docs/OVERVIEW
         http://luci.subsignal.org/trac/browser/luci/trunk/libs/lucid-http/docs/OVERVIEW
         http://luci.subsignal.org/trac/browser/luci/trunk/libs/lucid-rpc/docs/OVERVIEW
    ./scripts/feeds install luci-lib-lucid      
    ./scripts/feeds install luci-lib-lucid-http 
    ./scripts/feeds install luci-lib-lucid-rpc  
    ./scripts/feeds install luci-lib-px5g       

  nixio: http://neopallium.github.com/nixio/
    ./scripts/feeds install luci-lib-nixio 

]]--


--[[ includes ]]------------------------------------------------------------
require "logging"
require "logging.file"
logname = "/var/log/portalgun.log"
log = logging.file(logname)
if not log then
  log = logging.file("/dev/null")
end
-- log:setLevel(logging.INFO)
log:setLevel(logging.DEBUG)
log:debug("portalgun.lua starting")



--[[ main ]]----------------------------------------------------------------
function index()  -- see: http://luci.subsignal.org/trac/browser/luci/trunk/modules/freifunk/luasrc/controller/freifunk/freifunk.lua
  local http = require "luci.http"
  
  log:debug("-- portalgun -----------------------------------")

  luci.http.prepare_content("text/html")
  luci.http.write_json("<html><body>portalgun</body></html>")        
end




-- portal :: person -> address -> [ action ]
function portal(person, address)

    --[[ pattern match on: person, address
            portal nil nil  = 
            portal nil mac  =
            portal nil ipv4 =
            portal nil ipv6 =
            .
            etc.
    --]]


end

-- open a portal
function open(node, comment)
  
end

-- close a portal
function close(node, comment)
end

-- ip6tables execution wrapper
function ip6tables(action, chain, interface, source, target, comment)
  -- http://linux.die.net/man/8/ip6tables

end






