--[[ logging ]]--
require "logging.file"
logname = "/var/log/villagebus.log"
local log = logging.file(logname)
if not log then
  log = logging.file("/dev/null")
end
-- log:setLevel(logging.INFO)
log:setLevel(logging.DEBUG)
log:debug("loaded villagebus.modules.portalgun") 

--[[ dependencies ]]--
require "luci.sys.iptparser"


--[[ modules.portalgun ]]--
module("modules.portalgun", package.seeall)


-- query status for a portal
function status(request, response)
  return { status = request }
end


-- portal management
portals = {
  GET  = function(request, response)
           return { getportals = request }
         end,
  POST = function(request, response)
           return { postportals = request }
         end
}
