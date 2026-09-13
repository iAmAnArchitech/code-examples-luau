local Currency = require("../Currency")
local Tree = require("./Tree")

local uf = {}

local function setAttributeToUpgrade(upgradeNum, attribute, val)
	game.Workspace.Upgrades:FindFirstChild(upgradeNum):SetAttribute(attribute, val)
end

local counters = {}
local function newCounter(num)
	if not counters[num] then
		counters[num] = 0
	end
end


local dataFunction = {
	["1C"] = function()
		setAttributeToUpgrade("1C", "Purchases", "1/1")
		Currency.perSecAdd(1, "Cent", "Add")
	end,
	["2C"] = function()
		setAttributeToUpgrade("1C", "Purchases", "1/1")
		Currency.perSecAdd(2, "Cent", "Add")
	end,
	["3C"] = function()
		local produced = 0
		local function SeperateThread()
			while true do
				Currency.perSecAdd(0.05, "Cent", "Add")
				produced += 0.05
				setAttributeToUpgrade("1C", "Purchases", tostring(produced))
				task.wait(1)
			end
		end
		task.spawn(SeperateThread)
	end,
	["4C"] = function()
		counters["4C"] += 1
		setAttributeToUpgrade("1C", "Purchases", tostring(counters["4C"]).."/10")
		Currency.perSecAdd(2, "Cent", "Add")
	end,
}

local hasBought = {}
local purchases = {}

function uf.execute(upgradeNum, price, maxPurchases)
	price = tonumber(price)
	maxPurchases = tonumber(maxPurchases)
	if Currency.returnCur("Cent").Value >= price then
		Currency.currencyAdd(price, "Cent", "Sub")
	else
		return
	end
	
	purchases[upgradeNum] = (purchases[upgradeNum] or 0)

	if purchases[upgradeNum] >= maxPurchases then
		return
	end

	local upgradeModel = game.Workspace.Upgrades:FindFirstChild(tostring(upgradeNum))
	game.ReplicatedStorage.Events.Upgrade.TweenFOV:FireAllClients(90, 0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

	for _, node in upgradeModel.Nodes:GetChildren() do
		node.Transparency = 0
		node.CastShadow = true
	end

	local func = dataFunction[tostring(upgradeNum)]
	if func then
		newCounter(upgradeNum)
		func()

		local function unlock()
			local data = Tree.returnData(upgradeNum)
			for _, upgrade in ipairs(data) do
				game.ReplicatedStorage.Events.Upgrade.MakeVisible:Fire(tostring(upgrade))
			end
		end
		
		task.spawn(unlock)
	end

	purchases[upgradeNum] += 1

	if purchases[upgradeNum] >= maxPurchases then
		hasBought[upgradeNum] = true
		upgradeModel:SetAttribute("Purchased", true)
	end

	upgradeModel:SetAttribute("PurchaseCount", purchases[upgradeNum])
end

return uf
