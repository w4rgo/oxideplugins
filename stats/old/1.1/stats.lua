PLUGIN.Title = "Stats"
PLUGIN.Description = "Stores stats from the players - version 1.1.1"
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
			     local datakiller = self:GetUserData( killer )
			     local datakilled= self:GetUserData( killed )
			     datakiller.Kills= datakiller.Kills + 1
			     datakilled.Deaths= datakiller.Deaths + 1
			     self:Save()
                    end
                end
            end
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
		self.Data.Users[ userID ] = userentry
		self:Save()
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
end

function PLUGIN:cmdRanking( netuser, cmd, args )
    if (not args[1]) then
    		rust.SendChatToUser( netuser, "-------------------------- W4rGo's Rankings -------------------------------" )
    		rust.SendChatToUser( netuser, "/ranking kills = Top 10 killers")
    	 	rust.SendChatToUser( netuser, "/ranking deaths = Top 10 losers")
             rust.SendChatToUser( netuser, "--------------------------------------------------------------------------------" ) 
        return
    end
    
    if(args[1] == "kills") then
    		 killertable=self:generateKillersRanking()
              self:printKillersRanking(netuser,killertable)
              return
    end
    
    if(args[1] == "deaths") then
    		deathtable=self:generateDeathsRanking()
             self:printDeathsRanking(netuser,deathtable)
             return
    end
    
    rust.SendChatToUser( netuser, "-------------------------- W4rGo's Rankings -------------------------------" )
    rust.SendChatToUser( netuser, "/ranking kills = Top 10 killers")
    rust.SendChatToUser( netuser, "/ranking deaths = Top 10 losers")
    rust.SendChatToUser( netuser, "--------------------------------------------------------------------------------" )
    
end

function PLUGIN:cmdShelp( netuser, cmd, args )
    rust.SendChatToUser( netuser, "--------------------------------------------------------------------------------" )
    rust.SendChatToUser( netuser, "------------------------- W4rGo's Stats Plugin ----------------------------" )
    rust.SendChatToUser( netuser, "Use /stats to see your stats and /ranking to see the top 10" )
    rust.SendChatToUser( netuser, "--------------------------------------------------------------------------------" )
end


function PLUGIN:generateKillersRanking()
    local threshold = 10;
    local allusers = self.Data.Users
    
    local currentTop={}
    local killertable = {}
    
    for k,v in pairs(allusers) do
    		killertable[k]=v.Kills
    end
    
    return killertable
end
function PLUGIN:generateDeathsRanking()
    local threshold = 10;
    local allusers = self.Data.Users
    
    local currentTop={}
    local deathtable = {}
    
    for k,v in pairs(allusers) do
    		deathtable[k]=v.Deaths
    end
    
    return deathtable
end
function PLUGIN:printDeathsRanking(netuser,killertable)
	    rust.SendChatToUser( netuser, "--------------------------------------------------------------------------------" )
    rust.SendChatToUser( netuser, "Top 10 Losers:")
        rust.SendChatToUser( netuser, "--------------------------------------------------------------------------------" )
    local count = 1
    local limit = 10
    
    for k,v in spairs(killertable, function(t,a,b) return t[b] < t[a] end) do
         user=self.Data.Users[k]
         
   	   rust.SendChatToUser( netuser, count.."- " .. user.Name .. " : " .. user.Deaths)
   	   
   	   if(count >= limit) then
   	        rust.SendChatToUser( netuser, "--------------------------------------------------------------------------------" )
   	   	return
   	   end
   	   count = count +1
    end
   

    --rust.SendChatToUser( netuser, "Top 10 Losers:")
    --rust.SendChatToUser( netuser, "TODO")
end
function PLUGIN:printKillersRanking(netuser,killertable)
    rust.SendChatToUser( netuser, "--------------------------------------------------------------------------------" )
    rust.SendChatToUser( netuser, "Top 10 Killers:")
        rust.SendChatToUser( netuser, "--------------------------------------------------------------------------------" )
    local count = 1
    local limit = 10
    for k,v in spairs(killertable, function(t,a,b) return t[b] < t[a] end) do
         user=self.Data.Users[k]
         
   	   rust.SendChatToUser( netuser, count.. "- " .. user.Name .. " : " .. user.Kills)
   	   
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