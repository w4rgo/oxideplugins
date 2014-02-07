PLUGIN.Title = "Stats"
PLUGIN.Description = "Stores stats from the players - version 1.2"
--By W4rGo 

function PLUGIN:Init()
    print( "Loading Stats..." )   
	self.DataFile = util.GetDatafile("stats")
	local txt = self.DataFile:GetText()
	if (txt ~= "") then
		self.Data = json.decode( txt )
	else
		self.Data = {}
		self.Data.Users = {}
	end
    
    -- Count and output the number of users
	local cnt = 0
	for _, _ in pairs( self.Data.Users ) do cnt = cnt + 1 end
	print( tostring( cnt ) .. " users are tracked by Stats!" )
    
    self:AddChatCommand("stats", self.cmdStats)
    self:AddChatCommand("ranking", self.cmdRanking)
    self:AddChatCommand("shelp", self.cmdShelp)	
end


function PLUGIN:SendHelpText( netuser )
    rust.SendChatToUser( netuser, "Use /shelp to learn about the leaderboards." )
end

function PLUGIN:OnKilled (takedamage, dmg)
    if (takedamage:GetComponent( "HumanController" )) then
        local victim = takedamage:GetComponent( "HumanController" )
        if (victim) then
            local netplayer = victim.networkViewOwner
            if (netplayer) then
                local netuser = rust.NetUserFromNetPlayer( netplayer )
                if (netuser) then
                    if ((dmg.attacker.client) and (dmg.attacker.client.netUser)) then
                     local killer = dmg.attacker.client.netUser
	               local killed = netuser
                       if(killer==killed) then
	                       --SUICIDE
	                       local datakiller = self:GetUserData( killer )
	                       datakiller.Suicides = datakiller.Suicides + 1
	                       self:Save()
			     else
			     	    --PVP
				     local datakiller = self:GetUserData( killer )
				     local datakilled= self:GetUserData( killed )
				     datakiller.Kills= datakiller.Kills + 1
				     datakilled.Deaths= datakilled.Deaths + 1
				     self:Save()
			     end
                    end
                end
            end
        end
    end
    
    if (takedamage:GetComponent( "ZombieController" )) then
        -- Do zombie death code here
         if ((dmg.attacker.client) and (dmg.attacker.client.netUser)) then
	        local killer = dmg.attacker.client.netUser
	        local datakiller = self:GetUserData( killer )
	        datakiller.Zombies= datakiller.Zombies + 1
         end
    end
    
    
    
end

-- *******************************************
-- PLUGIN:Save()
-- Saves the player data to file
-- *******************************************
function PLUGIN:Save()
	self.DataFile:SetText( json.encode( self.Data ) )
	self.DataFile:Save()
end


-- *******************************************
-- PLUGIN:GetUserData()
-- Gets a persistent table associated with the given user
-- *******************************************
function PLUGIN:GetUserData( netuser )
	local userID = rust.GetUserID( netuser )
	return self:GetUserDataFromID( userID, netuser.displayName )
end

-- *******************************************
-- PLUGIN:GetUserDataFromID()
-- Gets a persistent table associated with the given user ID
-- *******************************************
function PLUGIN:GetUserDataFromID( userID, name )
	local userentry = self.Data.Users[ userID ]
	if (not userentry) then
		userentry = {}
		userentry.Name = name
		userentry.Kills = 0
		userentry.Deaths = 0
		userentry.Suicides=0
		userentry.Zombies=0
		self.Data.Users[ userID ] = userentry
		self:Save()
	else 
		if (not userentry.Suicides) then
			userentry.Suicides=0
			self:Save()
		end
		if (not userentry.Zombies) then
			userentry.Zombies=0
			self:Save()
		end
		
	end
	return userentry
end

function PLUGIN:cmdStats( netuser, cmd, args )
    if (not args[1]) then
        self:printStats(netuser)
        return
    end
end

function PLUGIN:printStats(netuser)
    rust.SendChatToUser( netuser, "Stats:")
    
    local playerdata = self:GetUserData( netuser )
    
    rust.SendChatToUser( netuser,"Kills: " .. tostring(playerdata.Kills))
    rust.SendChatToUser( netuser,"Deaths: " .. tostring(playerdata.Deaths))
     rust.SendChatToUser( netuser,"Suicides: " .. tostring(playerdata.Suicides))
      rust.SendChatToUser( netuser,"Zombies: " .. tostring(playerdata.Zombies))
