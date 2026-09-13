local module = {}

local tree = {
	["1C"] = {
		Unlocks = {"2C", "3C"},
	},
	["3C"] = {
		Unlocks = {"4C"}
	}
}

function module.returnData(upgradeNumber)
	return tree[upgradeNumber]["Unlocks"]
end

return module
