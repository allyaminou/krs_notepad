Krs_notepad

* - Instalation

* -- ox_inventory/modules/items/client.lua
* -- ox_inventory/data/items.lua
```lua
Item('notepad', function(data, slot)
	local metadata = slot.metadata

	exports.krs_notepad:openNotepad(metadata)
end)



	['notepad'] = {
		label = 'Notepad',
		consume = 0,
	},
