local LrApplication = import 'LrApplication'
local LrDialogs = import 'LrDialogs'
local LrTasks = import 'LrTasks'
local LrProgressScope = import 'LrProgressScope'
local LrExportSession = import 'LrExportSession'
local LrPathUtils = import 'LrPathUtils'
local LrFileUtils = import 'LrFileUtils'

local function getTranslations(lang)
    local translations = {
        en = {
            export_photo_collection_title = "Select Export Folder",
            export_photo_collection_messageSuccess = "Export Completed: Photos have been successfully exported by collection.",
            export_photo_collection_messageInfo = "Exporting Photos by Collection",
        },
        pt = {
            export_photo_collection_title = "Selecionar pasta",
            export_photo_collection_messageSuccess = "Exportação completa: As fotos foram exportadas com sucesso pela coleção.",
            export_photo_collection_messageInfo = "Exportando fotos por coleção",
        }
    }
    
    return translations[lang] or translations.en
end

local function getCurrentLanguage()
    return 'pt' 
end

local lang = getCurrentLanguage()
local t = getTranslations(lang)

local function exportPhotosByCollection()
    LrTasks.startAsyncTask(function()
        local catalog = LrApplication.activeCatalog()
        local collections = catalog:getChildCollections()
        
        local exportPath = LrDialogs.runOpenPanel({
            title = t.export_photo_collection_title,
            canChooseFiles = false,
            canChooseDirectories = true,
            allowsMultipleSelection = false,
        })

        if not exportPath then
            return
        end

        exportPath = exportPath[1]

        local progressScope = LrProgressScope({
            title = t.export_photo_collection_messageInfo,
            functionContext = functionContext,
        })

        for i, collection in ipairs(collections) do
            progressScope:setPortionComplete(i - 1, #collections)
            local photos = collection:getPhotos()
            local exportablePhotos = {}

            for _, photo in ipairs(photos) do
                local rating = photo:getRawMetadata('rating')
                if rating and rating >= 1 then
                    table.insert(exportablePhotos, photo)
                end
            end

            if #exportablePhotos > 0 then
                local collectionName = collection:getName()
                local collectionExportPath = LrPathUtils.child(exportPath, collectionName)
                LrFileUtils.createAllDirectories(collectionExportPath)

                local exportSettings = {
                    LR_export_destinationType = 'specificFolder',
                    LR_export_destinationPathPrefix = collectionExportPath,
                    LR_export_useSubfolder = false,
                    LR_format = "JPEG",
                    LR_includeFaceTagsAsKeywords = false,
                    LR_includeFaceTagsInIptc = false,
                    LR_includeVideoFiles = true,
                    LR_initialSequenceNumber = 1,
                    LR_jpeg_limitSize = 100,
                    LR_jpeg_quality = 0.83,
                    LR_jpeg_useLimitSize = false,
                    LR_metadata_keywordOptions = "flat",
                    LR_outputSharpeningLevel = 2,
                    LR_outputSharpeningMedia = "screen",
                    LR_outputSharpeningOn = true,
                    LR_reimportExportedPhoto = false,
                    LR_reimport_stackWithOriginal = false,
                    LR_reimport_stackWithOriginal_position = "below",
                    LR_removeFaceMetadata = true,
                    LR_removeLocationMetadata = true,
                    LR_renamingTokensOn = false,
                    LR_selectedTextFontFamily = "Adobe Clean Regular",
                    LR_selectedTextFontSize = 12,
                    LR_size_doConstrain = true,
                    LR_size_doNotEnlarge = false,
                    LR_size_maxHeight = 3000,
                    LR_size_maxWidth = 1000,
                    LR_size_percentage = 100,
                    LR_size_resizeType = "longEdge",
                    LR_size_resolution = 240,
                    LR_size_resolutionUnits = "inch",
                    LR_size_units = "pixels",
                    LR_size_userWantsConstrain = true,
                }

                local exportSession = LrExportSession({
                    photosToExport = exportablePhotos,
                    exportSettings = exportSettings,
                })

                exportSession:doExportOnCurrentTask()
            end

            if progressScope:isCanceled() then
                break
            end
        end

        progressScope:done()
        LrDialogs.message(t.export_photo_collection_messageSuccess)
    end)
end

LrTasks.startAsyncTask(exportPhotosByCollection)
