rust = {}
function rust.Notice(netuser, message)
	_OxideIde_.LogCall("rust.Notice('" .. netuser.displayName .. "', '" .. message .. "')")
end

function rust.FindNetUsersByName(username)
	_OxideIde_.LogCall("rust.FindNetUserByName('" .. username .. "')")
	return true, _OxideIde_.InstantiateTemplate("NetUser",{displayName = username})
end

function rust.RunClientCommand(netuser, message)
	_OxideIde_.LogCall("rust.RunClientCommand('" .. netuser.displayName .. "', '" .. message .. "')")
end

function rust.BroadcastChat( message )
	_OxideIde_.LogCall("rust.BroadcastChat('" .. message .. "')")
end

--Dont know if you can override in lua so check this
--[[
function rust.BroadcastChat(name, message)
	_OxideIde_.LogCall("rust.BroadcastChat('" .. name .. "', '" .. message .. "')")
end

--]]

function rust.CommunityIDToSteamID( id )
	_OxideIde_.LogCall("rust.CommunityIDToSteamID('" .. id "')")
end

function rust.GetAllNetUsers()
	_OxideIde_.LogCall("rust.GetAllNetUsers()")
end

function rust.GetDatablockByName( name )
	_OxideIde_.LogCall("rust.GetDatablockByName('" .. name .. "')")
end

function rust.GetUserID ( netuser )
	_OxideIde_.LogCall("rust.GetUserID('" .. netuser.displayName .. "')")
end

function rust.InventorySlotPreference( kind, stack, flags )
	_OxideIde_.LogCall("rust.InventorySlotPreference('" .. kind .. "', '" .. stack "', '" .. flags "')")
end

function rust.NetUserFromNetPlayer( netplayer )
	_OxideIde_.LogCall("rust.NetUserFromNetPlayer('" .. netplayer .. "'")
end

function rust.RunServerCommand( cmd )
	_OxideIde_.LogCall("rust.RunServerCommand('" .. cmd .. "')")
end

function rust.SendChatToUser( netuser, message )
	_OxideIde_.LogCall("rust.SendChatToUser('" .. netuser.displayName .. "', '" .. message .. "')")
end

--Dont know if you can override in lua so check this
--[[
function rust.SendChatToUser( netuser, name, message )
	_OxideIde_.LogCall("rust.SendChatToUser('" .. netuser.displayName .. "', '" .. name .. "', '" .. message .. "')")
end
--]]

function rust.ServerManagement()
	_OxideIde_.LogCall("rust.ServerManagement()")
end