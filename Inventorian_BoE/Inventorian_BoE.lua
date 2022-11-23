local ADDON = LibStub("AceAddon-3.0"):GetAddon("Inventorian")
local InvBoE = ADDON:NewModule('InventorianBoE')

function InvBoE:Update()
	local item = self
	
	if self:IsVisible() then
		self.ItemBoe:Hide()
	end
	
	local _, _, _, quality, _, _, link, _, itemID, isBound = self:GetInfo()
	--slot is empty or item is bound already, dont do nothing

	if not itemID or isBound then return end
	
	local function Check(self, quality, itemID)
		local _, _, _, _, _, itemClass = GetItemInfoInstant(itemID)
		if quality >= Enum.ItemQuality.Uncommon and (itemClass == Enum.ItemClass.Weapon or itemClass == Enum.ItemClass.Armor) then
			local r, g, b, hex = GetItemQualityColor(quality)
			item.ItemBoe:SetFormattedText('|c%s%s|r', hex, 'BoE')
			item.ItemBoe:Show()
		end
	end
	
	if quality then
		Check(self, quality, itemID)
	else
		local _item = Item:CreateFromBagAndSlot(self.bag, self.slot)
		_item:ContinueOnItemLoad(function()
			quality = select(4, self:GetInfo())
			Check(self, (quality and quality or 0), itemID)
		end)
	end
end

function InvBoE:WrapItemButton(item)
	if not item.ItemBoe then
		local overlayFrame = CreateFrame("FRAME", nil, item)
		overlayFrame:SetFrameLevel(4)
		overlayFrame:SetAllPoints()
		
		item.ItemBoe = overlayFrame:CreateFontString('$parentItemLevel', 'ARTWORK')
		item.ItemBoe:SetPoint('BOTTOM', 0, 0)
		item.ItemBoe:SetFontObject(NumberFontNormalSmall)
		item.ItemBoe:SetJustifyH('CENTER')
		item.ItemBoe:Show()
	end
	
	hooksecurefunc(item, "Update", InvBoE.Update)

	return item
end
hooksecurefunc(ADDON.Item, "WrapItemButton", InvBoE.WrapItemButton)
