function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

--team setting
function isEqual(a,b)

   local function isEqualTable(t1,t2)

      if t1 == t2 then
         return true
      end

      for k,v in pairs(t1) do

         if type(t1[k]) ~= type(t2[k]) then
            return false
         end

         if type(t1[k]) == "table" then
            if not isEqualTable(t1[k], t2[k]) then
               return false
            end
         else
            if t1[k] ~= t2[k] then
               return false
            end
         end
      end

      for k,v in pairs(t2) do

         if type(t2[k]) ~= type(t1[k]) then
            return false
         end

         if type(t2[k]) == "table" then
            if not isEqualTable(t2[k], t1[k]) then
               return false
            end
         else
            if t2[k] ~= t1[k] then
               return false
            end
         end
      end

      return true
   end

   if type(a) ~= type(b) then
      return false
   end

   if type(a) == "table" then
      return isEqualTable(a,b)
   else
      return (a == b)
   end

end

getDistinctTeams = function()
  local allPlayers = Player.GetPlayers(function(Player) 
    return not Player.HasNoRequiredUnits()
  end)

  local allPlayerTeams = {}
  for k,v in ipairs(allPlayers) do
    local currentPlayer = v
      local playerTeam = {}   

      for k,v in ipairs(allPlayers) do
      if currentPlayer.IsAlliedWith(v) then
        table.insert(playerTeam, v)
      end
      end

      allPlayerTeams[k] = playerTeam
  end

    for key,value in ipairs(allPlayerTeams) do
      currentPlayerTeam = value

      for k,v in ipairs(allPlayerTeams) do
        if isEqual(currentPlayerTeam, v) and k ~= key then
          allPlayerTeams[k] = {}
        end 
      end
  end

  local distinctTeams = {}
    for k,v in ipairs(allPlayerTeams) do
      if #v > 0 then
        table.insert(distinctTeams, v)
    end
    end 

   --  for k,v in ipairs(distinctTeams) do
   --   local TeamNumber = k

    --   for k,v in ipairs(v) do
      -- Media.DisplayMessage("TeamNumber: " .. TeamNumber .. " Player " .. v.InternalName)
    --   end
   --  end

   return distinctTeams

end

getPlayerActors = function(Player)
  return Map.ActorsInBox(Map.TopLeft, Map.BottomRight, function(Actor) return Actor.Owner == Player end)
end

-- Resource Sharing
ShareCashAndResources = function()
	local function share(Team)
		local totalCashInTeam = 0
	    for k,v in ipairs(Team) do
	    	totalCashInTeam = totalCashInTeam + v.Cash
	    end			

		local totalResourcesInTeam = 0
	    for k,v in ipairs(Team) do
	    	totalResourcesInTeam = totalResourcesInTeam + v.Resources
	    end			

	    local averageCashInTeam = round(totalCashInTeam / #Team, 0)
	    local averageResourcesInTeam = round(totalResourcesInTeam / #Team, 0)

	    for k,v in ipairs(Team) do
    		v.Cash = averageCashInTeam
    		v.Resources = averageResourcesInTeam
	    end
	end

	local distinctTeams = getDistinctTeams()

    for k,v in ipairs(distinctTeams) do
    	if #v > 1 then
    		share(v)
		  end
    end
end

Tick = function()
  if (DateTime.GameTime == 0) then
    --setup melee bases
    
  end
    
  --if (Map.LobbyOption("team-melee")) then
	  if (DateTime.GameTime % DateTime.Seconds(1) == 0) then
		  ShareCashAndResources()
	  end
	--end
end