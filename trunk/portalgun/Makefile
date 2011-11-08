

install:
	scp    lucid/VillagebusPublisher.lua  root@192.168.20.78:/usr/lib/lua/luci/lucid/http
	scp -r lucid/handler/*.lua            root@192.168.20.78:/usr/lib/lua/luci/lucid/http/handler

	ssh root@192.168.20.78  mkdir -p /usr/lib/lua/villagebus/modules
	scp -r villagebus/modules/*.lua   root@192.168.20.78:/usr/lib/lua/villagebus/modules
	scp    villagebus/urlcode.lua     root@192.168.20.78:/usr/lib/lua/villagebus
	scp    villagebus/dispatcher.lua  root@192.168.20.78:/usr/lib/lua/villagebus


test:	
	scp -r villagebus/modules/*.lua   root@192.168.20.78:/usr/lib/lua/villagebus/modules
	scp    villagebus/urlcode.lua     root@192.168.20.78:/usr/lib/lua/villagebus
	scp    villagebus/dispatcher.lua  root@192.168.20.78:/usr/lib/lua/villagebus
	ssh root@192.168.20.78 /etc/init.d/lucid restart	
	#curl -k -i -X POST -d '{"a":"b"}' 'https://192.168.20.78/villagebus/portalgun/clients?q=foo&bar=ploink'
	#curl -k -i 'https://192.168.20.78/villagebus/http/g7.org.za/blank.html' 
	curl -k -i 'https://192.168.20.78/villagebus/portalgun/foo' 	
	@echo

