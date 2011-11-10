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

require "luci.sys.iptparser" -- http://luci.subsignal.org/api/luci/modules/luci.sys.iptparser.html
local ipt = luci.sys.iptparser.IptParser(6)


--[[ utilities ]]--

-- Return the output of a shell command as a string
function os.pexecute(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end



--[[ modules.portalgun ]]--
module("modules.portalgun", package.seeall)

-- also see: http://quamquam.org/~jow/luci-splash


-- list
function list(request, response)
  --local rules = ipt:find({ target   = "REJECT", 
  --                         protocol = "tcp", 
  --                         options  = { "reject-with", "tcp-reset" } }) 
  
  ipt:resync()
  --[[local tables = ipt:tables()
  log:debug("tables: " .. json.encode(tables))
  for _,table in ipairs(tables) do
    local chains = ipt:chains(table)
    log:debug("  " .. table .. " -> chains: " .. json.encode(chains))
    for _,chain in ipairs(chains) do
      local rules = ipt:chain(table, chain)
      log:debug("    " .. table .. " ->  " .. chain .. ": " .. json.encode(rules))
    end
  end ]]--

  if not request.path[1] then
    local rules = ipt:chain("filter", "PORTALGUN")
    return rules["rules"] or {} 
  else
    local rule = ipt:find({ table  = "filter",
                            chain  = "PORTALGUN",
                            source = request.path[1] })
    return rule
  end

end


-- query status for a portal
function status(request, response)
  return { status = request }
end

-- TODO implement DELETE for lucid so we can have proper REST semantics
function post(request, response)
  log:debug("portalgun.post" ..
            " -> " .. json.encode(request))

  ipt:resync()

  local ipaddr = request.path[1]
  if not ipaddr then
    return { error = "usage: /portalgun/post/<ip address>" }
  end

  -- check if portal already exists
  local rule = ipt:find({ table  = "filter",
                          chain  = "PORTALGUN",
                          source = ipaddr })  
  if rule[1] then
    return rule
  end

  -- insert rules for portal
  local ret = ip6tables("I", "PORTALGUN", { source = ipaddr,
                                            jump   = "ACCEPT" })
  if ret ~= 0 then
    return { error = "failed to create portal: " .. ipaddr }
  end

  return ipt:find({ table  = "filter",
                    chain  = "PORTALGUN",
                    source = ipaddr })
end


-- /portalgun/delete/<ipaddr> -> {}
function delete(request, response)
  log:debug("portalgun.delete" ..
            " -> " .. json.encode(request))

  ipt:resync()

  local ipaddr = request.path[1]
  if not ipaddr then
    return { error = "usage: /portalgun/delete/<ip address>" }
  end

  -- check that portal exists
  local rule = ipt:find({ table  = "filter",
                          chain  = "PORTALGUN",
                          source = ipaddr })  
  if not rule[1] then
    return { }
  end
  
  -- delete rules for portal
  local ret = ip6tables("D", "PORTALGUN", { source = ipaddr,
                                            jump   = "ACCEPT" })
  if ret ~= 0 then
    return { error = "failed to delete portal: " .. ipaddr }
  end
  
  -- returns: {} on success
  return ipt:find({ table  = "filter",
                    chain  = "PORTALGUN",
                    source = ipaddr })
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



-- iptables
--   # alllow a specific ipv6 host
--   ip6tables -I PORTALGUN -s 2001:470:1f07:c42:1e4b:d6ff:fe80:dada -j ACCEPT #-m comment --comment "client beta"
--   
--   # remove a specific ipv6 host
--   ip6tables -D PORTALGUN -s 2001:470:1f07:c42:1e4b:d6ff:fe80:dada -j ACCEPT #-m comment --comment "client beta"
--
function ip6tables(action, chain, rulespec, options)
  local args = "-" .. action .. " " .. chain 
  for switch, value in pairs(rulespec) do
    args = args .. " --" .. switch .. " " .. value
  end
  
  log:debug("running: ip6tables " .. args)
  local ret = os.execute("ip6tables " .. args) 
  log:debug("returned: " .. ret)

  ipt:resync()

  return ret
end
