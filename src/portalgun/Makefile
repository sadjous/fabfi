
HOST=2001:470:8c0e:7::78
#HOST=2001:470:8c0e:fab:218:aff:fe01:107d


install:
	scp    lucid/VillagebusPublisher.lua  root@[$(HOST)]:/usr/lib/lua/luci/lucid/http
	scp -r lucid/handler/*.lua            root@[$(HOST)]:/usr/lib/lua/luci/lucid/http/handler

	ssh root@$(HOST)  mkdir -p /usr/lib/lua/villagebus/modules
	scp -r villagebus/modules/*.lua   root@[$(HOST)]:/usr/lib/lua/villagebus/modules
	scp    villagebus/urlcode.lua     root@[$(HOST)]:/usr/lib/lua/villagebus
	scp    villagebus/dispatcher.lua  root@[$(HOST)]:/usr/lib/lua/villagebus


test:	
	scp villagebus/modules/portalgun.lua   root@[$(HOST)]:/usr/lib/lua/villagebus/modules	
	#scp -r villagebus/modules/*.lua   root@[$(HOST)]:/usr/lib/lua/villagebus/modules
	#scp    villagebus/urlcode.lua     root@[$(HOST)]:/usr/lib/lua/villagebus
	#scp    villagebus/dispatcher.lua  root@[$(HOST)]:/usr/lib/lua/villagebus
	ssh root@$(HOST) /etc/init.d/lucid restart	
	@echo
	@#curl -k -i 'https://$(HOST)/villagebus/portalgun/post/ip6addr/2001:470:1f07:c42:1e4b:d6ff:fe80:dada'
	@#echo
	@#curl -k -i 'https://$(HOST)/villagebus/portalgun/list'
	@#echo
	@#curl -k -i 'https://$(HOST)/villagebus/portalgun/status?ip=2001:470:1f07:c42:1e4b:d6ff:fe80:dada' 	
	@#echo
	@#curl -k -i -X POST -d '{"a":"b"}' 'https://$(HOST)/villagebus/portalgun/portals'
	@#echo

