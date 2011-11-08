require "logging.file"
logname = "/var/log/villagebus.log"
local log = logging.file(logname)
if not log then
  log = logging.file("/dev/null")
end
-- log:setLevel(logging.INFO)
log:setLevel(logging.DEBUG)
log:debug("loaded villagebus.modules.portalgun") 


--
module("modules.portalgun", package.seeall)


--
function foo(request, response)
  return { foo = request }
end

bar = {
  GET  = function(request, response)
           return { getbar = request }
         end,
  POST = function(request, response)
           return { postbar = request }
         end
}
