--[[ logging ]]--
require "logging.file"
logname = "/var/log/villagebus.log"
local log = logging.file(logname)
if not log then
  log = logging.file("/dev/null")
end
-- log:setLevel(logging.INFO)
log:setLevel(logging.DEBUG)
log:debug("loaded villagebus.modules.splash") 


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

  log:debug("splash.lua dumping request headers -> " .. json.encode(request.headers))


  -- TODO config via uci.lucid
  local splashroot  = ("/www/splash")
  local file = fs.realpath(splashroot .. "/index.html")
  
  -- read & serve file
  local stat = fs.stat(file)
  --response.header["Content-Length"] = stat.size
  --response.header["Content-Type"] = mime.to_mime(file)

  local content = fs.readfile(file)

  local debug = "<pre>"
  debug = debug .. "original request: "
  debug = debug .. "http://"
  debug = debug .. request.env["HTTP_HOST"]
  debug = debug .. request.env["REQUEST_URI"]
  debug = debug .. "</pre>"

  local script = "<script type='text/javascript'>\n"
  script = script .. "var portalgun = {};\n"
  script = script .. "portalgun.request = " .. json.encode(request) .. ";\n"
  script = script .. "console.log('from server:');\n"
  script = script .. "console.log(portalgun.request);\n"
  script = script .. "</script>\n"

  response.prepare_content("text/html")
  response.status(200)
  response.write(content)
  response.write(debug)
  response.write(script)

  return nil
end