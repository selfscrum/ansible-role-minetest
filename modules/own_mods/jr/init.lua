local default_path = minetest.get_modpath("default") and default

jr = {
	send_interval = tonumber(minetest.settings:get("jr.send_interval")) or 2,
	bridge = {}
}

local MP = minetest.get_modpath("jr")
dofile(MP.."/common.lua")
dofile(MP.."/jrblock.lua")


-- optional jr-bridge stuff below
local http = minetest.request_http_api()

print (">>>")
print (http)

if http then
	local jr_url = minetest.settings:get("jr.url")
	local jr_user = minetest.settings:get("jr.user")
	local jr_password = minetest.settings:get("jr.password")

	if not jr_url then error("jr.url is not defined") end
	if not jr_user then error("jr.user is not defined") end
	if not jr_password then error("jr.password is not defined") end

	print("[JR] starting jr-bridge with endpoint: " .. jr_url)
	dofile(MP .. "/bridge/init.lua")

	-- initialize bridge
	jr.bridge_init(http, jr_url, jr_user, jr_password)

else
	print("[JR] bridge not active")
end

print("[OK] JR")

