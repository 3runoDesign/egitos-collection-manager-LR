local LrDialogs = import 'LrDialogs'
local LrTasks = import 'LrTasks'
local LrApplication = import 'LrApplication'
local LrView = import 'LrView'

local function getTranslations(lang)
    local translations = {
        en = {
            create_collections_title = "Create Collections",
            create_collections_prompt = "Enter collection names separated by commas:",
            create_collections_messageSuccess = "Collections Created",
            create_collections_messageInfo = "The following collections were created: ",
        },
        pt = {
            create_collections_title = "Criar Coleções",
            create_collections_prompt = "Insira os nomes das coleções separados por vírgulas:",
            create_collections_messageSuccess = "Coleções Criadas",
            create_collections_messageInfo = "As seguintes coleções foram criadas: ",
        }
    }
    
    return translations[lang] or translations.en
end

local function getCurrentLanguage()
    return 'pt'
end

local lang = getCurrentLanguage()
local t = getTranslations(lang)

local function createCollections(collectionNames)
    local catalog = LrApplication.activeCatalog()
    catalog:withWriteAccessDo(t.create_collections_title, function()
        for _, name in ipairs(collectionNames) do
            catalog:createCollection(name, nil, true)
        end
    end)
end

local function showInputDialog()
    local f = LrView.osFactory()
    local inputField = f:edit_field{
        value = "1.1 Detalhes, 1.2 Noivo, 1.3 Amigos, 1.4 Família, 2.1 Detalhes, 2.2 Robe, 2.3 Amigas, 2.4 Família, 2.5 Vestido, 3 Decoração, 4.1 Entradas, 4.2 Cerimonia, 4.3 Saida, 5 Ensaio do Casal, 6 Brinde, 7 Convidados, 8 Pista de dança, 9 Buquê, 10 Gravata, 11 Cerimonial",
        width_in_chars = 50, 
        height_in_lines = 10,
        multi_line = true,
    }

    local result = LrDialogs.presentModalDialog({
        title = t.create_collections_title,
        contents = f:row{
            f:static_text{ title = t.create_collections_prompt },
            inputField,
        },
    })

    if result == "ok" then
        local collectionNames = {}
        local inputText = inputField.value
        for name in string.gmatch(inputText, '([^,]+)') do
            table.insert(collectionNames, name:match("^%s*(.-)%s*$"))
        end
        createCollections(collectionNames)
        LrDialogs.message(t.create_collections_messageSuccess, t.create_collections_messageInfo .. inputText)
    end
end

LrTasks.startAsyncTask(function()
    showInputDialog()
end)