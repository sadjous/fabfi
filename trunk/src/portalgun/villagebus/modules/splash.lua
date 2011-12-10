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
local md5 = require "md5"


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

  --log:debug("request.path length: " .. table.getn(request.path))

  log:debug("splash.lua dumping request" .. 
            " -> " .. json.encode(request.verb) ..
            " -> " .. json.encode(request.path) ..
            " -> " .. json.encode(request.query) ..
            " -> " .. json.encode(request.data)) 

  -- dispatch portalgun requests
  local uuid = md5.sumhexa(request.env["HTTP_HOST"])
  if request.path[1] == uuid then
    response.prepare_content("application/json")
    response.status(200)
    response.write(json.encode(request.data))
    return nil
  end

  -- display splash page

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
  debug = debug .. request.headers["Host"]
  debug = debug .. request.env["REQUEST_URI"]
  debug = debug .. "</pre>"

  local script = "<script type='text/javascript'>\n"
  script = script .. "var portalgun = {};\n"
  script = script .. "portalgun.request = " .. json.encode(request) .. ";\n"
  script = script .. "portalgun.rest = {};\n"
  script = script .. "portalgun.rest.uuid = " .. json.encode("/" .. uuid) .. ";\n"
  script = script .. "portalgun.rest.free = " .. json.encode("/" .. uuid .. "/free") .. ";\n"
  -- script = script .. "console.log('from server:');\n"
  -- script = script .. "console.log(JSON.stringify(portalgun.request));\n"
  -- script = script .. "console.log(JSON.stringify(portalgun.uuid));\n"
  script = script .. "</script>\n"

  response.prepare_content("text/html")
  response.status(200)
  response.write(content)
  response.write(debug)
  response.write(script)

  return nil
end