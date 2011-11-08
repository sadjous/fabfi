--[[
LuCI - Dispatcher

Description:
The request dispatcher and module dispatcher generators

FileId:
$Id: dispatcher.lua 7851 2011-10-30 15:00:54Z jow $

License:
Copyright 2008 Steven Barth <steven@midlink.org>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

]]--

--- LuCI web dispatcher.
local fs = require "nixio.fs"
local sys = require "luci.sys"
local init = require "luci.init"
local util = require "luci.util"
local http = require "luci.http"
local nixio = require "nixio", require "nixio.util"

module("villagebus.dispatcher", package.seeall)
context = util.threadlocal()
uci = require "luci.model.uci"
i18n = require "luci.i18n"
_M.fs = fs


--[[ my dependencies ]]--
require "logging.file"
logname = "/var/log/villagebus.log"
local log = logging.file(logname)
if not log then
  log = logging.file("/dev/null")
end
-- log:setLevel(logging.INFO)
log:setLevel(logging.DEBUG)
log:debug("loaded villagebus.dispatcher") 
require "json"
require "villagebus.urlcode"


authenticator = {}



--[[ villagebus modules ]]--------------------------------------------------
require "villagebus.modules.http"
require "villagebus.modules.portalgun"


--- Send a 404 error code and render the "error404" template if available.
-- @param message	Custom error message (optional)
-- @return			false
function error404(message)
	luci.http.status(404, "Not Found")
	message = message or "Not Found"
	return false
end

--- Send a 500 error code and render the "error500" template if available.
-- @param message	Custom error message (optional)#
-- @return			false
function error500(message)
  luci.http.status(500, "Internal Server Error")
  luci.http.prepare_content("text/plain")
  luci.http.write(message)
	return false
end

function authenticator.htmlauth(validator, accs, default)
	local user = luci.http.formvalue("username")
	local pass = luci.http.formvalue("password")

	if user and validator(user, pass) then
		return user
	end

	require("luci.i18n")
	require("luci.template")
	context.path = {}
	luci.template.render("sysauth", {duser=default, fuser=user})
	return false
end

--- Dispatch an HTTP request.
-- @param request	LuCI HTTP Request object
function httpdispatch(request, prefix)

  local cgi = {
    request_method  = request:getenv("REQUEST_METHOD") or "",
    path_info       = request:getenv("PATH_INFO") or "",
    query_string    = request:getenv("QUERY_STRING") or "",
    content_type    = request:getenv("CONTENT_TYPE") or "",
    content_length  = tonumber(request:getenv("CONTENT_LENGTH") or "0"),
    content_data    = request:input() or "",
    request_uri     = request:getenv("REQUEST_URI") or "",
    auth_type       = request:getenv("AUTH_TYPE") or "",
    --remote_user     = request:getenv("REMOTE_USER") or "",
    --remote_address  = request:getenv("REMOTE_ADDRESS") or "",
    --remote_host     = request:getenv("REMOTE_HOST") or "",
    --http_referer    = request:getenv("HTTP_REFERER") or "",
    --path_translated = request:getenv("PATH_TRANSLATED") or ""
  }
  log:debug("villagebus.dispatcher.httpdispatch") --[[ ..
            " -> verb   : " .. cgi.request_method .. "\n" ..
            " -> path   : " .. cgi.path_info      .. "\n" ..
            " -> query  : " .. cgi.query_string   .. "\n" ..
            " -> type   : " .. cgi.content_type   .. "\n" ..
            " -> length : " .. cgi.content_length .. "\n" ..
            " -> data   : " .. cgi.content_data   .. "\n" ..
            " -> uri    : " .. cgi.request_uri    .. "\n" ..
            " -> auth   : " .. cgi.auth_type      .. "\n" ..
            " -> prefix : " .. json.encode(prefix)) ]]--

	luci.http.context.request = request

	local r = {}
	context.request = r
	context.urltoken = {}
  context.query = {}

	local pathinfo = http.urldecode(request:getenv("PATH_INFO") or "", true)

	if prefix then
		for _, node in ipairs(prefix) do
			r[#r+1] = node
		end
	end

	local tokensok = true
	for node in pathinfo:gmatch("[^/]+") do
		local tkey, tval
		if tokensok then
			tkey, tval = node:match(";(%w+)=([a-fA-F0-9]*)")
		end
		if tkey then
			context.urltoken[tkey] = tval
		else
			tokensok = false
			r[#r+1] = node
		end
	end

  if cgi.query_string ~= "" then
    urlcode.parsequery(cgi.query_string, context.query)
  end
  if cgi.content_data ~= "" then
    cgi.content_data = json.decode(cgi.content_data)
  end

	local stat, err = util.coxpcall(function()
    dispatch({ verb  = cgi.request_method,
               path  = context.request,
               query = context.query,
               data  = cgi.content_data })
	end, error500)

	luci.http.close()

	--context._disable_memtrace()
end


-- Error handler
function fail(message, module)
  if module then
    log:error("module " .. module .. ": " .. message)
  else
    log:error(message)
  end
  return json.encode({ error = message })
end


-- Dispatches a Villagebus request
-- @param request	Virtual path
function dispatch(request)
  log:debug("villagebus.dispatcher.mydispatch\n" ..
            " -> " .. json.encode(request))
  
  -- dispatch request
  local name = table.remove(request.path, 1)
  local module = modules[name]       
  local response = nil
  
  if type(module) ~= "table" then
    response = fail("Could not resolve module for name: " .. (name or "nil"))
  elseif module["evaluate"] then       -- look for an 'evaluate' function
    log:info(name .. ".evaluate(" .. json.encode(request) .. ")")
    response = module["evaluate"](request, luci.http)
  elseif module[request.verb] then     -- try REST verbs
    log:info(name .. "." .. request.verb .. "(" .. json.encode(request) .. ")")
    response = module[request.verb](request, luci.http)
  else                                 -- search module methods
    local method = table.remove(request.path, 1)
    if type(module[method]) == "table" and module[method][request.verb] then
      log:info(request.verb .. " " .. name .. "." .. method .. "(" .. json.encode(request) .. ")")
      response = module[method][request.verb](request)
    elseif module[method] then
      log:info(request.verb .. " " .. name .. "." .. method .. "(" .. json.encode(request) .. ")")
      response = module[method](request)
    else
      response = fail("Could not resolve name '" .. method .. "' in module: " .. name)
    end
  end
    
  -- send response
  if response then
    --luci.http.prepare_content("text/plain")
    luci.http.prepare_content("application/json")
    luci.http.status(200, "OK") -- TODO status codes
    luci.http.write(json.encode(response))
    log:info("RESPONSE: " .. json.encode(response))
  else
    log:info("RESPONSE: stdout")
  end

end


