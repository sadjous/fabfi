#!/usr/bin/lua

--------------------------------------
-- portalgun.lua
-- a mesh network access controller
--
-- Because we found the cake to be a lie
-- Every damn time
--


--[[ includes ]]------------------------------------------------------------
require "logging"
require "logging.file"
logname = "/tmp/portalgun.log"
log = logging.file(logname)
if not log then
  log = logging.file("/dev/null")
end
-- log:setLevel(logging.INFO)
log:setLevel(logging.DEBUG)
log:debug("portalgun.lua starting")



--[[ main ]]----------------------------------------------------------------
function main(arg)
    log:debug("-- portalgun ----------------------------------------")
  
end
main(arg)



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