end

function PLUGIN:cmdRanking( netuser, cmd, args )
    if (not args[1]) then
    		rust.SendChatToUser( netuser, "-------------------------- W4rGo's Rankings -------------------------------" )
    		rust.SendChatToUser( netuser, "/ranking killers = Top 10 killers")
    	 	rust.SendChatToUser( netuser, "/ranking deaths = Top 10 deaths")
    	 	rust.SendChatToUser( netuser, "/ranking zombies = Top 10 zombies")
    	 	rust.SendChatToUser( netuser, "/ranking suicides = Top 10 suicides")
             rust.SendChatToUser( netuser, "--------------------------------------------------------------------------------" ) 
        return
    end
    
    if(args[1] == "killers" or args[1] == "deaths" or args[1] == "zombies" or args[1] == "suicides" ) then
    		tablerank=self:generateRanking(args[1])
             self:printRanking(netuser,tablerank,args[1])
             return
    end
    
    		rust.SendChatToUser( netuser, "-------------------------- W4rGo's Rankings -------------------------------" )
    		rust.SendChatToUser( netuser, "/ranking killers = Top 10 killers")
    	 	rust.SendChatToUser( netuser, "/ranking deaths = Top 10 deaths")
    	 	rust.SendChatToUser( netuser, "/ranking zombies = Top 10 zombies")
    	 	rust.SendChatToUser( netuser, "/ranking suicides = Top 10 suicides")
             rust.SendChatToUser( netuser, "--------------------------------------------------------------------------------" ) 
    
end

function PLUGIN:cmdShelp( netuser, cmd, args )
    rust.SendChatToUser( netuser, "--------------------------------------------------------------------------------" )
    rust.SendChatToUser( netuser, "------------------------- W4rGo's Stats Plugin ----------------------------" )
    rust.SendChatToUser( netuser, "Use /stats to see your stats and /ranking to see the top 10" )
    rust.SendChatToUser( netuser, "--------------------------------------------------------------------------------" )
end

function PLUGIN:generateRanking(var)

    local allusers = self.Data.Users
    local currentTop={}
    local table = {}
    
    for k,v in pairs(allusers) do
    
    	if(var=="killers") then
		table[k]=v.Kills
	elseif(var=="deaths") then
		table[k]=v.Deaths
	elseif(var=="zombies")then
		table[k]=v.Zombies
	elseif(var=="suicides")then
		table[k]=v.Suicides
	end
     end
   return table
end

function PLUGIN:printRanking(netuser,killertable,var)

    rust.SendChatToUser( netuser, "--------------------------------------------------------------------------------" )
    rust.SendChatToUser( netuser, "Top 10 ".. var .. ":")
    rust.SendChatToUser( netuser, "--------------------------------------------------------------------------------" )
    
    local count = 1
    local limit = 10
    for k,v in spairs(killertable, function(t,a,b) return t[b] < t[a] end) do
         user=self.Data.Users[k]
         
         if(var=="killers") then
		variable=user.Kills
	elseif(var=="deaths") then
		variable=user.Deaths
	elseif(var=="zombies")then
		variable=user.Zombies
	elseif(var=="suicides")then
		variable=user.Suicides
	end

   	   rust.SendChatToUser( netuser, count.. "- " .. user.Name .. " : " .. variable)
   	   
   	   if(count >= limit) then
   	       rust.SendChatToUser( netuser, "--------------------------------------------------------------------------------" )
   	   	return
   	   end
   	   count = count +1
    end
    

    --rust.SendChatToUser( netuser, "Top 10 Losers:")
    --rust.SendChatToUser( netuser, "TODO")
end


--GENERIC ORDERED PAIRS ITERATOR FROM STACK OVERFLOW 
--http://stackoverflow.com/questions/15706270/sort-a-table-in-lua
function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end



function PLUGIN:GetUserDataFromName(name)
    for key,value in pairs(self.Data) do
        if (value.Name == name) then
            return value
        end
    end
    return nil
end