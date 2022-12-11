local ADDON = LibStub("AceAddon-3.0"):GetAddon("Inventorian")
local InvBoE = ADDON:NewModule('InventorianFeatures')

function InvBoE:Item_SetItem()
	self.ItemBoe:Hide()
	
	if not self.item or self:IsCached() then --Slot is Empty or Offline Mode (dont have required informatio)
		return
	end

	local _, _, _, quality, _, _, link, _, itemID, isBound = self:GetInfo()
	if quality and isBound == false then
		local _, _, _, _, _, itemClass = GetItemInfoInstant(itemID)
		if quality >= Enum.ItemQuality.Uncommon and (itemClass == Enum.ItemClass.Weapon or itemClass == Enum.ItemClass.Armor) then
			local r, g, b, hex = GetItemQualityColor(quality)
			self.ItemBoe:SetFormattedText('|c%s%s|r', hex, 'BoE')
			self.ItemBoe:Show()
		end
	end
end
function InvBoE:WrapItemButton(item)
	if not item.ItemBoe then
		local BoeFrame = CreateFrame("FRAME", 'BOEFrame', item)
		BoeFrame:SetFrameLevel(4)
		BoeFrame:SetAllPoints()
		
		item.ItemBoe = BoeFrame:CreateFontString('$parentItemLevel', 'ARTWORK')
		item.ItemBoe:SetPoint('BOTTOM', 0, 0)
		item.ItemBoe:SetFontObject(NumberFontNormalSmall)
		item.ItemBoe:SetJustifyH('CENTER')
		item.ItemBoe:Show()
	end
	
	hooksecurefunc(item, "SetItem", InvBoE.Item_SetItem)
	item:HookScript("OnEvent", InvBoE.Item_SetItem, LE_SCRIPT_BINDING_TYPE_INTRINSIC_POSTCALL)
	return item
end
hooksecurefunc(ADDON.Item, "WrapItemButton", InvBoE.WrapItemButton)
