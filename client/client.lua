local function openNui(data)
    SendNUIMessage({
        action = data.mode,
        metadata = data
    })
    SetNuiFocus(true, true)
end

RegisterNUICallback("close", function()
    SetNuiFocus(false, false)
end)


RegisterNUICallback("giveItem", function(data)
    lib.callback('krs_notepad:getName', false, function(name)
        local metadata = {}
        metadata.mode = "view"
        metadata.title = data.title
        metadata.name = data.name
        metadata.object = data.object
        metadata.guidelines = data.guidelines
        metadata.save = name
      

        print(json.encode(metadata, { indent = true }))

        TriggerServerEvent("krs_notepad:createItems", metadata)
        SetNuiFocus(false, false)
    end)
end)


exports('openNotepad', function(data)
    openNui(data)
end)


local points = {}
local notepads = {}

for i = 1, #Krs.Notepads, 1 do
    local cfg = Krs.Notepads[i]

    points[i] = lib.points.new({
        coords = cfg.coords.xyz,
        distance = 20,
        onEnter = function()
            local propHash = joaat(cfg.prop)
            local model = lib.requestModel(propHash)

            if not model then return end

            local notepad = CreateObject(model, cfg.coords)

            SetModelAsNoLongerNeeded(model)
            FreezeEntityPosition(notepad, true)
            SetEntityAsMissionEntity(notepad, 1, 1)

            table.insert(notepads, notepad)

            local options = {}

            for j = 1, #cfg.items, 1 do
                table.insert(options,
                    {
                        name = "notepad" .. j .. i .. cfg.job,
                        label = cfg.items[j].label,
                        icon = 'fa-solid fa-clipboard',
                        groups = cfg.job,
                        onSelect = function(entity)
                            local data = {}
                            data.mode = "create"
                            data.title = cfg.items[j].title
                            openNui(data)
                        end
                    }
                )
            end

            exports.ox_target:addLocalEntity(notepad, options)
        end,

        onExit = function()
            for k, v in pairs(notepads) do
                DeleteObject(v)
            end
        end,
        nearby = function(self)

        end

    })
end


AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    for k, v in pairs(notepads) do
        DeleteObject(v)
    end
end)