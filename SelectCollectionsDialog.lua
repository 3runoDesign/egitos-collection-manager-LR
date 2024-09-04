local LrView = import 'LrView'
local LrDialogs = import 'LrDialogs'
local LrApplication = import 'LrApplication'

local function createSelectCollectionsDialog(collections)
    local f = LrView.osFactory()
    
    local collectionChoices = {}
    for _, collection in ipairs(collections) do
        table.insert(collectionChoices, {
            title = collection:getName(),
            value = collection
        })
    end
    
    local prop = LrBinding.makePropertyTable(context)
    
    prop.selectedCollections = LrView.bind({
        collectionChoices = collectionChoices,
        value = {} -- Default to an empty table
    })
    
    local contents = f:column {
        spacing = 10,
        f:static_text {
            title = "Select Collections to Export:",
        },
        f:checkbox {
            title = LrView.bind("collectionChoices.title"),
            value = LrView.bind("selectedCollections"),
            value = LrView.bind("collectionChoices.value"),
            spacing = 10
        },
    }
    
    local result = LrDialogs.presentModalDialog({
        title = "Select Collections",
        contents = contents,
        actionVerb = "OK"
    })
    
    return prop.selectedCollections
end

return createSelectCollectionsDialog