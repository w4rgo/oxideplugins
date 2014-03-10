LogLevel = { Info = "Icons/Log/info.png", Error ="Icons/Log/error.png", Function ="Icons/Log/function.png"}

_OxideIde_ = {}

function _OxideIde_.LogCall(message)
	_OxideIde_.Log(LogLevel.Function, message)
end

function _OxideIde_.InstantiateTemplate(name, overrides)
	local template = _OxideIde_.Templates[name]
	local klass = template:CreateInstance(_OxideIde_.ParameterFactory)
	local instance = klass:GetParameterValue()
	if overrides then
		for k,v in pairs(overrides) do
			instance[k] = v
		end
	end
	return instance
end

print = function(message)
	_OxideIde_.Log(LogLevel.Info, message)
end