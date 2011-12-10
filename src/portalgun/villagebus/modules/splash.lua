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
local fs  = require "nixio.fs"
local md5 = require "md5"


--[[ modules.portalgun ]]--
module("modules.splash", package.seeall)

local splashconfig = { -- TODO configure via uci.lucid
  root = "/www/splash",
  page = "index.html"
}


-- [[ implementation ]]--
function GET(request, response)
  return splash(request, response)
end
function POST(request, response)
  return splash(request, response)
end


-- Splash page
function splash(request, response)
  log:debug("splash" .. 
            " -> " .. json.encode(request.verb) ..
            " -> " .. json.encode(request.path) ..
            " -> " .. json.encode(request.query) ..
            " -> " .. json.encode(request.data)) 

  -- get client address
  local client = request.headers["X-Forwarded-For"] or 
                 request.env["REMOTE_ADDR"] 

  -- check for and dispatch any portalgun operations
  local uuid = md5.sumhexa(request.env["HTTP_HOST"])
  if request.path[1] == uuid then
    response.prepare_content("application/json")
    response.status(200)
    response.write(json.encode(request.data))
    return nil
  end

  -- save original request url for login redirect
  local redirect = "http://" ..
                   request.headers["Host"] ..
                   request.env["REQUEST_URI"]
  log:info("splash" ..
           " -> " .. (client or "unknown client") .. 
           " -> " .. redirect)

  -- read & serve file
  local file = fs.realpath(splashconfig.root .. "/" .. splashconfig.page)
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
  script = script .. "portalgun.rest = {};\n"
  script = script .. "portalgun.rest.uuid = " .. json.encode("/" .. uuid) .. ";\n"
  script = script .. "portalgun.rest.free = " .. json.encode("/" .. uuid .. "/free") .. ";\n"
  script = script .. "portalgun.redirect  = " .. json.encode(redirect)
  -- script = script .. "console.log('from server:');\n"
  -- script = script .. "console.log(JSON.stringify(portalgun.request));\n"
  -- script = script .. "console.log(JSON.stringify(portalgun.uuid));\n"
  script = script .. "</script>\n"

  response.prepare_content("text/html")
  response.status(200)
  response.write(content)
  response.write(script)
  response.write(debug)

  return nil
end