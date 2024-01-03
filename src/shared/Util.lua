local UtilModule = {}

function UtilModule:SetInstanceProperties(Instance: Instance, PropertyTable: table?)
	for Property, Value in pairs(PropertyTable) do
		Instance[Property] = Value
	end
	return Instance
end

function UtilModule:NewInstanceWithProperties(ClassName: string, PropertyTable: table, Parent: Instance?)
	local NewInstance = UtilModule:SetInstanceProperties(Instance.new(ClassName), PropertyTable)
	NewInstance.Parent = Parent
	return NewInstance
end

return UtilModule