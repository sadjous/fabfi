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
local fs = require "nixio.fs"
--local nixio = require "nixio", require "nixio.util"


--[[ modules.portalgun ]]--
module("modules.splash", package.seeall)


-- [[ implementation ]]--

-- Handle GET, POST
function GET(request, response)
  return splash(request, response)
end
function POST(request, response)
  return splash(request, response)
end


-- Splash page
function splash(request, response)
  log:debug(json.encode(request))

  -- TODO config via uci.lucid
  local splashroot  = ("/www/splash")
  local file = fs.realpath(splashroot .. "/index.html")
  
  -- read & serve file
  local stat = fs.stat(file)
  --response.header["Content-Length"] = stat.size
  --response.header["Content-Type"] = mime.to_mime(file)

  local content = fs.readfile(file)

  log:debug("Dumping response headers:" )
  --log:debug(json.encode(response.header))

  response.prepare_content("text/html")
  response.status(200)
  response.write(content)

  return nil
end