util = {}

function util.ArrayFromTable( type, table )
	_OxideIde_.LogCall("util.ArrayFromTable('" .. type .. "', '" .. table .. "')")
	--Description: Returns an array of the specified .net type populated by the table
	--ToDo: convert the table to the specified .NET array and return the arrray
end

function util.ArrayToTable( array )
	_OxideIde_.LogCall("util.ArrayToTable('" .. array .. "')")
	--Description: Converts the specified array to a Lua table
	--ToDo: convert the .NET array into a Lua table and return the table
end

function util.FindOverload( array, table )
	_OxideIde_.LogCall("util.FindOverload('" .. array .. "', '" .. table .. "')")
	--Description: Gets a specific overload from a MethodInfo array and optionally filters them by name
	--ToDo: Return the correct System.Reflection.MethodInfo
end

function util.GetDatafile( name )
	_OxideIde_.LogCall("util.GetDatafile('" .. name .. "')")
	--Description: Returns a data file that can be used to store and retrieve persistent data. This object is cached by Oxide but calling it again will reload the data file. The data file can be found at "data/name.txt".
	--ToDo: return the datafile
end

function util.GetFieldGetter( type, name )
	_OxideIde_.LogCall("util.GetFieldGetter('" .. type .. "', '" .. name .. "')")
	--Description: Returns a function that when called with an object, returns the value of the specified field on that object
	--ToDo: Return the correct function
end

function util.GetPropertyGetter( type, name )
	_OxideIde_.LogCall("util.GetPropertyGetter('" .. type .. "', '" .. name .. "')")
	--Description: Returns a function that when called with an object, returns the value of the specified property on that object
	--ToDo: Return the correct function
end

function util.GetStaticFieldGetter( type, name )
	_OxideIde_.LogCall("util.GetStaticFieldGetter('" .. type .. "', '" .. name .. "')")
	--Description: Returns a function that when called, returns the value of the specified static field
	--ToDo: Return the correct function
end

function util.GetStaticMethod( type, name )
	_OxideIde_.LogCall("util.GetStaticMethod('" .. type .. "', '" .. name .. "')")
	--Description: Looks up the specified method on the specified type and returns a Lua function to call it
	--ToDo: Return the correct function
end

function util.GetStaticPropertyGetter( type, name )
	_OxideIde_.LogCall("util.GetStaticPropertyGetter('" .. type .. "', '" .. name .. "')")
	--Description: Returns a function that when called, returns the value of the specified static property
	--ToDo: Return the correct function
end

function util.QuoteSafe(input)
	_OxideIde_.LogCall("rust.QuoteSafe('" .. input .. "')")
	return string.gsub(input, '"', '\\"')
end

function util.ReportError( error )
	_OxideIde_.LogCall("rust.ReportError('" .. error .. "')")
	--Description: Outputs the specified error to the log
	--ToDo: Log at the correct place
end