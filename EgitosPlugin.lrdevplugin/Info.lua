local function getTranslations(lang)
    local translations = {
        en = {
            create_collections_title = "Create Collections",
            export_photo_collection_title = "Export Photos by Collection"
        },
        pt = {
            create_collections_title = "Criar coleções",
            export_photo_collection_title = "Exportar fotos por coleção"
        }
    }
    
    return translations[lang] or translations.en
end

local function getCurrentLanguage()
    return 'pt'
end

local lang = getCurrentLanguage()
local t = getTranslations(lang)

return {
    LrSdkVersion = 6.0,
    LrSdkMinimumVersion = 3.0,
    LrToolkitIdentifier = 'com.yourdomain.ExportByCollection',
    LrPluginName = 'Egitos Collection Manager',
    
    LrPluginInfo = {
        author = 'Bruno Egito',
        version = { major=1, minor=0, revision=0, build=1 },
        description = 'O Egitos Collection Manager é um plugin poderoso que facilita a organização e exportação de suas fotos em coleções.',
    },

    LrLibraryMenuItems = {
        {
            title = t.create_collections_title,
            file = "CreateCollections.lua",
        },
        {
            title = t.export_photo_collection_title,
            file = "ExportByCollection.lua",
        }
    },
    LrExportMenuItems = {
        {
            title = t.create_collections_title,
            file = "CreateCollections.lua",
        },
        {
            title = t.export_photo_collection_title,
            file = "ExportByCollection.lua",
        }
    },
    VERSION = { major=1, minor=0, revision=0, build=1, },
}
