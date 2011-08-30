#!/usr/bin/lua


-- portalgun.lua
-- a mesh network access controller
--
-- Because the cake is a lie. 
-- Every time.
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