jr.can_interact = function(pos, player)
  if not player then
    return false
  end

  local meta = minetest.get_meta(pos)
  local owner = meta:get_string("owner")
  local playername = player:get_player_name()

  if playername == owner then
    return true
  end

  return false
end
