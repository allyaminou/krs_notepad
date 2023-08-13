Krs_notepad

* - Instalation



```lua

* -- ox_inventory/modules/items/client.lua
Item('notepad', function(data, slot)
	local metadata = slot.metadata

	exports.krs_notepad:openNotepad(metadata)
end)


* -- ox_inventory/data/items.lua
	['notepad'] = {
		label = 'Notepad',
		consume = 0,
	},
