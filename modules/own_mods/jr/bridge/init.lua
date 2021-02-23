local MP = minetest.get_modpath("jr")

-- jr http bridge
local http, url, user, password, token, command, params, callresult

function jr.send_stats()
  print("send_stats")

  -- data to send to jr
  local data = 
  {
	  username = "restapi",
	  password = "isr2021!JR" 
  }
  local json = minetest.write_json(data)

  http.fetch({
    url = url .. "/api/rest/v2/application/tokens",
    extra_headers = { "Content-Type: application/json", "Accept: application/json" },
    timeout = 5,
    method = "POST",
    post_data = json
  }, function(res)
	  	local a = {}
		print(res.code)
		print (res.data)
		print (res.timeout)
		local d = minetest.parse_json(res.data)
		token = d.tokens[1]
		print("token = "..token)
  end)

end

function jr.bridge_init(_http, _url, _user, _password)
  http = _http
  url = _url
  user = _user
  password = _password
  minetest.after(jr.send_interval, jr.send_stats)
end


function jr.send_command(_command, _params)
  command = _command
  params = _params
  --local json = minetest.write_json(_params.data)

  print ("URL="..url.. "/api/rest/v2/" .. _command )
  print ("Method=".._params.method)
  print ("Token="..token)
  --print ("Data="..json)
  http.fetch({
    url = url .. "/api/rest/v2/" .. _command,
    extra_headers = { "Content-Type: application/json", "Accept: application/json", "X-Jobrouter-Authorization: Bearer ".. token },
    timeout = 5,
    method = _params.method,
    post_data = "" --json
  }, function(res)
	  	local a = {}
		if res.code == 401 then
			-- timeout occured
			print("could not send")
			-- jr.send_stats()
			-- jr.send_command(command, params)
		else
			print (">>command: " .. command .. " results in " .. res.code)
			print (">>command: " .. command .. " delivers  " .. res.data)
			--callresult = minetest.parse_json(res.data)
		end
  end)

end
