local udd = {}

local data = {}
local udd = {}

function udd.returnData(upgradeNumber)	
	return data[upgradeNumber]
end
local upgrades = {}
function udd.new(upgradeNum : number | "The number of the upgrade to initate")
	local upgrade = game.Workspace.Upgrades:FindFirstChild(tostring(upgradeNum))
	local unpacked = udd.returnData(upgradeNum)
	upgrade.Name = tostring(unpacked.num)
	
	upgrade:SetAttribute("Price", unpacked.price)
	upgrade:SetAttribute("MaxPurchases", unpacked.purchases)

	local gui = upgrade:FindFirstChild("Base"):FindFirstChild("SurfaceGui")
	gui:FindFirstChild("UpgradeName").Text = unpacked.name
	gui:FindFirstChild("Num").Text = unpacked.num
	gui:FindFirstChild("Upgrades").Text = unpacked.purchases
	gui:FindFirstChild("Cost").Text = unpacked.price .. unpacked.currency
	gui:FindFirstChild("Desc").Text = unpacked.desc
end

function udd.addData(upgName, upgradeNumber, purchaseAmounts, price, currency, desc)
	if not data[tostring(upgradeNumber)] then
		data[tostring(upgradeNumber)] = {}
	end
	
	data[upgradeNumber].name = tostring(upgName)
	data[upgradeNumber].num = tostring(upgradeNumber)
	data[upgradeNumber].purchases = tostring(purchaseAmounts)
	data[upgradeNumber].price = tostring(price)
	data[upgradeNumber].currency = tostring(currency)
	data[upgradeNumber].desc = tostring(desc)
	
	udd.new(upgradeNumber)
end

return udd
