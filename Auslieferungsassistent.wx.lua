----------------------------------------------------------------------------
-- Lua code for UI generated with wxFormBuilder (version Jun 17 2015)
-- http://www.wxformbuilder.org/
----------------------------------------------------------------------------
--[[
 Author: Marten Jäger
 Last Edited: 20.04.2018

 Aufbau: 

        Deklaration globaler Variablen und Parameter
        
        Definition des MainFrames
            Funktionen des MainFrames
            Eventhandling des MainFrames
        
        Definition des EditFrames
            Funktionen des EditFrames
            Eventhandling des EditFrames
        
        Definition des EditNameFrames (für das Eingeben neuer Modulnamen)
            Funktionen des EditNameFrames
            Eventhandling des EditNameFrames
        
        Definition des LoadingDialogs
            Eventhandling des LoadingDialogs
        
        globale Methoden
 
--]]
----------------------------------------------------------------------------
package.cpath = package.cpath..";../../3rdParty/?.dll; ../../3rdParty/?.lua;./?.dll;./?.so;../lib/?.so;../lib/vc_dll/?.dll;../lib/bcc_dll/?.dll;../lib/mingw_dll/?.dll;"

require("wx")
require("lfs")

dataFiles = {}
UI = {}
targetTreeId = {}
----------------------------------------------------------------------------
--Konfiguration von gobalen Pfaden 
databaseRoot = lfs.currentdir() .. "\\" or "D:\\develop\\CALINK\\Auslieferungsassistent\\" -- Speicherpfad des Programms und aller dazugehörigen Komponenten
dataRevisionRoot = databaseRoot .. "dataRevisions\\"           -- Ordner für Abbilde bei jeder Änderung im Bearbeitungsfenster (für Rückgängig)
iconRoot = databaseRoot .. "icons\\"
cvsRoot = databaseRoot .. "cvs\\"
buildRoot = databaseRoot .. "build\\"
userSettingsPath = databaseRoot .. "userSettings.lua"
----------------------------------------------------------------------------
if lfs.attributes( databaseRoot .. "data.lua" ) == nil then
    wx.wxMessageBox( "Die Datei " .. databaseRoot .. "data.lua ist nicht vorhanden!", "", wx.wxICON_ERROR )
    return -1
end
dofile( databaseRoot .. "data.lua" )

if lfs.attributes( databaseRoot .. "createPackage.lua" ) == nil then
    wx.wxMessageBox( "Die Datei " .. databaseRoot .. "createPackage.lua ist nicht vorhanden!", "", wx.wxICON_ERROR )
    return -1
end
dofile( databaseRoot .. "createPackage.lua" )

if lfs.attributes( userSettingsPath ) == nil then
    wx.wxMessageBox( "Die Datei " .. userSettingsPath .. " ist nicht vorhanden!", "", wx.wxICON_ERROR )
end
dofile( userSettingsPath )
if userSettings[os.getenv("username")] == nil then userSettings[os.getenv("username")] = {} end

zippingToolPath = userSettings[os.getenv("username")]["zipToolPath"] or "C:\\program files\\7-zip\\7z.exe"
adobePath = userSettings[os.getenv("username")]["AdobePdfReader"] or ""

unusedCompColour = wx.wxColour( 255, 255, 0 )   --Hintergrund
noUpdateCompColour = wx.wxColour(87, 31, 209)   --Text
missingCompColour = wx.wxRED                    --Text
emptyModuleColour = wx.wxColour( 0, 0, 255 )    --Text

editRevision = 0
savedRevision = 0

programIcon = wx.wxIcon( iconRoot .. "icons8-einsatz-48.ico", wx.wxBITMAP_TYPE_ICO )

-- Komponenten, die im Komponentenexplorer nicht aufgeführt werden sollen
-- Lua Pattern können verwendet werden
ignoreCompList = {
    ".+%.bat%.log",
    ".+solutions_failed%.log",
    ".+solutions_succeeded%.log",
    ".+Thumbs%.db",
    "build_report.log",
    "scriptErrors.log",
    "system",
    "calink_5",
}

-- create mainFrame
function UI.mainSplitterOnIdle( event )
    --auto generated
    mainSplitterSashPosDefault = 0
	UI.mainSplitter:SetSashPosition( userSettings[os.getenv("username")]["mainSplitterSashPos"] or mainSplitterSashPosDefault )
	UI.mainSplitter:Disconnect( wx.wxEVT_IDLE )
	
end
    local mainFrameSize = wx.wxSize( 850, 500 )
    
    local customWidth  = userSettings[os.getenv("username")]["mainFrameSize_Width"] 
    local customHeight = userSettings[os.getenv("username")]["mainFrameSize_Height"]
    
    if customWidth and customHeight then
        mainFrameSize = wx.wxSize( customWidth, customHeight )
    end
    
    mainFramePosition = wx.wxDefaultPosition
    
    local customXPos = userSettings[os.getenv("username")]["mainFrameXPos"]
    local customYPos = userSettings[os.getenv("username")]["mainFrameYPos"]
    
    if customXPos and customYPos then
        mainFramePosition = wx.wxPoint( customXPos, customYPos )
    end
    
    UI.mainFrame = wx.wxFrame ( wx.NULL, wx.wxID_ANY, "", mainFramePosition, mainFrameSize, wx.wxDEFAULT_FRAME_STYLE+wx.wxTAB_TRAVERSAL )
    
	UI.mainFrame:SetSizeHints( wx.wxSize( 300,100 ), wx.wxSize( -1,-1 ) )
    UI.mainFrame:SetIcon( programIcon )
	
	UI.mainBoxSizer = wx.wxBoxSizer( wx.wxVERTICAL )
	
	UI.mainToolbar = wx.wxToolBar( UI.mainFrame, wx.wxID_ANY, wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxTB_FLAT ) 
	UI.mTbCvsSync = UI.mainToolbar:AddTool( wx.wxID_ANY, "", wx.wxBitmap( iconRoot .. "icons8-update-26.png", wx.wxBITMAP_TYPE_ANY ), wx.wxNullBitmap, wx.wxITEM_NORMAL, "CVS-Repository aktualisieren", "") 
	
    UI.mainToolbar:AddSeparator()
    
	UI.mTbHealthCheck = UI.mainToolbar:AddTool( wx.wxID_ANY, "", wx.wxBitmap( iconRoot .. "icons8-überprüfen-26.png", wx.wxBITMAP_TYPE_ANY ), wx.wxNullBitmap, wx.wxITEM_NORMAL, "Datenzustand prüfen", "") 
	
	UI.mTbOpenEditFrame = UI.mainToolbar:AddTool( wx.wxID_ANY, "", wx.wxBitmap( iconRoot .. "icons8-eigenschaft-bearbeiten-26.png", wx.wxBITMAP_TYPE_ANY ), wx.wxNullBitmap, wx.wxITEM_NORMAL, "Bearbeitungsmodus aktivieren", "") 
	
	UI.mTbResultListFullPath = UI.mainToolbar:AddTool( wx.wxID_ANY, "", wx.wxBitmap( iconRoot .. "icons8-zweig-26.png", wx.wxBITMAP_TYPE_ANY ), wx.wxNullBitmap, wx.wxITEM_CHECK, "Vollständigen Dateipfad anzeigen", "") 
	
	UI.mainToolbar:AddSeparator()
	
	UI.mTbOpenDoc = UI.mainToolbar:AddTool( wx.wxID_ANY, "", wx.wxBitmap( iconRoot .. "icons8-literatur-26.png", wx.wxBITMAP_TYPE_ANY ), wx.wxNullBitmap, wx.wxITEM_NORMAL, "Bedienungsanleitung öffnen", "") 
	
    UI.mainToolbar:Realize() 
	
	UI.mainBoxSizer:Add( UI.mainToolbar, 0, wx.wxEXPAND, 5 )
	
	UI.mainSplitter = wx.wxSplitterWindow( UI.mainFrame, wx.wxID_ANY, wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxSP_LIVE_UPDATE + wx.wxSP_NO_XP_THEME )
	UI.mainSplitter:SetSashGravity( 0.5 )
	UI.mainSplitter:Connect( wx.wxEVT_IDLE,UI.mainSplitterOnIdle )
	UI.mainSplitter:SetMinimumPaneSize( 100 )
	
	UI.mainSplitter:SetBackgroundColour( wx.wxColour( 171, 171, 171 ) )
	
	UI.modulePanel = wx.wxPanel( UI.mainSplitter, wx.wxID_ANY, wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxTAB_TRAVERSAL )
	UI.optionListBox = wx.wxBoxSizer( wx.wxVERTICAL )
	
	UI.optionListLbl = wx.wxStaticText( UI.modulePanel, wx.wxID_ANY, "Modulauswahl", wx.wxDefaultPosition, wx.wxDefaultSize, 0 )
	UI.optionListLbl:Wrap( -1 )
	UI.optionListBox:Add( UI.optionListLbl, 0, wx.wxALL + wx.wxALIGN_CENTER_HORIZONTAL, 5 )
	
	UI.moduleTree = wx.wxTreeCtrl( UI.modulePanel, wx.wxID_ANY, wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxTR_DEFAULT_STYLE + wx.wxTR_EXTENDED + wx.wxTR_MULTIPLE )
	UI.moduleTree:SetMinSize( wx.wxSize( -1,300 ) )
	
	UI.optionListBox:Add( UI.moduleTree, 1, wx.wxALL + wx.wxEXPAND, 5 )
	
	
	UI.modulePanel:SetSizer( UI.optionListBox )
	UI.modulePanel:Layout()
	UI.optionListBox:Fit( UI.modulePanel )
    UI.compPanel = wx.wxPanel( UI.mainSplitter, wx.wxID_ANY, wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxTAB_TRAVERSAL )
	UI.resultTreeBox = wx.wxBoxSizer( wx.wxVERTICAL )
	
	UI.resultTreeLbl = wx.wxStaticText( UI.compPanel, wx.wxID_ANY, "Zugeordnete Komponenten", wx.wxDefaultPosition, wx.wxDefaultSize, 0 )
	UI.resultTreeLbl:Wrap( -1 )
	UI.resultTreeBox:Add( UI.resultTreeLbl, 0, wx.wxALL + wx.wxALIGN_CENTER_HORIZONTAL, 5 )
	
	UI.resultTree = wx.wxTreeCtrl( UI.compPanel, wx.wxID_ANY, wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxTR_DEFAULT_STYLE + wx.wxTR_HIDE_ROOT + wx.wxTR_MULTIPLE )
	UI.resultTreeBox:Add( UI.resultTree, 1, wx.wxALL + wx.wxEXPAND, 5 )
    
    UI.mainCommentCtrlLbl = wx.wxStaticText( UI.compPanel, wx.wxID_ANY, "Beschreibung / Kommentar", wx.wxDefaultPosition, wx.wxDefaultSize, 0 )
	UI.mainCommentCtrlLbl:Wrap( -1 )
	UI.resultTreeBox:Add( UI.mainCommentCtrlLbl, 0, wx.wxALIGN_CENTER_HORIZONTAL + wx.wxTOP + wx.wxRIGHT + wx.wxLEFT, 5 )
	
	UI.mainCommentCtrl = wx.wxTextCtrl( UI.compPanel, wx.wxID_ANY, "", wx.wxDefaultPosition, wx.wxSize( -1,150 ), wx.wxHSCROLL + wx.wxTE_MULTILINE + wx.wxTE_READONLY )
	UI.resultTreeBox:Add( UI.mainCommentCtrl, 0, wx.wxALL + wx.wxEXPAND, 5 )
	
	
	UI.compPanel:SetSizer( UI.resultTreeBox )
	UI.compPanel:Layout()
	UI.resultTreeBox:Fit( UI.compPanel )
	UI.mainSplitter:SplitVertically( UI.modulePanel, UI.compPanel, 0 )
	UI.mainSplitter:SetSplitMode(2)
	UI.mainBoxSizer:Add( UI.mainSplitter, 1, wx.wxEXPAND, 5 )
	
	UI.mainFrameBtmSeperator = wx.wxStaticLine( UI.mainFrame, wx.wxID_ANY, wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxLI_HORIZONTAL )
	UI.mainBoxSizer:Add( UI.mainFrameBtmSeperator, 0, wx.wxEXPAND + wx.wxBOTTOM, 5 )
	
	UI.mainCompSrcRbChoices = { "CVS", "Nightly-Build" }
	UI.mainCompSrcRb = wx.wxRadioBox( UI.mainFrame, wx.wxID_ANY, "Herkunft der Komponenten", wx.wxDefaultPosition, wx.wxDefaultSize, UI.mainCompSrcRbChoices, 1, wx.wxRA_SPECIFY_ROWS )
	UI.mainCompSrcRb:SetSelection( 0 )
	UI.mainCompSrcRb:SetBackgroundColour( wx.wxColour( 171, 171, 171 ) )
	
	UI.mainBoxSizer:Add( UI.mainCompSrcRb, 0, wx.wxALL + wx.wxALIGN_CENTER_VERTICAL, 5 )
	
	UI.cadUpdateCb = wx.wxCheckBox( UI.mainFrame, wx.wxID_ANY, "Nur Komponenten des Untermoduls erhalten", wx.wxDefaultPosition, wx.wxDefaultSize, 0 )
	UI.mainBoxSizer:Add( UI.cadUpdateCb, 0, wx.wxALL + wx.wxALIGN_CENTER_VERTICAL, 5 )
	
	UI.mainUpdateCb = wx.wxCheckBox( UI.mainFrame, wx.wxID_ANY, "Es handelt sich nicht um eine Erstinstallation", wx.wxDefaultPosition, wx.wxDefaultSize, 0 )
	UI.mainBoxSizer:Add( UI.mainUpdateCb, 0, wx.wxALL + wx.wxALIGN_CENTER_VERTICAL, 5 )
	
	UI.createPackageBtn = wx.wxButton( UI.mainFrame, wx.wxID_ANY, "Installationspaket erstellen", wx.wxDefaultPosition, wx.wxDefaultSize, 0 )
	UI.mainBoxSizer:Add( UI.createPackageBtn, 0, wx.wxALL + wx.wxALIGN_CENTER_HORIZONTAL, 5 )
	
	
	UI.mainFrame:SetSizer( UI.mainBoxSizer )
	UI.mainFrame:Layout()
	
	UI.mainFrame:Centre( wx.wxBOTH )
    
    UI.mainCommentCtrl:Hide()
    UI.mainCommentCtrlLbl:Hide()
    
    -- Connect Events    
    
    function openSelectedCompsInExplorer()
        -- Öffnet die in der Zielstruktur markierten Komponenten im Windows Explorer
        
        if #UI.resultTree:GetSelections() == 0 then
            wx.wxMessageBox( "Wähle eine Datei aus, die du im Windows Explorer sehen möchtest!", "Keine Datei ausgewählt" )
            return -1
        end
        
        for _, selection in pairs( UI.resultTree:GetSelections() ) do
            local fileName = getPathName( UI.resultTree, selection ):gsub( "Root\\.-\\", "Root\\" )
            
            local pathStart, pathEnd = fileName:find( "%(.-%)" )
            if pathEnd == fileName:len() then fileName = fileName:sub( 1, pathStart -2 ) end
            
            local fileToSelect = fileName or "undefined"
            local moduleName
            
            for _, selectedModule in pairs( UI.moduleTree:GetSelections() ) do
                local moduleToSearch = getPathName( UI.moduleTree, selectedModule ):gsub( "\\", "/" )
                if getPathName( UI.resultTree, selection ):find( moduleToSearch, 1, true ) then
                    moduleName = getPathName( UI.moduleTree, selectedModule )
                    break
                end
            end
            
            if UI.mainCompSrcRb:GetSelection() == 1 then
                local moduleWhereFileCouldBe = module_id[moduleName]
                local fileFound = false
                
                --Die zu öffnende Datei kann auch angezeigt werden, weil sie aus einem übergeordneten Modul stammt
                while moduleWhereFileCouldBe:IsOk() do
                    if fileFound then break end
                    moduleNameWhereFileCouldBe = getPathName( UI.moduleTree, moduleWhereFileCouldBe )
                    
                    if compRel[moduleNameWhereFileCouldBe] then
                        for _, file in ipairs( compRel[moduleNameWhereFileCouldBe] ) do
                            if file.target == fileName then
                                fileToSelect = buildRoot .. file.source
                                fileFound = true
                                break
                            end
                        end
                    end
                    moduleWhereFileCouldBe = UI.moduleTree:GetItemParent( moduleWhereFileCouldBe )
                end
            else
                fileToSelect = cvsRoot .. fileName:gsub( "Root\\", "" )
            end
            
            if fileExists( fileToSelect ) then
                os.execute( "explorer.exe /select, \"" .. fileToSelect .. "\"" )
            else
                wx.wxMessageBox( "Die Datei " .. fileToSelect .. " wurde nicht gefunden.", "Fehler" )
            end
        end
    end
    
    function saveExpandedResultTreeItems()
        -- Da das Event EVT_TREE_SEL_CHANGING für Multiple-Selection Bäume nicht funktioniert, speichert
        -- diese Methode die aufgeklappten Items des Zielbaums und wird jedes Mal aufgerufen, wenn
        -- ein Item auf- oder zugeklappt wird
        expandedTargetTreeItems = expandedTargetTreeItems or {}
        
        for _, selectedModule in pairs( UI.moduleTree:GetSelections() ) do
            local selectedModuleName = getPathName( UI.moduleTree, selectedModule )
            expandedTargetTreeItems[selectedModuleName] = {}
            
            for tTName, tTId in pairs( targetTreeId ) do
                local moduleNameStart, moduleNameEnd = tTName:find( selectedModuleName:gsub( "\\", "/" ), 1, true )
                
                if moduleNameStart == string.len( "Root\\" ) +1
                and UI.resultTree:IsExpanded( tTId )
                then
                    table.insert( expandedTargetTreeItems[selectedModuleName], tTName )
                end
            end
        end
    end
    
    function healthCheck()
    --Stellt einige Überprüfungen an und informiert den Anwender mit mehreren Messageboxes
    
    os.remove( databaseRoot .. "missingFiles.txt" )
    os.remove( databaseRoot .. "lonelyComponents.txt" )
    os.remove( databaseRoot .. "missingNoUpdateComps.txt" )

    local missingModules = ""
    for modulePath in pairs( compRel ) do
        if module_id[modulePath] == nil then
            missingModules = missingModules .. modulePath .. "\n"
        end
    end
    
    for modulePath in pairs( comments ) do
        if module_id[modulePath] == nil and missingModules:find( modulePath ) == nil then
            missingModules = missingModules .. modulePath .. "\n"
        end
    end

    if missingModules ~= "" then
        if wx.wxMessageDialog( UI.mainFrame, "Einige Module existieren nicht mehr, sollen ihre Komponentenzuordnungen gelöscht werden?\n" .. 
        "Folgende Module sind betroffen:\n" .. missingModules, "Löschen bestätigen!", wx.wxYES_NO + wx.wxNO_DEFAULT + wx.wxICON_WARNING ):ShowModal() == wx.wxID_YES then
            for module in missingModules:gmatch( "[^\n]+" ) do
                compRel[module] = nil
                comments[module] = nil
            end
            mergeDataFiles()
        end
        
    end     
    
    missingNoUpdateCompsStr = ""
    missingNoUpdateCompsCnt = 0

    table.sort( noUpdateComps, function(a,b) return a:upper() < b:upper() end )
    for k, comp in ipairs( noUpdateComps ) do
        if item_id[buildRoot .. comp] == nil then
            missingNoUpdateCompsStr = missingNoUpdateCompsStr .. comp .. "\n"
            missingNoUpdateCompsCnt = missingNoUpdateCompsCnt +1
        end
    end

    if missingNoUpdateCompsCnt > 0 and missingNoUpdateCompsCnt <= 20 then
        if wx.wxMessageDialog( UI.mainFrame, missingNoUpdateCompsCnt .. " noUpdateComps fehlen im Dateisystem. Möchtest du " ..
            "sie aus der Tabelle der nicht-updatefähigen Dateien löschen?\n" .. missingNoUpdateCompsStr, "noUpdateComps fehlen", 
            wx.wxYES_NO + wx.wxNO_DEFAULT + wx.wxICON_WARNING ):ShowModal() 
            == wx.wxID_YES 
        then
            for index, comp in ipairs( noUpdateComps ) do
                for missingNoUpdateComp in missingNoUpdateCompsStr:gmatch( "[^\n]+" ) do
                    if comp == missingNoUpdateComp then
                        noUpdateComps[index] = nil
                        break
                    end
                end
            end
            mergeDataFiles()
        end
    elseif missingNoUpdateCompsCnt > 20 then
        local file = io.open( databaseRoot .. "missingNoUpdateComps.txt", "w+" )
        file:write( missingNoUpdateCompsStr )
        file:close() 
        
        wx.wxMessageBox( missingNoUpdateCompsCnt .. " noUpdateComps fehlen im Dateisystem. Eine genaue Auflistung befindet sich unter " ..
            databaseRoot .. "missingNoUpdateComps.txt", "noUpdateComps fehlen" )
    end

    local totalMissingFiles = #missingFiles + #missingCvsFiles

    local missingNbFilesString = ""
    for _, file in pairs( missingFiles ) do
        missingNbFilesString = missingNbFilesString .. file .. "\n"
    end

    local missingCvsFilesString = ""
    table.sort( missingCvsFiles, function( a, b ) return a:upper() < b:upper() end )
    for _, file in pairs( missingCvsFiles ) do
        missingCvsFilesString = missingCvsFilesString .. file .. "\n"
    end

    if totalMissingFiles > 0 and totalMissingFiles <= 20 then
        wx.wxMessageBox( totalMissingFiles .. " Datei" .. (totalMissingFiles == 1 and "" or "en") .. " existier" .. (totalMissingFiles == 1 and "t" or "en") .. 
            " nicht (mehr) im Dateisystem.\nFehlende Nightly-Build-Komponenten:\n" .. missingNbFilesString .. "\n\n" ..
            "Fehlende CVS-Komponenten:\n" .. missingCvsFilesString, "Dateien fehlen!" )
        os.remove( databaseRoot .. "missingFiles.txt" )
    elseif totalMissingFiles > 20 then
        local currFile = io.open( databaseRoot .. "missingFiles.txt", "w+" )
        currFile:write( "Fehlende Nightly-Build-Komponenten:\n" .. missingNbFilesString .. "\n\nFehlende CVS-Komponenten:\n" .. missingCvsFilesString )
        currFile:close()
        
        wx.wxMessageBox( totalMissingFiles .. " Dateien existieren nicht (mehr) im Dateisystem!\n(" .. #missingCvsFiles .. " CVS, " .. #missingFiles .. " Nightly-Build)\n" .. 
            "Eine genaue Auflistung kann der Datei " .. databaseRoot .. "missingFiles.txt entnommen werden.", "Dateien fehlen!" )
    end
    
    for i, file in ipairs( unusedFiles ) do
        if file == nil then
            table.remove( unusedFiles, i )
        end
    end
    table.sort(unusedFiles)
    if #unusedFiles > 0 and #unusedFiles <= 20 then
        local unusedFilesString = ""
        table.sort( unusedFiles )
        for _, file in pairs( unusedFiles ) do
            unusedFilesString = unusedFilesString .. ( file or "nil" ) .. "\n"
        end
        wx.wxMessageBox( #unusedFiles .. " Komponenten sind nicht zugeordnet:\n" .. unusedFilesString, "Dateien sind nicht zugeordnet!", wx.wxICON_WARNING )
        os.remove( databaseRoot .. "lonelyComponents.txt" )
    elseif #unusedFiles > 20 then
        local currFile = io.open( databaseRoot .. "lonelyComponents.txt", "w+" )
        for i, comp in ipairs( unusedFiles ) do
            currFile:write( comp .. "\n" )
        end
        currFile:close() 
        
        wx.wxMessageBox( #unusedFiles .. " Komponenten sind nicht zugeordnet!\n" ..
            "Eine genaue Auflistung kann der Datei " .. databaseRoot .. "lonelyComponents.txt entnommen werden.", "Dateien sind nicht zugeordnet!", wx.wxICON_WARNING )
    end
end

    function maybeOpenEditFrame()
    --Öffnet, wenn möglich, das Bearbeitungsfenster
    
        local showEditFrame = true
        if fileExists( databaseRoot .. "editMode.lock" ) and not fastMode then
            local lockFile = io.open( databaseRoot .. "editMode.lock", "r" )
            local currUser = lockFile:read( "*a" )
            lockFile:close()
            currUser = currUser:gsub( "%s", "" )
            if currUser == os.getenv( "USERNAME" ) then
                wx.wxMessageBox( "Du hast das Bearbeitungsfenster noch geöffnet. Bitte prüfe, ob noch eine andere Instanz aktiv ist. " ..
                    "Andernfalls lösche die Datei \"" .. databaseRoot .. "editMode.lock\" und versuche es erneut!", "Bearbeitungsfenster ist noch offen", wx.wxICON_WARNING )
                showEditFrame = false
            else
                wx.wxMessageBox( "Derzeit nimmt \"" .. currUser  .. "\" Änderungen vor. Da die Daten nur durch einen Benutzer zur Zeit " ..
                "bearbeitet werden dürfen, kann das Bearbeitungsfenster nicht geöffnet werden.", "Bearbeitungsfenster durch anderen Benutzer geöffnet" )
                showEditFrame = false
            end
        end
        if showEditFrame then 
            if databaseRoot == "\\\\ham-vscalink01\\deploy\\program\\deploy\\" then
                wx.wxMessageBox( "Deine Änderungen werden im Zuge des Nightly-Builds gelöscht werden! " ..
                    "Um sie zu speichern , checke nach Beendigung des Tools die Datei \"" .. databaseRoot .. "data.lua\" " ..
                    "in Mercurial ein (default-CA-Link-Branch)!", "Wichtiger Hinweis!", wx.wxICON_WARNING )
            end
            
            UI.loadingScreen:Show( true )
            UI.loadingDlgGauge:SetRange( 1 ); UI.loadingDlgGauge:SetValue( 0 )
            UI.loadingDlgLbl:SetLabel( "Der Zustand des Fensters wird erfasst..." )
            UI.loadingDlgAdditionalInfo:SetLabel( "Initialisiere Datentabellen" )
            
            lockFile = io.open( databaseRoot .. "editMode.lock", "w+" )
            lockFile:write( os.getenv( "username" ) )            
            lockFile:close()
            
            dofile( databaseRoot .. "data.lua" ) --Aktuellsten Datenbestand holen, just in case
            initialiseDataTables()
            removeDataRevisionsFolder()
            editRevision = 0
            savedRevision = 0
            
            UI.loadingDlgAdditionalInfo:SetLabel( "Erfasse Zustand der Module" )
            local expandedModules = {}
            for moduleName, moduleId in pairs( module_id ) do
                if UI.moduleTree:IsExpanded( moduleId ) then
                    table.insert( expandedModules, moduleName )
                end
            end            
            
            UI.loadingDlgAdditionalInfo:SetLabel( "Erfasse selektierte Module" )
            local prevSelectedModule = ""
            local selectedModules = UI.moduleTree:GetSelections()
            if #selectedModules == 1 then
                prevSelectedModule = getPathName( UI.moduleTree, selectedModules[1] )
            end
            
            UI.loadingDlgAdditionalInfo:SetLabel( "Erfasse Zustand der Zielbaumstruktur" )
            local expandedComps = {}
            for tTName, tTId in pairs( targetTreeId ) do
                if UI.resultTree:IsExpanded( tTId ) then
                    tTName = tTName:gsub( "Root\\.-\\", "Root\\" )
                    local pathStart, pathEnd = tTName:find( "%(.-%)" )
                    if pathEnd == tTName:len() then tTName = tTName:sub( 1, pathStart -2 ) end
                    
                    table.insert( expandedComps, tTName )
                end
            end
            
            UI.loadingDlgAdditionalInfo:SetLabel( "Erfasse selektierte Dateien" )
            local selectedComps = {}
            for _, selectedComp in pairs( UI.resultTree:GetSelections()) do
                local name = getPathName( UI.resultTree, selectedComp )
                name = name:gsub( "Root\\.-\\", "Root\\" )
                local pathStart, pathEnd = name:find( "%(.-%)" )
                if pathEnd == name:len() then name = name:sub( 1, pathStart -2 ) end
                
                table.insert( selectedComps, name )
            end
            
            fillModuleTree( UI.editModuleTree )
            UI.editTargetTree:DeleteAllItems()
            targetTreeId = {}
            
            UI.loadingDlgAdditionalInfo:SetLabel( "Erfasste Zustände werden auf das Bearbeitungsfenster angewandt" )
            for _, moduleName in pairs( expandedModules ) do
                if module_id[moduleName] then
                    UI.editModuleTree:Expand( module_id[moduleName] )
                end
            end
            
            if prevSelectedModule ~= "" then
                UI.editModuleTree:SelectItem( module_id[prevSelectedModule] )
                showCompsForSelectedModule( UI.editModuleTree, UI.editTargetTree, false, module_id[prevSelectedModule], true )
                setTreeFoldersFirst( UI.editTargetTree, UI.editTargetTree:GetRootItem() )
            end
            
            for _, tTName in pairs( expandedComps ) do
                if targetTreeId[tTName] then
                    UI.editTargetTree:Expand( targetTreeId[tTName] )
                end
            end
            
            for _, selectedComp in pairs( selectedComps ) do
                if targetTreeId[selectedComp] then
                    UI.editTargetTree:SelectItem( targetTreeId[selectedComp] )
                end
            end
            
            UI.mainCompSrcRbPrevState = UI.mainCompSrcRb:GetSelection()
            UI.mainCompSrcRb:SetSelection(1) -- markIncompleteModules() wertet diese Checkbox aus
            
            UI.loadingDlgAdditionalInfo:SetLabel( "Bereite Initial-Revision vor" )
            
            lfs.mkdir( dataRevisionRoot )
            mergeDataFiles( 0 ) --Erzeugt "dataRevisions\data0.lua"
            
            if not fastMode then markAllComponents( false ) end
            
            UI.editToolbar:EnableTool( UI.eTbUndo:GetId(), false )
            UI.editToolbar:EnableTool( UI.eTbRedo:GetId(), false )            
            UI.editToolbar:EnableTool( UI.eTbChildPaste:GetId(), false )
            
            enableTreeEditing( false )
            
            UI.mainFrame:Show( false )
            UI.editFrame:Show( true )
            UI.editFrame:Move( editFramePosition )
            
            editHappened( false )
            
            markIncompleteModules( UI.editModuleTree, false, true )
            doCheckModulesComplete = false --Für das Verlassen des Bearbeitungsfensters
        end
    end
    
    function maybeCreatePackage()
        --Erstellt, wenn möglich, ein Installationspaket
        if #UI.moduleTree:GetSelections() == 0 then
            wx.wxMessageBox( "Es wurde kein Modul ausgewählt.", "Welches Paket soll erstellt werden?" )
        else
            --Nicht existierende Komponenten zugeordnet?
            for _, id in pairs( targetTreeId ) do
                if getPathName( UI.resultTree, UI.resultTree:GetRootItem() ) ~= getPathName( UI.resultTree, id )
                and UI.resultTree:GetItemTextColour( id ):GetAsString( wx.wxC2S_HTML_SYNTAX ) == missingCompColour:GetAsString( wx.wxC2S_HTML_SYNTAX ) then
                    if wx.wxMessageDialog( UI.mainFrame, "Die Auswahl enthält mindestens ein Modul " ..
                    "mit fehlenden Komponenten. Möchtest Du trotzdem fortfahren?", 
                    "Komponenten fehlen", wx.wxYES_NO ):ShowModal() == wx.wxID_NO then
                        return
                    end
                    break
                end
            end
            
            --7-zip konfigurieren
            if not fileExists( zippingToolPath ) then
                wx.wxMessageBox( "Das Programm \"7-zip.exe\" wurde nicht gefunden. Bitte wähle es  " ..
                    "im nachfolgenden Dialog aus.", "7-zip nicht gefunden" )
                local zippingToolPathPicker = wx.wxFileDialog( UI.mainFrame, "7z.exe auswählen", zippingToolPath, "7z.exe", "7z.exe (*7z.exe)|*7z.exe", wx.wxFLP_DEFAULT_STYLE )
                zippingToolPathPicker:ShowModal()
                zippingToolPath = zippingToolPathPicker:GetPath()
                if not fileExists ( zippingToolPath ) then
                    wx.wxMessageBox( "Es wurde kein gültiger Pfad angegeben. Das Installationspaket wird erstellt, aber nicht verpackt.", "7z.exe nicht gefunden" )
                end
                saveUserSettings()
            end
                
            -- Vorwahlordner für die Pakete definieren
            local defaultFolderPath = "C:\\Users\\" .. os.getenv( "USERNAME" ) .. "\\Desktop\\Installationspakete" 
            customFolderPath = userSettings[os.getenv("USERNAME")]["packagePath"] or defaultFolderPath
            
            --Standardname des Pakets bestimmen
            local packageName = ""
            for _, selection in pairs( UI.moduleTree:GetSelections() ) do
                packageName = packageName .. getPathName( UI.moduleTree, selection ):gsub( "\\", "-" ):gsub( " ", "_" ) .. "+"
            end
            packageName = packageName:sub( 1, -2 ) --"+" am Ende entfernen
            
            --Rev- bzw. CVS-Kennung ans Ende des Paketnamens hängen
            if UI.mainCompSrcRb:GetSelection() == 0 then
                --Neueste Komponente ermitteln
                local newestDate = 0
                for _, innerSelection in pairs( UI.moduleTree:GetSelections() ) do
                    for _, comp in pairs( moduleComps[getPathName( UI.moduleTree, innerSelection )] ) do
                    local date = lfs.attributes( cvsRoot .. string.sub( comp.target, 6 ), "modification" )
                        if date and date > newestDate then
                            newestDate = date
                        end
                    end
                end
                --print( "highest Date:", newestDate )
                packageName = packageName .. "(cvs_" .. os.date( "%Y_%m_%d", newestDate ) .. ")"
            else
                --Höchste Revision ermitteln
                local revRoot = "\\\\ham-vscalink01\\deploy\\rev\\"
                local highestRev = 0
                for fileName in lfs.dir( revRoot ) do
                    if fileName:find( "revision\.log" ) then
                        local file = io.open( revRoot .. fileName, "r" )
                        local rev = tonumber( file:read( "*a" ) )
                        if rev > highestRev then
                            highestRev = rev
                        end
                    end
                end
                --print( "highest Revision:", highestRev )
                packageName = packageName .. "(rev_" .. highestRev .. ")" 
            end
            
            local packageNameIsInvalid = true
            local doZip
            while packageNameIsInvalid do
                packageNameIsInvalid = false
                local destPicker = wx.wxFileDialog( UI.mainFrame, "Ziel und Name des Pakets bestimmen.", customFolderPath, packageName, "Ordner|*.*", wx.wxFD_SAVE + wx.wxFD_OVERWRITE_PROMPT )
                if destPicker:ShowModal() == wx.wxID_CANCEL then return end
                folderPath = destPicker:GetPath()
                if folderPath:sub( - string.len( ".zip" ) ) == ".zip" then
                    folderPath = folderPath:sub( 1, -( string.len( ".zip" ) +1 ) )
                end
                
                parentFolderPath = folderPath:sub( 1, -( destPicker:GetFilename():len() +2 ) )
                
                if folderPath:len() > 256 then
                    wx.wxMessageBox( "Die Länge des Pfades inklusive Paketname darf 256 Zeichen nicht überschreiten!", "Paketname zu lang", wx.wxICON_WARNING )
                    packageNameIsInvalid = true
                end
                
                local folderPath
                if lfs.attributes( parentFolderPath ) then
                    customFolderPath = parentFolderPath
                    saveUserSettings()
                else
                    wx.wxMessageBox( "Das Paket kann im ausgewählten Verzeichnis nicht erstellt werden!", "Ungültiges Zielverzeichnis.", wx.wxICON_WARNING )
                    packageNameIsInvalid = true
                end           
                local doZipDialog = wx.wxMessageDialog( UI.mainFrame, "Soll das Paket verpackt werden? (Durch Auswahl von Nein wird es ein Ordner).", "Installationspaket verpacken?", wx.wxYES_NO + wx.wxCANCEL )
                
                if not packageNameIsInvalid then
                    local doZipChoice = doZipDialog:ShowModal()
                    if doZipChoice == wx.wxID_YES then
                        doZip = true
                    elseif doZipChoice == wx.wxID_NO then
                        doZip = false
                    elseif doZipChoice == wx.wxID_CANCEL then
                        packageNameIsInvalid = true
                    end
                end
            end
            
 
            
            if fileExists( folderPath .. ( doZip and ".zip" or "" ) ) then
                os.remove( folderPath .. ( doZip and ".zip" or "" ) )
            end
            
            -- Name gültig? Dann los!
            loadingCanceled = false
            UI.loadingScreen:Show( true )
            UI.loadingDlgLbl:SetLabel( "Das Installationspaket für die ausgewählten Module wird erstellt." )
            UI.loadingDlgGauge:SetValue( 0 )
            
            local range = 0
            for _, id in pairs( targetTreeId ) do
                if not UI.resultTree:ItemHasChildren( id, false ) then range = range +1 end
            end
            UI.loadingDlgGauge:SetRange( range )
            UI.mainFrame:Enable( false )
            
            local updateCompNoteWasWritten = false
            for _, selection in pairs( UI.moduleTree:GetSelections() ) do
                createPackage( getPathName( UI.moduleTree, selection ), folderPath, UI.mainCompSrcRb:GetSelection() == 0, UI.cadUpdateCb:IsChecked(), UI.mainUpdateCb:IsChecked() )
            end
            if doZip then zipPackage( folderPath, nil, zippingToolPath ) end
            
            UI.loadingDlgAdditionalInfo:SetLabel( "Installationspaket erfolgreich erstellt!" )
            os.execute( "explorer.exe /select, \"" .. folderPath .. ( doZip and ".zip" or "" ) .. "\"" )
            UI.loadingScreen:Show( false )
            UI.mainFrame:Enable( true )
            UI.mainFrame:SetFocus()
        end
	end
    
    --Kontextmenüs Hauptfenster
    
    do --ModuleTree
        local optionEdit
        local optionCreate
        local optionHelp
        
        --Kontextmenü erstellen
        UI.moduleTree:Connect( wx.wxEVT_CONTEXT_MENU, function(event)
            local contextMenu = wx.wxMenu()
            optionEdit = contextMenu:Append( 0, "Bearbeiten" )
            optionCreate = contextMenu:Append( 1, "Paket erstellen" )    
            contextMenu:AppendSeparator()
            optionHelp = contextMenu:Append( 2, "Hilfe" )
            
            UI.moduleTree:PopupMenu( contextMenu )
        end )
        
        --Eventhandling Kontextmenü
        UI.moduleTree:Connect( wx.wxEVT_COMMAND_MENU_SELECTED, function(event)
            if event:GetId() == optionEdit:GetId() then
                maybeOpenEditFrame()
            elseif event:GetId() == optionCreate:GetId() then
                maybeCreatePackage()
            elseif event:GetId() == optionHelp:GetId() then
                openManual( 6 )
            end
        end )
    end
    
    do --ResultTree
        local optionEdit
        local optionOpen
        local optionHelp
        
        --Kontextmenü erstellen
        UI.resultTree:Connect( wx.wxEVT_CONTEXT_MENU, function(event)
            local contextMenu = wx.wxMenu()
            optionEdit = contextMenu:Append( 0, "Bearbeiten" )
            optionOpen = contextMenu:Append( 1, "Im Explorer anzeigen" )
            optionHelp = contextMenu:Append( 2, "Hilfe" )
            
            UI.resultTree:PopupMenu( contextMenu )
        end )
        
        --Eventhandling Kontextmenü
        UI.resultTree:Connect( wx.wxEVT_COMMAND_MENU_SELECTED, function(event)
            if event:GetId() == optionEdit:GetId() then
                maybeOpenEditFrame()
            elseif event:GetId() == optionOpen:GetId() then
                openSelectedCompsInExplorer()
            elseif event:GetId() == optionHelp:GetId() then
                openManual( 6 )
            end
        end )
    end
    
	UI.mainFrame:Connect( wx.wxEVT_CLOSE_WINDOW, function(event)
	--implements mainFrameClosed
        --mergeDataFiles()
        saveUserSettings()
        os.exit()
        event:Skip()
    end )
    
    UI.mainSplitter:Connect( wx.wxEVT_COMMAND_SPLITTER_DOUBLECLICKED, function(event)
	--implements mainSplitterSashDClicked
        UI.mainSplitter:SetSashPosition( mainSplitterSashPosDefault )
	end )
    
    UI.mainToolbar:Connect( UI.mTbCvsSync:GetId(), wx.wxEVT_COMMAND_TOOL_CLICKED, function(event)
    --implements mTbCvsSyncPressed
        wx.wxMessageBox( "Diese Funktion steht für die Stand-Alone Version nicht zur Verfügung." )
        if true then return end
        
        if fileExists( "\\\\ham-vscalink01\\deploy\\program\\cvs\\\cvsCheckout.lock" ) then
            wx.wxMessageBox( "Eine Synchronisation ist derzeit in Gange. Bitte versuche es in ein paar Minuten erneut." )
            return
        end
        if wx.wxMessageDialog( UI.mainFrame, "Das Synchronisieren aktualisiert das Working-Directory des CVS auf dem Server. Dadurch sind dem Programm Änderungen bekannt, " ..
            "die seit letzter Nacht eingecheckt wurden. Dieser Vorgang kann mehrere Minuten dauern, das Programm kann während dieser Zeit nicht benutzt werden. Möchtest du fortfahren?", 
            "CVS-Checkout", wx.wxYES_NO ):ShowModal() == wx.wxID_NO then
            return
        end
        UI.mainFrame:Enable( false )
        os.execute( "\\\\ham-vscalink01\\deploy\\program\\cvs\\cvsCheckout.bat" )
        UI.mainFrame:Enable( true )
        UI.mainCompSrcRb:SetSelection( 0 )
        missingCvsFiles = {}
        incompleteCvsModules = {}
        markIncompleteModules( UI.moduleTree, true, false )
        showCompsForSelectedModule( UI.moduleTree, UI.resultTree, true, UI.moduleTree:GetSelection(), true )
        
        errorString = ""
        for line in io.lines( "\\\\ham-vscalink01\\deploy\\program\\cvs\\checkoutErrors.log" ) do
            -- Das Ausschecken von Ordnern erzeugt einen log-Eintrag im stdErr-Stream
            if line:find( "cvs checkout" ) ~= 1 then
                errorString = errorString .. line .. "\n"
            end
        end
        if errorString == "" then
            wx.wxMessageBox( "Die Synchronisation war erfolgreich!", "CVS-Synchroniation erfolgreich" )
        else
            wx.wxMessageBox( errorString, "Fehler bei der CVS-Synchronisation!", wx.wxICON_ERROR )
        end
    end )
    
    UI.mainToolbar:Connect( UI.mTbHealthCheck:GetId(), wx.wxEVT_COMMAND_TOOL_CLICKED, function(event)
	--implements mtbHealthCheckPressed
        healthCheck()
	end )
    
    UI.mainToolbar:Connect( UI.mTbOpenEditFrame:GetId(), wx.wxEVT_COMMAND_TOOL_CLICKED, function(event)
	--implements mTbOpenEditFramePressed
        maybeOpenEditFrame()
	end )
    
    UI.mainToolbar:Connect( UI.mTbResultListFullPath:GetId(), wx.wxEVT_COMMAND_TOOL_CLICKED, function(event)
	--implements mTbResultListFullPathToggled
        local topItemPath = getPathName( UI.resultTree, UI.resultTree:GetFirstVisibleItem() )
        local sourceStart, sourceEnd = topItemPath:find( "%(.-%)" )
        
        if sourceEnd == topItemPath:len() then topItemPath = topItemPath:sub( 1, sourceStart -2 ) end
        
        rebuildResultTree( not UI.cadUpdateCb:IsChecked() )
        
        for tTName, tTId in pairs( targetTreeId ) do
            if tTName:find( topItemPath, 1, true ) == 1 then
                UI.resultTree:ScrollTo( tTId )
                break
            end
        end
	end )
    
    UI.mainToolbar:Connect( UI.mTbOpenDoc:GetId(), wx.wxEVT_COMMAND_TOOL_CLICKED, function(event)
	--implements mTbOpenDocPressed
        openManual()
	end )   
    
    -- Um die aufgeklappten Items des Zielbaums wiederherzustellen, müssen sie natürlich irgendwann
    -- aufgeklappt werden. Da dies aber ebenfalls ein EVT_COMMAND_TREE_ITEM_EXPANDED auslöst und dies
    -- die Struktur erneut speichern würde, kann diese Bool'sche Variable das Event sperren
    resultTreeVetoEvtItemExpanded = false
	UI.resultTree:Connect( wx.wxEVT_COMMAND_TREE_ITEM_EXPANDED, function(event)
	--implements resultTreeItemExpanded
        if resultTreeVetoEvtItemExpanded then
            return
        end
        --print( "item expanded", debug.traceback() )
        saveExpandedResultTreeItems()
	end )
    
    UI.resultTree:Connect( wx.wxEVT_COMMAND_TREE_ITEM_COLLAPSED, function(event)
    --implements resultTreeItemCollapsed
        --print( "item collapsed", debug.traceback() )
        saveExpandedResultTreeItems()
    end )
    
    UI.resultTree:Connect( wx.wxEVT_COMMAND_TREE_ITEM_ACTIVATED, function(event)
	--implements resultTreeDoubleClicked
        if UI.resultTree:ItemHasChildren( event:GetItem() ) then
            event:Skip()
        else
            openSelectedCompsInExplorer()
        end
	end )

    UI.moduleTree:Connect( wx.wxEVT_COMMAND_TREE_SEL_CHANGED, function(event)
	--implements moduleTreeSelectionChanged
        
        for module in childrenOf( UI.moduleTree, UI.moduleTree:GetRootItem(), true ) do
            UI.moduleTree:SetItemBold( module, false )
        end
        
        for _, selectedModule in pairs( UI.moduleTree:GetSelections() ) do
            UI.moduleTree:SetItemBold( selectedModule, true )
        end
        
        rebuildResultTree( true )
        for childId in childrenOf( UI.resultTree, UI.resultTree:GetRootItem() ) do
        
            resultTreeVetoEvtItemExpanded = true
            UI.resultTree:Expand( childId )
            resultTreeVetoEvtItemExpanded = false
            
            if UI.resultTree:GetItemText( UI.resultTree:GetFirstChild( childId ) ):find( ".tandard%d+" ) == 1 then
            
                resultTreeVetoEvtItemExpanded = true
                UI.resultTree:Expand( UI.resultTree:GetFirstChild( childId ) )
                resultTreeVetoEvtItemExpanded = false
            end
        end
        
        local comment = ""
        
        for _, selection in pairs( UI.moduleTree:GetSelections() ) do
            --Die vorher aufgeklappten Zieldateien wiederherstellen
            for thisName, thisId in pairs( targetTreeId ) do
                if expandedTargetTreeItems 
                and expandedTargetTreeItems[getPathName( UI.moduleTree, selection )] 
                and table.contains( expandedTargetTreeItems[getPathName( UI.moduleTree, selection )], thisName ) then
                    resultTreeVetoEvtItemExpanded = true
                    UI.resultTree:Expand( thisId )
                    resultTreeVetoEvtItemExpanded = false
                end               
            end
            
            --Den Kommentar ergänzen. Durch sortedKeys werden sie von unten nach oben angezeigt, was imo korrekt ist
            for thisModuleName, thisComment in sortedKeys( comments ) do
                if getPathName( UI.moduleTree, selection ):find( thisModuleName, 1, true ) == 1 then
                    comment = thisComment .. "\n" .. comment
                end
            end
        end
        
        if comment == "" then
            UI.mainCommentCtrlLbl:Hide()
            UI.mainCommentCtrl:Hide()
        else
            UI.mainCommentCtrlLbl:Show()
            UI.mainCommentCtrl:Show()
            
            UI.mainCommentCtrl:SetValue( comment )
        end
        UI.resultTreeBox:Layout()
        
        UI.createPackageBtn:Enable( true )
        
        event:Skip()
	end )
    
	UI.mainCompSrcRb:Connect( wx.wxEVT_COMMAND_RADIOBOX_SELECTED, function(event)
	--implements mainCompSrcRbToggled
        local selectedComps = {}
        
        for _, selection in pairs(  UI.resultTree:GetSelections() ) do
            table.insert( selectedComps, getPathName( UI.resultTree, selection ) )
        end
        rebuildResultTree( not UI.cadUpdateCb:IsChecked() )
        markIncompleteModules( UI.moduleTree, false, false )
        
        for _, selectedItemName in pairs( selectedComps ) do
            if targetTreeId[selectedItemName] then
                UI.resultTree:SelectItem( targetTreeId[selectedItemName] )
            end
        end
        
        --UI.cvsSyncBtn:Enable( UI.mainCompSrcRb:GetSelection() == 0 )
        
    end )
   
    
    UI.cadUpdateCb:Connect( wx.wxEVT_COMMAND_CHECKBOX_CLICKED, function(event)
	--implements cadUpdateCbToggled
        rebuildResultTree( not UI.cadUpdateCb:IsChecked() )
        markIncompleteModules( UI.moduleTree, false, UI.cadUpdateCb:IsChecked() )
	end )
	
	UI.mainUpdateCb:Connect( wx.wxEVT_COMMAND_CHECKBOX_CLICKED, function(event)
	--implements mainUpdateCbToggled
        rebuildResultTree( not UI.cadUpdateCb:IsChecked() )
	end )
    
    UI.createPackageBtn:Connect( wx.wxEVT_COMMAND_BUTTON_CLICKED, function(event)
	--implements createPackageBtnPressed
        maybeCreatePackage()
    end )

-- create editFrame
function UI.editMainSplitterOnIdle( event )
    --auto generated
    editFrameSash1PosDefault = 250
	UI.editMainSplitter:SetSashPosition( userSettings[os.getenv("username")]["editFrameSash1Pos"] or editFrameSash1PosDefault )
	UI.editMainSplitter:Disconnect( wx.wxEVT_IDLE )
	
end
function UI.editCompMainSplitterOnIdle( event )
    --auto generated
    editFrameSash2PosDefault = 0
	UI.editCompMainSplitter:SetSashPosition( userSettings[os.getenv("username")]["editFrameSash2Pos"] or editFrameSash2PosDefault )
	UI.editCompMainSplitter:Disconnect( wx.wxEVT_IDLE )
end
    
    local editFrameSize = wx.wxSize( 1000, 650 )
    
    local customWidth  = userSettings[os.getenv("username")]["editFrameSize_Width"] 
    local customHeight = userSettings[os.getenv("username")]["editFrameSize_Height"]
    
    if customWidth and customHeight then
        editFrameSize = wx.wxSize( customWidth, customHeight )
    end
    
    editFramePosition = wx.wxDefaultPosition
    
    local customXPos = userSettings[os.getenv("username")]["editFrameXPos"]
    local customYPos = userSettings[os.getenv("username")]["editFrameYPos"]
    
    if customXPos and customYPos then
        editFramePosition = wx.wxPoint( customXPos, customYPos )
    end
    
    UI.editFrame = wx.wxFrame (wx.NULL, wx.wxID_ANY,  "", editFramePosition, editFrameSize, wx.wxDEFAULT_FRAME_STYLE + wx.wxFRAME_FLOAT_ON_PARENT+wx.wxTAB_TRAVERSAL )
	UI.editFrame:SetSizeHints( wx.wxSize( 500, 200 ), wx.wxSize( -1,-1 ) )
	UI.editFrame:SetBackgroundColour( wx.wxColour( 171, 171, 171 ) )
    UI.editFrame:SetIcon( programIcon )
	
	UI.editMainBox = wx.wxBoxSizer( wx.wxVERTICAL )
	
	UI.editToolbar = wx.wxToolBar( UI.editFrame, wx.wxID_ANY, wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxTB_FLAT ) 
	UI.eTbLeaveEditFrame = UI.editToolbar:AddTool( wx.wxID_ANY, "", wx.wxBitmap( iconRoot .. "icons8-ausgang-26.png", wx.wxBITMAP_TYPE_ANY ), wx.wxNullBitmap, wx.wxITEM_NORMAL, "Bearbeitungsmodus verlassen (Strg+W)", "") 
	
	UI.editToolbar:AddSeparator()
	
    
	--UI.eTbSave = UI.editToolbar:AddTool( wx.wxID_ANY, "", wx.wxBitmap( iconRoot .. "icons8-save-26.png", wx.wxBITMAP_TYPE_ANY ), wx.wxBitmap( iconRoot .. "icons8-save-disabled-26.png", wx.wxBITMAP_TYPE_ANY ), wx.wxITEM_NORMAL, "Speichern (Strg+S)", "") 
	-- Wenn dem Speicherbutton eine Bitmap für den deaktivierten Zustand zugewiesen wird, haben der Zurück-, Wiederholen- und Einfügenknopf kaputte Bitmaps für den deaktivierten Zustand. Very strange indeed
    
    UI.eTbSave = UI.editToolbar:AddTool( wx.wxID_ANY, "", wx.wxBitmap( iconRoot .. "icons8-save-26.png", wx.wxBITMAP_TYPE_ANY ), wx.wxNullBitmap, wx.wxITEM_NORMAL, "Speichern (Strg+S)", "") 
    
	UI.eTbUndo = UI.editToolbar:AddTool( wx.wxID_ANY, "", wx.wxBitmap( iconRoot .. "icons8-undo-26.png", wx.wxBITMAP_TYPE_ANY ), wx.wxBitmap( iconRoot .. "icons8-undo-disabled-26.png", wx.wxBITMAP_TYPE_ANY ), wx.wxITEM_NORMAL, "Änderung rückgängig (Strg+Z)", "") 
	
	UI.eTbRedo = UI.editToolbar:AddTool( wx.wxID_ANY, "", wx.wxBitmap( iconRoot .. "icons8-redo-26.png", wx.wxBITMAP_TYPE_ANY ), wx.wxBitmap( iconRoot .. "icons8-redo-disabled-26.png", wx.wxBITMAP_TYPE_ANY ), wx.wxITEM_NORMAL, "Änderung wiederholen (Strg+Y)", "") 
	
	UI.editToolbar:AddSeparator()    
	
	UI.eTbChildAdd = UI.editToolbar:AddTool( wx.wxID_ANY, "", wx.wxBitmap( iconRoot .. "icons8-baum-neu-26.png", wx.wxBITMAP_TYPE_ANY ), wx.wxBitmap( iconRoot .. "icons8-baum-neu-disabled-26.png", wx.wxBITMAP_TYPE_ANY ), wx.wxITEM_NORMAL, "Baumelement hinzufügen (Strg +N)", "") 
	
    UI.eTbChildDelete = UI.editToolbar:AddTool( wx.wxID_ANY, "", wx.wxBitmap( iconRoot .. "icons8-baum-löschen-26.png", wx.wxBITMAP_TYPE_ANY ), wx.wxBitmap( iconRoot .. "icons8-baum-löschen-disabled-26.png", wx.wxBITMAP_TYPE_ANY ), wx.wxITEM_NORMAL, "Baumelement löschen (Strg+D / entf)", "") 
	
	UI.eTbChildCopy = UI.editToolbar:AddTool( wx.wxID_ANY, "", wx.wxBitmap( iconRoot .. "icons8-baum-kopieren-26.png", wx.wxBITMAP_TYPE_ANY ), wx.wxBitmap( iconRoot .. "icons8-baum-kopieren-disabled-26.png", wx.wxBITMAP_TYPE_ANY ), wx.wxITEM_NORMAL, "Baumelement kopieren (Strg+C)", "") 
	
	UI.eTbChildCut = UI.editToolbar:AddTool( wx.wxID_ANY, "", wx.wxBitmap( iconRoot .. "icons8-baum-ausschneiden-26.png", wx.wxBITMAP_TYPE_ANY ), wx.wxBitmap( iconRoot .. "icons8-baum-ausschneiden-disabled-26.png", wx.wxBITMAP_TYPE_ANY ), wx.wxITEM_NORMAL, "Baumelement ausschneiden (Strg+X)", "") 
	
	UI.eTbChildPaste = UI.editToolbar:AddTool( wx.wxID_ANY, "", wx.wxBitmap( iconRoot .. "icons8-baum-einfügen-26.png", wx.wxBITMAP_TYPE_ANY ), wx.wxBitmap( iconRoot .. "icons8-baum-einfügen-disabled-26.png", wx.wxBITMAP_TYPE_ANY ), wx.wxITEM_NORMAL, "Baumelement einfügen (Strg+V)", "") 
	
	UI.eTbTreeDefaultStructure = UI.editToolbar:AddTool( wx.wxID_ANY, "", wx.wxBitmap( iconRoot .. "icons8-baum-vorlage-26.png", wx.wxBITMAP_TYPE_ANY ), wx.wxNullBitmap, wx.wxITEM_NORMAL, "Standard-Struktur im Zielbaum erstellen", "") 
    
    UI.editToolbar:AddSeparator()
	
	UI.eTbCompAssignStructure = UI.editToolbar:AddTool( wx.wxID_ANY, "", wx.wxBitmap( iconRoot .. "icons8-struktur-zuordnen-26.png", wx.wxBITMAP_TYPE_ANY ), wx.wxNullBitmap, wx.wxITEM_NORMAL, "Datei zuordnen und Ziel automatisch bestimmen (Strg+Shift+Y)", "") 
	
    UI.eTbCompAssign = UI.editToolbar:AddTool( wx.wxID_ANY, "", wx.wxBitmap( iconRoot .. "icons8-datei-zuordnen-26.png", wx.wxBITMAP_TYPE_ANY ), wx.wxNullBitmap, wx.wxITEM_NORMAL, "Datei dem aktuell ausgewählten Zielordner zuordnen (Shift+Y)", "") 
	
	UI.eTbCompUnassign = UI.editToolbar:AddTool( wx.wxID_ANY, "", wx.wxBitmap( iconRoot .. "icons8-datei-lösen-26.png", wx.wxBITMAP_TYPE_ANY ), wx.wxNullBitmap, wx.wxITEM_NORMAL, "Dateizuordnung lösen (Strg+D / entf)", "") 
	
	UI.eTbCompNoUpdate = UI.editToolbar:AddTool( wx.wxID_ANY, "", wx.wxBitmap( iconRoot .. "icons8-input-filled-26.png", wx.wxBITMAP_TYPE_ANY ), wx.wxNullBitmap, wx.wxITEM_NORMAL, "Die markierte Komponente darf bei einem CA-Link Update nicht überschrieben werden (Strg+U)", "") 
	
	UI.eTbCompRefresh = UI.editToolbar:AddTool( wx.wxID_ANY, "", wx.wxBitmap( iconRoot .. "icons8-synchronize-26.png", wx.wxBITMAP_TYPE_ANY ), wx.wxNullBitmap, wx.wxITEM_NORMAL, "Komponentenexplorer aktualisieren", "") 
	
	UI.editToolbar:AddSeparator()
	
	UI.eTbOpenManual = UI.editToolbar:AddTool( wx.wxID_ANY, "", wx.wxBitmap( iconRoot .. "icons8-literatur-26.png", wx.wxBITMAP_TYPE_ANY ), wx.wxNullBitmap, wx.wxITEM_NORMAL, "Bedienungsanleitung öffnen", "") 
    
	UI.editToolbar:Realize() 
	
	UI.editMainBox:Add( UI.editToolbar, 0, wx.wxEXPAND, 5 )
	
	UI.editMainSplitter = wx.wxSplitterWindow( UI.editFrame, wx.wxID_ANY, wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxSP_LIVE_UPDATE + wx.wxSP_NO_XP_THEME )
	UI.editMainSplitter:SetSashGravity( 0 )
	UI.editMainSplitter:Connect( wx.wxEVT_IDLE,UI.editMainSplitterOnIdle )
	UI.editMainSplitter:SetMinimumPaneSize( 100 )
	
	UI.editMainSplitter:SetBackgroundColour( wx.wxColour( 171, 171, 171 ) )
	
	UI.editModulePanel = wx.wxPanel( UI.editMainSplitter, wx.wxID_ANY, wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxTAB_TRAVERSAL )
	UI.editModulePanelFgSizer = wx.wxFlexGridSizer( 0, 2, 0, 0 )
	UI.editModulePanelFgSizer:AddGrowableCol( 0 )
	UI.editModulePanelFgSizer:AddGrowableRow( 0 )
	UI.editModulePanelFgSizer:SetFlexibleDirection( wx.wxHORIZONTAL )
	UI.editModulePanelFgSizer:SetNonFlexibleGrowMode( wx.wxFLEX_GROWMODE_SPECIFIED )
	
	UI.editModulePanelBSizer = wx.wxBoxSizer( wx.wxVERTICAL )
	
	UI.editModuleTreeLbl = wx.wxStaticText( UI.editModulePanel, wx.wxID_ANY, "Module", wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxALIGN_CENTRE )
	UI.editModuleTreeLbl:Wrap( -1 )
	UI.editModuleTreeLbl:SetBackgroundColour( wx.wxColour( 255, 255, 255 ) )
	
	UI.editModulePanelBSizer:Add( UI.editModuleTreeLbl, 0, wx.wxALL + wx.wxALIGN_CENTER_HORIZONTAL + wx.wxEXPAND, 5 )
	
	UI.editModuleTree = wx.wxTreeCtrl( UI.editModulePanel, wx.wxID_ANY, wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxTR_EDIT_LABELS + wx.wxTR_HAS_BUTTONS + wx.wxTR_LINES_AT_ROOT )
	UI.editModuleTree:SetMinSize( wx.wxSize( -1,400 ) )
	
	UI.editModulePanelBSizer:Add( UI.editModuleTree, 1, wx.wxEXPAND + wx.wxTOP + wx.wxLEFT + wx.wxRIGHT, 5 )
    
    UI.editCommentCtrlLbl = wx.wxStaticText( UI.editModulePanel, wx.wxID_ANY, "Beschreibung / Kommentar", wx.wxDefaultPosition, wx.wxDefaultSize, 0 )
	UI.editCommentCtrlLbl:Wrap( -1 )
	UI.editModulePanelBSizer:Add( UI.editCommentCtrlLbl, 0, wx.wxTOP + wx.wxRIGHT + wx.wxLEFT + wx.wxALIGN_CENTER_HORIZONTAL, 5 )
	
	UI.editCommentCtrl = wx.wxTextCtrl( UI.editModulePanel, wx.wxID_ANY, "", wx.wxDefaultPosition, wx.wxSize( -1,100 ), wx.wxHSCROLL + wx.wxTE_MULTILINE )
	UI.editModulePanelBSizer:Add( UI.editCommentCtrl, 0, wx.wxEXPAND + wx.wxALL, 5 )
	
	
	UI.editModulePanelFgSizer:Add( UI.editModulePanelBSizer, 1, wx.wxEXPAND, 5 )
	
	
	UI.editModulePanelFgSizer:Add( 20, 0, 1, wx.wxEXPAND, 5 )
	
	
	UI.editModulePanel:SetSizer( UI.editModulePanelFgSizer )
	UI.editModulePanel:Layout()
	UI.editModulePanelFgSizer:Fit( UI.editModulePanel )
	UI.editCompPanel = wx.wxPanel( UI.editMainSplitter, wx.wxID_ANY, wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxTAB_TRAVERSAL )
	UI.editCompPanelBSizer = wx.wxBoxSizer( wx.wxVERTICAL )
	
	UI.editCompMainSplitter = wx.wxSplitterWindow( UI.editCompPanel, wx.wxID_ANY, wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxSP_LIVE_UPDATE + wx.wxSP_NO_XP_THEME )
	UI.editCompMainSplitter:SetSashGravity( 0.5 )
	UI.editCompMainSplitter:Connect( wx.wxEVT_IDLE,UI.editCompMainSplitterOnIdle )
	UI.editCompMainSplitter:SetMinimumPaneSize( 200 )
	
	UI.editCompMainSplitter:SetBackgroundColour( wx.wxColour( 171, 171, 171 ) )
	
	UI.editCompSourcePanel = wx.wxPanel( UI.editCompMainSplitter, wx.wxID_ANY, wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxTAB_TRAVERSAL )
	UI.editCompSourcePanel:SetBackgroundColour( wx.wxColour( 171, 171, 171 ) )
	
	UI.editCompSourceBSizer = wx.wxBoxSizer( wx.wxVERTICAL )
	
	UI.editCompTreeLbl = wx.wxStaticText( UI.editCompSourcePanel, wx.wxID_ANY, "Quelle", wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxALIGN_CENTRE )
	UI.editCompTreeLbl:Wrap( -1 )
	UI.editCompTreeLbl:SetBackgroundColour( wx.wxColour( 255, 255, 255 ) )
	
	UI.editCompSourceBSizer:Add( UI.editCompTreeLbl, 0, wx.wxALIGN_CENTER_VERTICAL + wx.wxALL+ wx.wxALIGN_CENTER_HORIZONTAL + wx.wxEXPAND, 5 )
	
	UI.editCompTreePathLbl = wx.wxStaticText( UI.editCompSourcePanel, wx.wxID_ANY, "Komponentenexplorer", wx.wxDefaultPosition, wx.wxDefaultSize, 0 )
	UI.editCompTreePathLbl:Wrap( -1 )
	UI.editCompTreePathLbl:SetBackgroundColour( wx.wxColour( 171, 171, 171 ) )
	
	UI.editCompSourceBSizer:Add( UI.editCompTreePathLbl, 0, wx.wxALL + wx.wxEXPAND, 5 )
	
	UI.editCompTree = wx.wxTreeCtrl( UI.editCompSourcePanel, wx.wxID_ANY, wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxTR_HAS_BUTTONS + wx.wxTR_LINES_AT_ROOT + wx.wxTR_MULTIPLE )
	UI.editCompTree:SetBackgroundColour( wx.wxColour( 255, 255, 255 ) )
	UI.editCompTree:SetMinSize( wx.wxSize( -1,150 ) )
	
	UI.editCompSourceBSizer:Add( UI.editCompTree, 1, wx.wxEXPAND + wx.wxTOP + wx.wxLEFT + wx.wxRIGHT, 5 )
	
	
	UI.editCompSourcePanel:SetSizer( UI.editCompSourceBSizer )
	UI.editCompSourcePanel:Layout()
	UI.editCompSourceBSizer:Fit( UI.editCompSourcePanel )
	UI.editCompTargetPanel = wx.wxPanel( UI.editCompMainSplitter, wx.wxID_ANY, wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxTAB_TRAVERSAL )
	UI.editCompTargetPanelBSizer = wx.wxBoxSizer( wx.wxVERTICAL )
	
	UI.editTargetTreeLbl = wx.wxStaticText( UI.editCompTargetPanel, wx.wxID_ANY, "Ziel", wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxALIGN_CENTRE )
	UI.editTargetTreeLbl:Wrap( -1 )
	UI.editTargetTreeLbl:SetBackgroundColour( wx.wxColour( 255, 255, 255 ) )
	
	UI.editCompTargetPanelBSizer:Add( UI.editTargetTreeLbl, 0, wx.wxTOP + wx.wxBOTTOM + wx.wxLEFT + wx.wxALIGN_CENTER_HORIZONTAL + wx.wxEXPAND, 5 )
	
	UI.editCompLbl = wx.wxStaticText( UI.editCompTargetPanel, wx.wxID_ANY, "", wx.wxDefaultPosition, wx.wxDefaultSize, 0 )
	UI.editCompLbl:Wrap( -1 )
	UI.editCompLbl:SetBackgroundColour( wx.wxColour( 171, 171, 171 ) )
	
	UI.editCompTargetPanelBSizer:Add( UI.editCompLbl, 0, wx.wxALL + wx.wxEXPAND, 5 )
	
	UI.editTargetTree = wx.wxTreeCtrl( UI.editCompTargetPanel, wx.wxID_ANY, wx.wxDefaultPosition, wx.wxDefaultSize, 
        wx.wxTR_EDIT_LABELS + wx.wxTR_HAS_BUTTONS + wx.wxTR_LINES_AT_ROOT + wx.wxTR_MULTIPLE )
    
    UI.editTargetTree:DragAcceptFiles( true )
    
	UI.editCompTargetPanelBSizer:Add( UI.editTargetTree, 1, wx.wxEXPAND + wx.wxTOP + wx.wxLEFT, 5 )
	
	
	UI.editCompTargetPanel:SetSizer( UI.editCompTargetPanelBSizer )
	UI.editCompTargetPanel:Layout()
	UI.editCompTargetPanelBSizer:Fit( UI.editCompTargetPanel )
	UI.editCompMainSplitter:SplitVertically( UI.editCompSourcePanel, UI.editCompTargetPanel, 0 )
	UI.editCompMainSplitter:SetSplitMode(2)
	UI.editCompPanelBSizer:Add( UI.editCompMainSplitter, 1, wx.wxEXPAND, 5 )
	
	
	UI.editCompPanel:SetSizer( UI.editCompPanelBSizer )
	UI.editCompPanel:Layout()
	UI.editCompPanelBSizer:Fit( UI.editCompPanel )
	UI.editMainSplitter:SplitVertically( UI.editModulePanel, UI.editCompPanel, 200 )
	UI.editMainSplitter:SetSplitMode(2)
	UI.editMainBox:Add( UI.editMainSplitter, 1, wx.wxEXPAND + wx.wxBOTTOM + wx.wxRIGHT + wx.wxLEFT, 5 )
	
	
	UI.editFrame:SetSizer( UI.editMainBox )
	UI.editFrame:Layout()
	
	UI.editFrame:Centre( wx.wxBOTH )
    
	-- Connect Events
    
    --Methoden der Toolbar, von links nach rechts
    function closeEditFrame( completeClose )
        --Bearbeitungsmodus verlassen.
        
        -- completeClose: Das Hauptfenster wird nicht wiederhergestellt, somit kann das Programm schneller komplett beendet werden.
        
        if somethingWasEdited then
            local closeOption = wx.wxMessageDialog( UI.editFrame, "Das Bearbeitungsfenster weist nicht gespeicherte Änderungen auf. Möchtest Du diese speichern?", 
                "Bearbeitungsfenster wird geschlossen", wx.wxYES_NO + wx.wxCANCEL ):ShowModal()
            if closeOption == wx.wxID_YES then
                saveChanges()
            elseif closeOption == wx.wxID_NO then
                dofile( databaseRoot .. "data.lua" ) --Um den ursprünglichen Stand einzulesen
                initialiseDataTables()
                editHappened( false )
            else
                return -1
            end
        end
        
        saveUserSettings()
        
        local expandedModules = {}
        for moduleName, moduleId in pairs( module_id ) do
            if UI.editModuleTree:IsExpanded( moduleId ) then
                table.insert( expandedModules, moduleName )
            end
        end
        
        local selectedModule = ""
        if UI.editModuleTree:GetSelection():IsOk() then
            selectedModule = getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() )
        end
        
        fillModuleTree( UI.moduleTree, false ) --Um module_id mit IDs für "UI.moduleTree" zu füllen
        for _, moduleName in pairs( expandedModules ) do
            if module_id[moduleName] then
                UI.moduleTree:Expand( module_id[moduleName] )
            end
        end
        UI.resultTree:DeleteAllItems()
        
        
        UI.mainCompSrcRb:SetSelection( UI.mainCompSrcRbPrevState or 0 )
        UI.cadUpdateCb:SetValue( false )
        UI.mainUpdateCb:SetValue( false )
        
        if not completeClose then
            if doCheckModulesComplete then
                UI.loadingScreen:Show()
                UI.loadingDlgLbl:SetLabel( "Die Änderungen werden auf das Hauptfenster angewandt..." )
                UI.loadingDlgGauge:SetRange( UI.moduleTree:GetChildrenCount( UI.moduleTree:GetRootItem(), true ) )
                UI.loadingDlgGauge:SetValue( 0 )
            end
            markIncompleteModules( UI.moduleTree, doCheckModulesComplete, false )
        end
        
        editHappened( false )
        
        UI.editFrame:Show( false )
        
        if not completeClose then
            UI.mainFrame:Show( true )
            
            if false and selectedModule ~= "" and module_id[selectedModule] then
                --Sorgt aus unbekannten Gründen für Instabilität
                rebuildResultTree( true )
                UI.moduleTree:SelectItem( module_id[selectedModule] ) 
            end
        end
        
        os.remove( databaseRoot .. "editMode.lock" )
        removeDataRevisionsFolder()
        
        return 0
    end
    
    function editFrameSaveButtonPressed()   
        -- Knopf zum Speichern oder Strg+S wurde gedrückt 
        
        if not somethingWasEdited then
            wx.wxMessageBox( "Es wurden keine Änderungen durchgeführt.", "Speichern nicht nötig" )
            return
        end
        UI.editFrame:Enable( false )
        saveChanges()
        doCheckModulesComplete = true
        UI.editFrame:Enable( true )
        savedRevision = editRevision
        --markIncompleteModules( UI.editModuleTree, false, true )
        UI.editToolbar:EnableTool( UI.eTbChildPaste:GetId(), false )
        UI.editFrame:SetFocus( true )
    end
    
    function undoEdit()
        --Rückgängig-Pfeil oder Strg+Z wurde gedrückt
        UI.editFrame:Enable( false )
        editRevision = editRevision -1
        if editRevision == savedRevision then
            editHappened( false )
        else
            editHappened( true, true )
        end
        
        restoreEditRevision()
        UI.editToolbar:EnableTool( UI.eTbRedo:GetId(), true )
        UI.editFrame:Enable( true )
        UI.editFrame:SetFocus( true )
    end
    
    function redoEdit()
        --Wiederholen-Pfeil oder Strg+Y wurde gedrückt
        UI.editFrame:Enable( false )
        editRevision = editRevision +1
        restoreEditRevision()
        if not fileExists( dataRevisionRoot .. "data" .. editRevision +1 .. ".lua" ) then
            UI.editToolbar:EnableTool( UI.eTbRedo:GetId(), false )
        end
        UI.editToolbar:EnableTool( UI.eTbUndo:GetId(), true )
        
        --Kann nicht mit "editHappened(true)" gemacht werden, da dort der Button deaktiviert und folgende Revisionen gelöscht werden
        if editRevision == savedRevision then
            editHappened( false )
        else
            editHappened( true, true )
        end
        
        UI.editFrame:Enable( true )
        UI.editFrame:SetFocus( true )
    end

    function createNewTreeItem( tree, parentItem )
        --Neues Baumelement anlegen (Knopf in Toolbar oder Strg+N)
        if tree == nil then
            wx.wxMessageBox( "Der zu bearbeitende Baum konnte nicht bestimmt werden!", "Baumelement hinzufügen", wx.wxICON_WARNING )
            return
        end
        if tree == UI.editTargetTree and tree:GetChildrenCount( tree:GetRootItem(), true ) == 0 then
            addNewModule( tree:GetRootItem(), "Standard" .. getCaVerFromModule() )
            return
        elseif parentItem == nil or not parentItem:IsOk() then
            wx.wxMessageBox( "Es wurde kein Element ausgewählt, dem ein neues hinzugefügt werden soll.", "Fehler bei Modulneuanlage" )
            return
        end
        UI.editNameLbl:SetLabel( "Bezeichnung für neues Element an \"" .. getPathName( tree, parentItem ) .. "\"" )
        UI.editNameTxtctrl:SetValue( "" )
        UI.editNameFrame:Show()
        UI.editFrame:Enable( false )
        UI.editNameTxtctrl:SetFocus()
    end
    
    function deleteTreeItem( tree, item, quiet )
        --Diese Funktion löscht nur ein einzelnes Item und wird nie direkt, sondern nur von deleteSelectedTreeItems aufgerufen
        --tree:     Der Baum, in dem ein Item gelöscht wird
        --item:     Das zu löschende Item
        --quiet:    Es werden keine Meldungen angezeigt (außer Fehlermeldungen bei ungültigen Parametern)
        
        if focusedTree == nil then
            wx.wxMessageBox( "Der zu bearbeitende Baum konnte nicht bestimmt werden!", "Fehler bei Baumbearbeitung", wx.wxICON_WARNING )
            return -1
        end
        if item == nil or not item:IsOk() then
            wx.wxMessageBox( "Es wurde kein Element zum Löschen ausgewählt.", "Löschen fehlgeschlagen" )
            return -1
        end
        if getPathName( tree, item ) == getPathName( tree, tree:GetRootItem() ) then
            wx.wxMessageBox( "Das Root-Item kann nicht gelöscht werden!", "Löschen fehlgeschlagen", wx.wxICON_WARNING )
            return -1
        end

        if tree == UI.editModuleTree then  
            if not quiet then
                if wx.wxMessageDialog( UI.editFrame, "Soll \"" .. getPathName( tree, item ) .. 
                    "\" " .. ( tree:ItemHasChildren( item ) and "mit allen untergeordneten Elementen " or "" ) .. 
                    "wirklich gelöscht werden?", "Modul löschen bestätigen", wx.wxYES_NO + wx.wxNO_DEFAULT + wx.wxICON_WARNING ):ShowModal() 
                    == wx.wxID_NO 
                then return -1 end
            end
            
            --Modulzuordnungen löschen
            local delModPath = getPathName( tree, item )
            for modulePath, filePathTable in pairs( compRel ) do
                if modulePath:find( delModPath, 1, true ) == 1 then
                    --zu löschende filePathTable in compRel gefunden
                    for _, file in pairs( compRel[modulePath] ) do
                        if not fileIsInUse( file.source, modulePath ) and item_id[buildRoot .. file.source] then
                            local currId = item_id[buildRoot .. file.source]
                            while currId:IsOk() do
                                UI.editCompTree:SetItemBackgroundColour( currId, unusedCompColour )
                                currId = UI.editCompTree:GetItemParent( currId )
                            end
                        end
                        
                    end
                    compRel[modulePath] = nil
                end
            end
            --Kommentare löschen
            for modulePath in pairs( comments ) do
                if modulePath:find( delModPath, 1, true ) == 1 then
                    comments[modulePath] = nil
                end
            end
            
            module_id[delModPath] = nil
            tree:Delete( item ) 
            
        elseif tree == UI.editTargetTree then
            local function deleteSingleElement( element )
                local moduleName = getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() )
                local compSource
                if compRel[moduleName] then
                    --Wenn dem Modul Komponenten zugeordnet sind, die gelöschte Komponente entfernen
                    local i = 1
                    for _, file in ipairs( compRel[moduleName] ) do
                        if file.target == getPathName( UI.editTargetTree, element ) then
                            compSource = compRel[moduleName][i].source
                            table.remove( compRel[moduleName], i )
                            break
                        end
                        i = i +1
                    end
                    
                    if #compRel[moduleName] == 0 then
                        compRel[moduleName] = nil
                    end
                    
                end
                local elementName = getPathName( UI.editTargetTree, element )
                if not fileIsInUse( compSource, moduleName ) and item_id[buildRoot .. tostring( compSource )] then
                    table.insert( unusedFiles, buildRoot .. compSource )
                    local currId = item_id[buildRoot .. compSource]
                    while currId:IsOk() do
                        UI.editCompTree:SetItemBackgroundColour( currId, unusedCompColour )
                        currId = UI.editCompTree:GetItemParent( currId )
                    end
                end                
                targetTreeId[elementName] = nil
                UI.editTargetTree:Delete( element )
            end
            local function deleteFolder( folder )
                local child_id_array = {}
                --Zuerst müssen alle zu löschenden IDs ermittelt werden, bevor sie gelöscht werden
                
                for child_id in childrenOf( UI.editTargetTree, folder, false ) do
                    table.insert( child_id_array, child_id )
                end
                
                for _, child_id in pairs( child_id_array ) do
                    if UI.editTargetTree:ItemHasChildren( child_id ) then
                        deleteFolder( child_id )
                    else
                        deleteSingleElement( child_id )
                    end
                end
                
                --print( "deleting folder:", getPathName( UI.editTargetTree, folder ) )
                UI.editTargetTree:Delete( folder )
            end
            
            if UI.editTargetTree:ItemHasChildren( item ) then
                deleteFolder( item )
            else
                deleteSingleElement( item )
            end
        end
        return 0
    end
    
    function copyTreeItems()
        --Markierte Baumelemente in der 'Zwischenablage' sichern. Eigentlich werden sie nur in Variablen gesteckt.
        --Aufrufbar durch Knopf in Toolbar, Stg+C oder Strg+EVT_TREE_BEGIN_DRAG
        
        if focusedTree == nil then
            wx.wxMessageBox( "Der zu bearbeitende Baum konnte nicht bestimmt werden!", "Fehler bei Baumbearbeitung", wx.wxICON_WARNING )
            return -1
        end
        if focusedTree == UI.editModuleTree and not UI.editModuleTree:GetSelection():IsOk() then
            wx.wxMessageBox( "Es wurde kein Element zum Kopieren ausgewählt.", "Fehler beim Kopieren" )
            return -1
        elseif focusedTree == UI.editTargetTree and #( UI.editTargetTree:GetSelections() ) < 1 then
            wx.wxMessageBox( "Es wurden keine Elemente zum Kopieren ausgewählt.", "Fehler beim Kopieren" )
            return -1
        end
        
        -----------------Variablen, die beim Einfügen ausgelesen werden---------------
        originIDs = {};
        originNames = {} 
        originPaths = {}
        
        if focusedTree == UI.editModuleTree then table.insert( originIDs, focusedTreeGetSelection() )
        elseif focusedTree == UI.editTargetTree then for _, selection in pairs( UI.editTargetTree:GetSelections() ) do table.insert( originIDs, selection ) end
        end 
        
        for _, originId in pairs( originIDs ) do 
            table.insert( originNames, focusedTree:GetItemText( originId ) )
            table.insert( originPaths, getPathName( focusedTree, originId ) )
        end
        
        originTree = focusedTree
        sourceModule = UI.editModuleTree:GetSelection()
        
        --------------------------------------------------------------------------------
        
        -- Die Struktur hinter den kopierten Elementen zwischenspeichern
        tmpTreeStructure = {}
        
        for originObjIndex, originId in pairs( originIDs ) do
            
            -- Ausgangstabelle erzeugen
            local currFile = io.open( databaseRoot .. "targetTreeStructure.lua", "w+" )
            currFile:write( "targetTreeStructure = {\n" )
            serializeTree( focusedTree, focusedTree:GetRootItem(), currFile , "" )
            currFile:close()
            dofile( databaseRoot .. "targetTreeStructure.lua" )
            os.remove( databaseRoot .. "targetTreeStructure.lua" )
            
            -- Tabelle targetTreeStructure auf die Struktur unterhalb des kopierten Elements reduzieren
            for tableName in getPathName( focusedTree, originId ):gmatch( "[^\\]+" ) do
                if tableName ~= getPathName( focusedTree, focusedTree:GetRootItem() ) then
                    targetTreeStructure = targetTreeStructure[tableName]
                end
            end
            
            -- Tabelle targetTreeStructure mit Index unter tmpTreeStructure speichern
            tmpTreeStructure[originObjIndex] = table.copy( targetTreeStructure )
            
        end
        
        
        -- Die zugeordneten Komponenten in einer Zwischentabelle speichern.
        -- Wenn das kopierte Element aus editTargetTree stammt, nur die erwarteten Komponenten mitnehmen
        tmpComps = {}
        local oldPath = getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() )
        for moduleName, filePathArray in pairs( compRel ) do
            
            if ( focusedTree == UI.editModuleTree and moduleName:find( oldPath, 1, true ) == 1 )
            or focusedTree == UI.editTargetTree and moduleName == oldPath 
            then
                local newFilePathArray = {}
                
                if focusedTree == UI.editTargetTree then
                    local targetParentPaths = {}
                    for _, selectedFile in pairs( UI.editTargetTree:GetSelections() ) do
                        table.insert( targetParentPaths, getPathName( UI.editTargetTree, selectedFile ) )
                    end
                    
                    --print( "targetParentPaths:" ); for k, v in pairs( targetParentPaths ) do print( k, v ) end
                    
                    for _, targetParentPath in pairs( targetParentPaths ) do
                        for i, file in pairs( filePathArray ) do
                            if (file.target):find(targetParentPath, 1, true ) ~= nil then
                                --print( "inserting:", file.target )
                                
                                local newFile = {}; newFile.source = file.source; newFile.target = file.target
                                newFilePathArray[i] = newFile
                            end
                        end
                    end
                else
                    newFilePathArray = table.copy( filePathArray )
                end
                
                tmpComps[moduleName:sub( oldPath:len() + 2 )] = newFilePathArray
            end
        end     
        
        --[[
        local file = io.open( databaseRoot .. "tmpComps.lua", "w" )
        file:write( "tmpComps = " )
        serialize( tmpComps, file, "    " )
        file:close()
        
        local file = io.open( databaseRoot .. "tmpTreeStructure.lua", "w" )
        file:write( "tmpTreeStructure = " )
        serialize( tmpTreeStructure, file, "    " )
        file:close()
        --]]
        
        UI.editToolbar:EnableTool( UI.eTbChildPaste:GetId(), true )
        treeItemWasCut = false
    end
    
    function cutTreeItems()
        -- Kopiert die Module, aber setzt eine Variable, sodass die Quell-Elemente nach dem Einfügen gelöscht werden
        --Aufrufbar durch Knopf in Toolbar, Strg+X oder EVT_TREE_BEGIN_DRAG
        if focusedTree == nil then
            wx.wxMessageBox( "Der zu bearbeitende Baum konnte nicht bestimmt werden!", "Fehler bei Baumbearbeitung", wx.wxICON_WARNING )
            return
        end
        if focusedTree == UI.editModuleTree and not UI.editModuleTree:GetSelection():IsOk() then
            wx.wxMessageBox( "Es wurde kein Element zum Ausschneiden ausgewählt.", "Fehler beim Kopieren" )
            return -1
        elseif focusedTree == UI.editTargetTree and #( UI.editTargetTree:GetSelections() ) < 1 then
            wx.wxMessageBox( "Es wurden keine Elemente zum Ausschneiden ausgewählt.", "Fehler beim Kopieren" )
            return -1
        end
        for _, thisModuleId in pairs( focusedTree == UI.editModuleTree and module_id or targetTreeId ) do
            if focusedTree:GetItemTextColour( thisModuleId ):GetAsString( wx.wxC2S_HTML_SYNTAX ) == wx.wxLIGHT_GREY:GetAsString( wx.wxC2S_HTML_SYNTAX ) then
                focusedTree:SetItemTextColour( thisModuleId, wx.wxBLACK )
            end
        end
        
        copyTreeItems()
        
        if originIDs then --Kopiervorgang erfolgreich
            treeItemWasCut = true
            preCutItemColour = {}
            for _, originId in pairs( originIDs ) do 
                preCutItemColour[getPathName( focusedTree, originId )] = focusedTree:GetItemTextColour( originId )
                focusedTree:SetItemTextColour( originId, wx.wxLIGHT_GREY ) 
            end
            focusedTree:Unselect()
        end
    end
    
    function pasteTreeItems()
        --Fügt die kopierten Baumelemente wieder ein und aktualisiert die ID-Tables. Außerdem werden bei
        --Modulen: Die Zuordnungstabelle des Quell-Moduls auf die Kopie übertragen
        --Zieldateien / Ordnern: Die einzelnen zugeordneten Dateien in die Zuordnungstabelle des beim Einfügen ausgewählten Moduls übertragen
        --
        --Aufgerufen durch Knopf in Toolbar, Strg+V oder Strg+EVT_TREE_END_DRAG
        
        if focusedTree == nil then
            wx.wxMessageBox( "Der zu bearbeitende Baum konnte nicht bestimmt werden!", "Fehler beim Einfügen", wx.wxICON_WARNING )
            return -1
        end
        if focusedTree ~= originTree then
            wx.wxMessageBox( "Quell- und Zielbaum müssen identisch sein!", "Element kann nicht eingefügt werden", wx.wxICON_WARNING )
            return -1
        end
        if focusedTree == UI.editTargetTree and #( focusedTree:GetSelections() ) > 1 then
            wx.wxMessageBox( "Bitte beschränke deine Auswahl auf ein Element, um etwas einzufügen.", "Einfügen fehlgeschlagen", wx.wxICON_WARNING )
            return -1
        end
        if not focusedTreeGetSelection():IsOk() then
            wx.wxMessageBox( "Bitte wähle ein Element aus, dem du die Kopie anhängen möchtest", "Einfügen fehlgeschlagen" )
            return -1
        end
        if originIDs == nil or tmpTreeStructure == nil then
            wx.wxMessageBox( "Beim Kopieren wurden Daten nicht korrekt in der Zwischenablage gespeichert. Bitte versuche es noch einmal.", "Fehler beim Kopieren", wx.wxICON_ERROR )
            return -1
        end
        
        local targetPath = getPathName( focusedTree, focusedTreeGetSelection() )                
        if focusedTree == UI.editTargetTree and compRel[getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() )] then
            for _, file in pairs( compRel[getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() )] ) do
                if file.target == targetPath then
                    --Zielpfad auf den Ordner lenken, in dem die im Zielbaum ausgewählte Datei liegt
                    targetPath = getPathName( UI.editTargetTree, UI.editTargetTree:GetItemParent( targetTreeId[targetPath] ) )
                    break
                end
            end
        end
        
        
        if treeItemWasCut then
            local check = true
            if focusedTree == UI.editTargetTree and getPathName( UI.editModuleTree, sourceModule ) ~= getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() ) then
                --Nur wenn es sich beim Einfügen um das selbe Modul handelt, kann die Datei nicht in sich selbst eingefügt werden
                check = false
            end
            if check then
                for _, originId in pairs( originIDs ) do
                    if targetPath:find( getPathName( focusedTree, originId ), 1, true ) == 1 then
                        wx.wxMessageBox( "Du kannst ein ausgeschnittenes Modul nicht in sich selbst einfügen!", "Fehler beim Einfügen" )
                        return -1
                    end
                end
            end
        end
        
        local tableRef
        if focusedTree == UI.editModuleTree then
            tableRef = module_id
        elseif focusedTree == UI.editTargetTree then
            tableRef = targetTreeId
        else
            wx.wxMessageBox( "Pasted in an invalid wxTreeCtrl!", "Error", wx.wxICON_ERROR )
            return -1
        end
        
        UI.editFrame:Enable( false )
        
        local invalidNames = 0
        -- Der gleiche Index einer jeden origin*-Table bezieht sich immer auf dasselbe Item
        -- Verfügbare object-tables:
        --      originIDs
        --      originNames
        --      originPaths
        --
        -- Verfügbare Elemente, die nicht in tables aufgeführt sind
        --      sourceModule
        --      originTree
        
        for originObjIndex, originName in pairs( originNames ) do
            
            local newItemName = tableRef[targetPath .. "\\" .. originName] and originName .. " - Kopie" or originName 
            if validateName( focusedTree, tableRef[targetPath], newItemName ) then
                
                local newItemId = focusedTree:AppendItem( tableRef[targetPath], newItemName )        
                tableRef[getPathName( focusedTree, newItemId )] = newItemId
                
                -- Erzeugt nicht den kompletten Baum neu, sondern nur ab dem Punkt des eingefügten Elements
                createModuleTree( focusedTree, tmpTreeStructure[originObjIndex], newItemId)
                
                if focusedTree == UI.editModuleTree then
                    
                    comments[getPathName( focusedTree, newItemId )] = comments[originPaths[originObjIndex]]
                    
                    for thisModulePath, filePathTable in pairs( tmpComps ) do
                        local newModuleName = getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() ) .. "\\" .. newItemName .. ( thisModulePath == "" and "" or "\\" .. thisModulePath )
                        
                        --Zugeordnete Komponenten einfügen
                        compRel[newModuleName] = table.copy( filePathTable )
                        
                        -- Fügt den Inhalt der ein Zielstruktur, der nicht in "compRel" beschrieben ist (aka leere Ordner)
                        createModuleTree( UI.editTargetTree, targetStructure[originPaths[originObjIndex]] or {}, UI.editTargetTree:GetRootItem() )
                    end
                elseif focusedTree == UI.editTargetTree then
                    if not sourceModule:IsOk() then
                        wx.wxMessageBox( "Das Modul, aus dem die Zielstruktur stammt, ist ungültig!", "Fehler beim Einfügen", wx.wxICON_ERROR )
                        return
                    end    
                    
                    if compRel[getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() )] == nil then
                        compRel[getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() )] = {}
                    end
                    
                    if getPathName( UI.editModuleTree, sourceModule ) == getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() ) then
                        -- Gleiches Modul -> Bearbeitungen innerhalb des gleichen compRel-Arrays
                        for i, file in sortedKeys( compRel[getPathName( UI.editModuleTree, sourceModule )] ) do
                        local pathStart, pathEnd = (file.target):find( getPathName( UI.editTargetTree, originIDs[originObjIndex] ), 1, true )
                        
                            if pathStart == 1 then --Der Pfad des zu modifizierenden Objektes beginnt mit dem Namen des kopierten Objektes 
                                                   --(aka es ist die gleiche Datei oder sie lag in dem Ordner, der kopiert wurde) 
                                local newTarget = getPathName( UI.editTargetTree, newItemId ) .. (file.target):sub( pathEnd +1 )
                                
                                if treeItemWasCut then
                                    --print( "modifying:", file.target, "to", newTarget )
                                    file.target = newTarget
                                else
                                    print( "copying:", file.target, "to", newTarget )
                                    local newFile = {}
                                    newFile.source = file.source
                                    newFile.target = newTarget
                                    table.insert( compRel[getPathName( UI.editModuleTree, sourceModule )], newFile )
                                end
                            end
                        end
                    else
                        -- Anderes Modul -> Kopierte Dateien von Quell- auf Zielmodul übertragen
                        local modulePath = getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() )
                        if compRel[modulePath] == nil then compRel[modulePath] = {} end
                        for thisModulePath, fileArray in pairs( tmpComps ) do
                            for i, file in pairs( fileArray ) do
                                if (file.target):find( originPaths[originObjIndex], 1, true ) == 1 then
                            
                                    local newBase = targetPath .. "\\" .. newItemName .. ( thisModulePath == "" and "" or "\\" .. thisModulePath )
                                    local newTargetPath = file.target:gsub( originPaths[originObjIndex], newBase )
                                    
                                    --print( "new File. source: " .. file.source, "target: ", newTargetPath )
                                    
                                    local newFile = {}; newFile.source = file.source; newFile.target = newTargetPath
                                    
                                    table.insert( compRel[modulePath], newFile )
                                end
                            end
                        end
                    end
                end
                
                if treeItemWasCut then
                    deleteTreeItem( focusedTree, originIDs[originObjIndex], true )
                end
            else
                invalidNames = invalidNames +1
            end
        end
        
        updateEditCompLbl()
        markIncompleteModules( UI.editModuleTree, false, true )
        sortChildren( focusedTree, focusedTreeGetSelection() )
        if focusedTree == UI.editTargetTree then
            setTreeFoldersFirst( focusedTree )
        end
        UI.editToolbar:EnableTool( UI.eTbChildPaste:GetId(), false )
        treeItemWasCut = false
        
        if invalidNames ~= #originIDs then --Mindestens 1 Item konnte eingefügt werden            
            originIDs = nil 
            tmpComps = nil
            tmpTreeStructure = nil 
            
            editHappened( true )
        end
        
        UI.editFrame:Enable( true )
        
        return 0
    end
    
    function createDefaultTargetStructure()
        --Erzeugt die standardisierte Struktur im Zielbaum. Bereits vorhandene Ordner und Dateien werden nicht überschrieben
        local structure = {
            ["Standard" .. getCaVerFromModule()] = {
                ["bin"] = {
                    ["assembly"] = {},
                    ["ug"] = {},
                },
                ["dialog"] = {},
                ["gui"] = {},
                ["misc"] = {},
                ["plotters"] = {
                    ["ac"] = {},
                    ["iv"] = {},
                },
                ["script"] = {
                    ["ac"] = {},
                    ["epl"] = {},
                    ["gen"] = {},
                    ["iv"] = {},
                    ["pa3d"] = {},
                    ["pe"] = {},
                    ["se"] = {},
                    ["so"] = {},
                    ["sw"] = {},
                    ["ug"] = {},
                },
                ["server"] = {
                    ["plmserver"] = {
                        ["plmserver-data"] = {},
                    },
                },
                ["Setup"] = {
                    ["ac"] = {},
                    ["creo"] = {},
                    ["epl"] = {},
                    ["iv"] = {},
                    ["OC"] = {},
                    ["pe"] = {},
                    ["se"] = {},
                    ["sw"] = {},
                    ["tools"] = {},
                    ["ug"] = {},
                },
                ["templates"] = {
                    ["ac"] = {},
                    ["iv"] = {},
                    ["pe"] = {},
                    ["se"] = {},
                    ["so"] = {},
                    ["sw"] = {},
                    ["ug"] = {},
                },
            },
        }
        
        itemWasAdded = false
        createModuleTree( UI.editTargetTree, structure, UI.editTargetTree:GetRootItem() )
        if itemWasAdded then 
            editHappened( true ) 
            UI.editTargetTree:Expand( UI.editTargetTree:GetRootItem() )
            setTreeFoldersFirst( UI.editTargetTree, UI.editTargetTree:GetRootItem() )
        end
    end
    
    function addSelectedComps( createSourceFolderInTarget )
        --Fügt die im Komponentenexplorer markierten Dateien dem im Zielbaum markierten Ordner hinzu.
        --Diese Funktion deckt sowohl die normale als auch die "magische" Zuordnung ab
        --Aufgerufen durch Knöpfe in Toolbar oder Shift+Y oder Strg+Shift+Y
        --
        --createSourceFolderInTarget:   Bestimmt automatisch den Zielordner unabhängig von der Selektion und erzeugt ihn, falls er nicht existiert.
        --                              Andernfalls wird die Datei dem ausgewählten Zielordner hinugefügt
        
        
        if not UI.editModuleTree:GetSelection():IsOk() then
            wx.wxMessageBox( "Es wurde kein Modul ausgewählt.", "Komponente zuordnen" )
            return -1
        end
        if not createSourceFolderInTarget then
            if #UI.editTargetTree:GetSelections() == 0 then
                wx.wxMessageBox( "In der Zielstruktur ist kein Ordner ausgewählt, dem die Komponente hingefügt werden soll!", "Komponente zuordnen" )
                return -1
            elseif #UI.editTargetTree:GetSelections() > 1 then
                wx.wxMessageBox( "In der Zielstruktur darf nur ein einziger Ordner ausgewählt sein.", "Komponente zuordnen" )
                return -1
            end
        end
        
        local selections = UI.editCompTree:GetSelections()
        if #selections > 0 then
        
            local function getLocalVariables( selection )
                local filePath = getPathName( UI.editCompTree, selection )
                local modulePath = getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() )
                local fileName
                for tmp in filePath:gmatch( "[^\\]+" ) do fileName = tmp end
                
                local targetPath          
                
                if createSourceFolderInTarget then
                    targetPath = "Root\\" .. ( filePath:sub( buildRoot:len() ):match( ".tandard%d-.+" ) or "Standard" .. getCaVerFromModule() )
                    if not UI.editCompTree:ItemHasChildren( item_id[filePath] ) then
                        targetPath = targetPath:sub( 1, -( fileName:len() +2 ) )
                    end
                else
                    targetPath = getPathName( UI.editTargetTree, UI.editTargetTree:GetSelections()[1] )
                end
                
                local subPath = ""
                for folder in targetPath:gmatch( "[^\\]+" ) do
                    subPath = subPath == "" and folder or subPath .. "\\" .. folder
                    local correctSubPath = alignFolderName( subPath )
                    if correctSubPath ~= -1 then
                        targetPath = targetPath:gsub( subPath, correctSubPath, 1 )
                    end
                end
                
                if compRel[modulePath] then
                    for _, file in pairs( compRel[modulePath] ) do
                        if file.target == targetPath then
                            --Zielpfad auf den Ordner lenken, in dem die im Zielbaum ausgewählte Datei liegt
                            targetPath = getPathName( UI.editTargetTree, UI.editTargetTree:GetItemParent( targetTreeId[targetPath] ) )
                            break
                        end
                    end
                end
                
                return filePath, modulePath, targetPath, fileName
            end
        
            ------- Ermitteln, welche Dateien überschrieben werden, und ob das gewünscht ist --------
            local doReplace = false
            local filesToReplace = {}
            
            local function checkElement( filePath, targetPath )
                local fileName; for tmp in filePath:gmatch( "[^\\]+" ) do fileName = tmp end
                
                -- Falls ein Zielordner mit abweichender Groß- / Kleinschreibung existiert, diesen anwählen
                for existingTargetPath, id in pairs( targetTreeId ) do
                    if existingTargetPath:lower() == targetPath:lower() and existingTargetPath ~= targetPath then
                        --print( "using Path:", existingTargetPath, "for", targetPath )
                        targetPath = existingTargetPath
                        break
                    end
                end
                
                if targetTreeId[targetPath .. "\\" .. fileName] then
                    for _, file in ipairs( compRel[getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() )] ) do
                        if file.target == targetPath .. "\\" .. fileName and buildRoot .. file.source ~= filePath then
                            -- Datei ersetzen ist nur kritisch, wenn es sich um eine andere Quell-Datei handelt
                            table.insert( filesToReplace, targetPath .. "\\" .. fileName )
                            break
                        end
                    end
                    
                end
            end   
            
            local function browseFolder( sourcePath, targetPath )
                local childId
                for i = 1, UI.editCompTree:GetChildrenCount( item_id[sourcePath], false ), 1 do
                    if i == 1 then childId = UI.editCompTree:GetFirstChild( item_id[sourcePath] )
                    else childId = UI.editCompTree:GetNextSibling( childId )
                    end
                    
                    local childPath = getPathName( UI.editCompTree, childId )
                    local fileName; for tmp in childPath:gmatch( "[^\\]+" ) do fileName = tmp end
                    
                    if UI.editCompTree:ItemHasChildren( childId ) then
                        browseFolder( childPath, targetPath .. "\\" .. fileName )
                    else
                        checkElement( childPath, targetPath )
                    end
                end
            end
            
            for _, selection in pairs( selections ) do
                local filePath, modulePath, targetPath, fileName = getLocalVariables( selection )
                
                if UI.editCompTree:ItemHasChildren( selection ) then
                    browseFolder( filePath, targetPath )
                else
                    checkElement( filePath, targetPath )
                end
            end
            
            table.sort( filesToReplace, function( a, b ) return a:upper() < b:upper() end )
            
            if #filesToReplace > 0 then
                local msg
                if #filesToReplace == 1 then
                    msg = "Eine Datei mit dem Namen " .. filesToReplace[1] .. " befindet sich bereits im Zielordner.\nMöchtest du sie ersetzen?"
                else
                    msg = #filesToReplace .. " Dateien mit identischen Namen aber unterschiedlicher Herkunft befinden sich bereits in den jeweiligen Zielordnern. Möchtest du sie ersetzen?"
                    if #filesToReplace < 30 then
                        msg = msg .. "\n"
                        for _, fileName in pairs( filesToReplace ) do
                            msg = msg .. "\n" .. fileName
                        end
                    end
                end
                
                local choice = wx.wxMessageDialog( UI.editFrame, msg, "Datei zuordnen", wx.wxYES_NO + wx.wxCANCEL + wx.wxNO_DEFAULT ):ShowModal()
                if choice == wx.wxID_YES then
                    doReplace = true
                elseif choice == wx.wxID_NO then
                    doReplace = false
                    if #filesToReplace == 1 then return 0 end
                else
                    return 0
                end
            end
            --------------------------------Ermittelung Ende-------------------------------------
            
            --------------Bei Option "createSourceFolderInTarget" Zielordner erstellen----------------
            if createSourceFolderInTarget then
                for _, selection in pairs( UI.editCompTree:GetSelections() ) do
                    local filePath, modulePath, targetPath, fileName = getLocalVariables( selection )
                    targetPath = targetPath:sub( UI.editTargetTree:GetItemText( UI.editTargetTree:GetRootItem() ):len() +2 )
                    local structure = {}
                    local parentTable = structure
                    
                    for folder in targetPath:gmatch( "[^\\]+" ) do
                        parentTable[folder] = {}
                        parentTable = parentTable[folder]
                    end
                    
                    createModuleTree( UI.editTargetTree, structure, UI.editTargetTree:GetRootItem() )
                end
            end
            ------------------------------Ordnererstellung Ende------------------------------------
            
            ----------------------------Die eigentliche Zuordnung----------------------------------
            for _, selection in pairs( selections ) do
                local filePath, modulePath, targetPath, fileName = getLocalVariables( selection )
                
                if UI.editCompTree:ItemHasChildren( item_id[filePath] ) then
                    insertComponentFolder( modulePath, filePath, targetPath, doReplace )
                else
                    insertComponent( modulePath, filePath, targetPath, doReplace )
                end
            end
            ---------------------------------Zuordnung Ende----------------------------------------
            
            UI.editTargetTree:Expand( UI.editTargetTree:GetRootItem() )
            setTreeFoldersFirst( UI.editTargetTree, UI.editTargetTree:GetRootItem() )
            
            local removedComps, parentsWithComps = removeDuplicateComponents()
            if removedComps ~= "" then
                wx.wxMessageBox( "Die Dateien\n" .. removedComps .. "\nsind bereits in\n" .. parentsWithComps, "Zuordnung nicht nötig" )
            end
            
            updateEditCompLbl()
            markIncompleteModules( UI.editModuleTree, false, true )
            editHappened( true )
            UI.editCompTree:SetFocus()
        else
            wx.wxMessageBox( "Keine Komponenten zum Hinzufügen ausgewählt.", "Komponenten zuordnen" )
        end
    end
    
    function updateMarkSelectedComps()
        --Markiert die im Komponentenexplorer markierten Komponenten als update- oder nicht-updatefähig, je nach ihrer Ausgangslage
        --Aufgerufen durch Knopf in Toolbar oder Strg+U
    
        local function markSingleElement( itemId )
            local filePath = getPathName( UI.editCompTree, itemId ):sub( buildRoot:len() +1 )
            if table.contains( noUpdateComps, filePath ) then
                UI.editCompTree:SetItemTextColour( itemId, wx.wxBLACK )
                for k, v in pairs( noUpdateComps ) do
                    if v == filePath then
                        table.remove( noUpdateComps, k )
                        break
                    end
                end
            else
                UI.editCompTree:SetItemTextColour( itemId, noUpdateCompColour )
                table.insert( noUpdateComps, filePath )
            end
        end
        
        local function markFolder( itemId )
            for child_id in childrenOf( UI.editCompTree, itemId ) do
                if UI.editCompTree:ItemHasChildren( child_id ) then
                    markFolder( child_id )
                else
                    markSingleElement( child_id )
                end
            end
        end
        
        local selections = UI.editCompTree:GetSelections()
        if #selections ~= 0 and selections ~= nil then
            for _, selection in pairs( selections ) do
                if UI.editCompTree:ItemHasChildren( selection ) then
                    markFolder( selection )
                else
                    markSingleElement( selection )
                end
            end
            editHappened( true )
            UI.editCompTree:UnselectAll() --Um die Änderungen sehen zu können
            UI.editCompTreePathLbl:SetLabel( "Komponentenexplorer" ) -- Da nun kein Element mehr ausgewählt ist, Label zurücksetzen
            UI.editCompTree:SetFocus()
        else
            wx.wxMessageBox( "Es wurden keine Komponenten ausgewählt. Bitte benutze " ..
                "den Komponentenexplorer zur Markierung.", "Hinweis" )
        end
    end
    
    function refreshEditFrame()
        --Aktialisiert das Bearbeitungsfenster. Dabei wird der Komponentenexplorer neu befüllt,
        --Komponenten werden auf Verwendung geprüft, Module werden neu markiert und der Zielbaum wird neu aufgebaut.
        --Aufgerufen durch Knopf in Toolbar
        
        prevItem_id = {}        
        for k, v in pairs( item_id ) do
            prevItem_id[k] = v
        end
        fillExplorerTree( UI.editCompTree )
        if fastMode then UI.loadingScreen:Show( false ) end
        markAllComponents( true )
        
        fillModuleTree( UI.editModuleTree, true )
        markIncompleteModules( UI.editModuleTree, false, true )

        missingFiles = {}
        for _, filePathTable in pairs( compRel ) do
            for _, filePath in pairs( filePathTable ) do
                if item_id[buildRoot .. filePath.source] == nil and not table.contains( missingFiles, filePath.source ) then
                    table.insert( missingFiles, filePath.source )
                end
            end
        end 
        
        showCompsForSelectedModule( UI.editModuleTree, UI.editTargetTree, false, UI.editModuleTree:GetSelection(), true )
        
        UI.editFrame:SetFocus()
    end
    
    function openManual( page )
        --Öffnet die Bedienungsanleitung. Diese Funktion wird vom Haupt- und vom Bearbeitungsfenster benutzt
        --Aufgerufen durch Knopf in Toolbar
        
        --page(optional): Die anzuzeigende Seite
        
        local manualPath = databaseRoot .. "Bedienungsanleitung.pdf"
        
        if not fileExists( adobePath ) then
            wx.wxMessageBox( "Der Adobe Acrobat Reader wird benötigt, um das Hilfe-Dokument zu öffnen.\n" ..
                "Bitte richte deinen Installationspfad im nachfolgenden Dialog ein.", "Adobe Acrobat Reader einrichten" )
                
            local adobePathPicker = wx.wxFileDialog( ( UI.mainFrame:IsShown() and UI.mainFrame or UI.editFrame ), "Installationspfad auswählen", adobePath, "", 
                "AcroRd32.exe|*AcroRd32.exe", wx.wxFD_DEFAULT_STYLE )
            if adobePathPicker:ShowModal() == wx.wxID_CANCEL then
                return -1
            end
            
            adobePath = adobePathPicker:GetPath()
            saveUserSettings()
        end
        
        if fileExists( manualPath ) then
            os.execute( "start \"\" \"" .. adobePath .. "\" /A page=" .. ( page or 1 ) .. " \"" .. manualPath .. "\"" )
        else
            wx.wxMessageBox( "Die Bedienungsanleitung fehlt!\n" .. manualPath, "Bedienungsanleitung fehlt!", wx.wxICON_ERROR )
        end
    end
    
    function abortTreeItemCutting()
        --Bricht das Ausschneiden eines Baumelements ab.
        --Aufgerufen durch ESC oder wenn das Verschieben eines Baumelements mit Drag&Drop nicht erfolgreich war.
        
        if focusedTree == UI.editModuleTree or focusedTree == UI.editTargetTree then
            for _, originId in pairs( originIDs ) do
                if focusedTree:GetItemTextColour( originId ):GetAsString( wx.wxC2S_HTML_SYNTAX ) == wx.wxLIGHT_GREY:GetAsString( wx.wxC2S_HTML_SYNTAX ) then
                    if preCutItemColour and preCutItemColour[getPathName( focusedTree, originId )] then
                       focusedTree:SetItemTextColour( originId,  preCutItemColour[getPathName( focusedTree, originId )] )
                    else
                        focusedTree:SetItemTextColour( originId, wx.wxBLACK )
                    end
                end
            end
            UI.editToolbar:EnableTool( UI.eTbChildPaste:GetId(), false )
        end
    end
    
    function enableTreeEditing( enable )
        --Aktiviert oder deaktiviert die Knöpfe in der Toolbar zum Bearbeiten einer Baumstruktur
        --Aufgerufen durch EVT_SET_FOCUS in den Baumstrukturen 
        
        UI.editToolbar:EnableTool( UI.eTbChildAdd:GetId(), enable )
        UI.editToolbar:EnableTool( UI.eTbChildDelete:GetId(), enable )
        UI.editToolbar:EnableTool( UI.eTbChildCopy:GetId(), enable )
        UI.editToolbar:EnableTool( UI.eTbChildCut:GetId(), enable)
        UI.editToolbar:EnableTool( UI.eTbChildPaste:GetId(), enable and ( tmpComps and true or false ) )
    end
    
    function treeLabelEditStart( event )
        --Kümmert sich um Variablen für das Ändern eines Namens
        --Wird aufgerufen, sobald die Textbox zum Editieren eines Baumelements erscheint
        if getPathName( focusedTree, event:GetItem() ) == getPathName( focusedTree, focusedTree:GetRootItem() ) then
            event:Veto()
        end
        
        prevElementName = focusedTree:GetItemText( focusedTreeGetSelection() )
        oldElementPath = getPathName( focusedTree, focusedTreeGetSelection() )
    end
    
    function treeLabelEditEnd( event )
        --Ändert die notwendigen Datensätze und IDs, wenn der Name eines Baumelements geändert wurde
        --Wird aufgerufen, wenn die Bearbeitung des Namens beendet und bestätigt wird
        local newElementName = event:GetLabel()
        local newElementPath = getPathName( focusedTree, focusedTreeGetSelection() ):sub( 1, -( prevElementName:len() +1 ) ) .. newElementName
        if prevElementName ~= "" and newElementName == "" then
        
            --Wenn keine Bearbeitung vorgenommen wurde wird das neue Label als leerer String übergeben
            doCorrectLabel = true
            elementIdToCorrect = event:GetItem()
            return
        end
        if validateName( focusedTree, focusedTree:GetItemParent( event:GetItem() ), newElementName, event:GetItem() ) then
            
            if focusedTree == UI.editTargetTree then
                local correctPath = alignFolderName( newElementPath )
                if correctPath ~= -1 then
                    for node in correctPath:gmatch( "[^\\]+" ) do newElementName = node end
                    newElementPath = correctPath
                end
            end
            
            local tableRef
            if focusedTree == UI.editModuleTree then
                tableRef = module_id
            elseif focusedTree == UI.editTargetTree then
                tableRef = targetTreeId
            end
            
            for tRName, tRId in sortedKeys( tableRef ) do
                if tRName:find( oldElementPath, 1, true ) == 1 and tRName ~= newElementPath .. tRName:sub( oldElementPath:len() +1 ) then
                    --print( "replacing: \"" .. tRName .. "\"", "with: \"" .. newElementPath .. tRName:sub( oldElementPath:len() +1 ) .. "\"" )
                    tableRef[newElementPath .. tRName:sub( oldElementPath:len() +1 )] = tRId
                    tableRef[tRName] = nil
                end
            end
            
            --Hierdurch kann der Name in der Revision gespeichert werden. Ansonsten wird die Methode erst implizit durch "event:Skip()" aufgerufen
            focusedTree:SetItemText( tableRef[newElementPath], newElementName )
            
            if focusedTree == UI.editModuleTree then
                --Module in Tabelle "compRel" anpassen, Schlüssel modifizieren
                --sortedKeys ist essentiell!! (Da der Iterator im Vergleich zu "pairs" nicht dynamisch aufgebaut wird, sondern im Voraus gesetzt ist)
                --mit "pairs" können bereits umbenannte Einträge erneut umbenannt werden, was zu ungültigen Modulnamen in den Daten führt
                for modulePath, filePathTable in sortedKeys( compRel ) do
                    local oldModPathStart, oldModPathEnd = modulePath:find( oldElementPath, 1, true )
                    if oldModPathStart == 1 then
                        --print( "replacing", modulePath, "with", newElementPath .. modulePath:sub( oldModPathEnd +1 ) )
                        compRel[newElementPath .. modulePath:sub( oldModPathEnd +1 )] = filePathTable
                        compRel[modulePath] = nil
                    end
                end
            elseif focusedTree == UI.editTargetTree and compRel[getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() )] then
                for _, file in sortedKeys( compRel[getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() )] ) do
                    local oldTargetStart, oldTargetEnd = file.target:find( oldElementPath, 1, true )
                    if oldTargetStart == 1 then
                        --print( "replacing", file.target, "with", newElementPath .. file.target:sub( oldTargetEnd +1 ) )
                        file.target = newElementPath .. file.target:sub( oldTargetEnd +1 )
                    end
                end
            end
            
            updateEditCompLbl()
            doSortChildren = true
            itemToSort = focusedTree:GetItemParent( event:GetItem() )
            
            -- Wenn sich das umbenannte Item in der Zwischenablage befindet, erneut kopieren / ausschneiden
            if originId then
                if getPathName( focusedTree, event:GetItem() ) == getPathName( focusedTree, originId ) then
                    if treeItemWasCut then
                        cutTreeItems()
                    else
                        copyItem()
                    end
                end
            end
            
            if focusedTree == UI.editTargetTree then setTreeFoldersFirst( focusedTree, focusedTree:GetItemParent( focusedTreeGetSelection() ) ) end
            editHappened( true )
        else
            doCorrectLabel = true
            elementIdToCorrect = event:GetItem()
        end
        
        -- Das Umbenennen eines Labels ist ziemlich fummelig. Daher wird die Selektion nochmal automatisch erneuert, denn das manuelle aktualisieren scheint Abhilfe zu schaffen
        --moduleTreeSelectionChanging( UI.editModuleTree, UI.editTargetTree, UI.editModuleTree:GetSelection() )
        --editModuleTreeSelectionChanged()
        
        event:Skip()
    end
    
    function treeBeginDrag( event )
        --Ein Baumelement wird begonnen zu verschieben
        if focusedTree == nil then
            wx.wxMessageBox( "Der zu bearbeitende Baum konnte nicht ermittelt werden. Versuche es noch einmal!", "Drag & Drop fehlgeschlagen", wx.wxICON_ERROR )
            return -1
        end
        
        focusedTree:SelectItem( event:GetItem() )
        if ctrlKeyIsPressed then
            copyTreeItems()
        else
            cutTreeItems()
        end
        event:Allow()
    end
    
    function treeEndDrag( event )
        --Ein Baumelement wurde verschoben
        focusedTree:UnselectAll()
        focusedTree:SelectItem( event:GetItem() )
        if pasteTreeItems() == -1 then
            abortTreeItemCutting()
        end
    end
    
    function treeLabelCorrection()
        --Korrigiert ein Label, falls bei Umbennung ungültig, da diese NACH Abschluss
        --von EVT_TREE_END_LABEL_EDIT aufgerufen wird wird. Das Event muss vollständig
        --durchlaufen wurden sein, bevor eine Änderung des Labels wirksam wird
        if doCorrectLabel then
            focusedTree:SetItemText( elementIdToCorrect, prevElementName )
            doCorrectLabel = false
        end
        
        if doSortChildren then
            sortChildren( focusedTree, itemToSort )
            doSortChildren = false
        end
    end
    
    function editModuleTreeSelectionChanged()
        --Die Selektion im Modulbaum hat sich geändert
        for _, moduleId in pairs( module_id ) do
            UI.editModuleTree:SetItemBold( moduleId, false )
        end
        UI.editModuleTree:SetItemBold( UI.editModuleTree:GetSelection() )
        targetStructure = targetStructure or {}
        showCompsForSelectedModule( UI.editModuleTree, UI.editTargetTree, false, UI.editModuleTree:GetSelection(), true )
        if UI.editTargetTree:GetItemText( UI.editTargetTree:GetFirstChild( UI.editTargetTree:GetRootItem() ) ):find( ".tandard%d+" ) == 1 then
            UI.editTargetTree:Expand( UI.editTargetTree:GetFirstChild( UI.editTargetTree:GetRootItem() ) )
        end
        
        local tmpTStrTbl = targetStructure[getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() )]
        if tmpTStrTbl then
            createModuleTree( UI.editTargetTree, tmpTStrTbl, UI.editTargetTree:GetRootItem() )
        end
        
        setTreeFoldersFirst( UI.editTargetTree, targetTreeId["Root"] )
        
        for thisName, thisId in pairs( targetTreeId ) do
            if expandedTargetTreeItems and expandedTargetTreeItems[getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() )]
            and table.contains( expandedTargetTreeItems[getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() )], thisName ) then
                UI.editTargetTree:Expand( thisId )
            end
        end
        
        UI.editCommentCtrl:ChangeValue( comments[getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() )] or "" )
        
        updateEditCompLbl()
    end
    
    function moduleTreeSelectionChanging( moduleTree, targetTree, selection )
        --Die Selektion im Modulbaum beginnt, sich zu ändern.
        --Speichert die ausgeklappten Zielordner des ausgewählten Moduls
        --Selection: ID des vorher ausgewählten Moduls
        
        expandedTargetTreeItems = expandedTargetTreeItems or {}
        
        if targetTreeId then
            local thisTTI = expandedTargetTreeItems[getPathName( moduleTree, selection )] or {}
            for thisName, thisId in pairs( targetTreeId ) do
                if targetTree:IsExpanded( thisId ) then
                    table.insert( thisTTI, thisName )
                end
            end
        end
    end
    
    function getCaVerFromModule()
        --Ermittelt, welcher 'Standard'-Ordner im Zielbaum vorhanden ist bzw. angelegt werden müsste
        pAVer = {
            ["5.2"] = 70,
            ["6.1"] = 80,
            ["6.2"] = 90,
            ["7.1"] = 100,
            ["7.2"] = 110,
        }
        local rootChildrenCount = UI.editTargetTree:GetChildrenCount( UI.editTargetTree:GetRootItem(), false )
        local firstChildText = UI.editTargetTree:GetItemText( UI.editTargetTree:GetFirstChild( UI.editTargetTree:GetRootItem() ) )
        
        if rootChildrenCount == 0 then
            return pAVer[getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() ):match( "[^\\]+", getPathName( UI.editModuleTree, UI.editModuleTree:GetRootItem() ):len() +2 )] or "XX"
        elseif rootChildrenCount == 1 and firstChildText:find( ".tandard" ) == 1 then
            local startIndex, endIndex = firstChildText:find( ".tandard" )
            return firstChildText:sub( endIndex +1 )
        else
            return "XX"
        end
    end
    
    function deleteSelectedTreeItems()
        --Löscht alle ausgewählten Baumelemente
        --Aufgerufen durch Knöpfe in Toolbar (Löschen und Zuordnung lösen), Strg+D oder entf
        
        if focusedTree == UI.editModuleTree then
            if deleteTreeItem( UI.editModuleTree, focusedTreeGetSelection() ) ~= -1 then
                editHappened( true )
            end
        elseif focusedTree == UI.editTargetTree then
            local itemWasDeleted = false
            for _, selection in pairs( UI.editTargetTree:GetSelections() ) do
                if deleteTreeItem( UI.editTargetTree, selection ) ~= -1 then
                    itemWasDeleted = true
                end
            end
            if itemWasDeleted then 
                if compRel[getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() )] == nil
                or #compRel[getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() )] == 0
                then
                    UI.editModuleTree:SetItemTextColour( UI.editModuleTree:GetSelection(), emptyModuleColour )
                end
                editHappened( true ) 
            end
        end
        
        updateEditCompLbl()
    end
    
    function saveComment()
        local module = getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() )
        
        if module == "" then
            return -1
        end
        
        
        local oldComment = comments[module]
        local newComment = UI.editCommentCtrl:GetValue()
        
        
        if not( oldComment == nil and newComment == "" ) and oldComment ~= newComment then
            if newComment == "" then
                comments[module] = nil
            else
                comments[module] = newComment
            end
            
            editHappened( true )
        end
    end
    
    function findSelectedCompUsage( comp )
        --Komponentenexplorer
        if #UI.editCompTree:GetSelections() == 1 and comp:IsOk() then
            if not UI.editCompTree:ItemHasChildren( comp ) then
                local modulesContainingFile = {}
                for module, filePathTable in pairs( compRel ) do
                    for _, file in ipairs( filePathTable ) do
                        if buildRoot .. file.source == getPathName( UI.editCompTree, comp ) then
                            table.insert( modulesContainingFile, module )
                            break
                        end
                    end
                end
                local moduleFileString = ""
                for _, m in pairs( modulesContainingFile ) do
                    moduleFileString = moduleFileString .. m .. "\n"
                end
                if #modulesContainingFile == 0 then
                    wx.wxMessageBox( "Die Datei \"" .. UI.editCompTree:GetItemText( comp ) .. 
                        "\" ist keinem Modul zugeordnet.", "Komponentenverwendung" )
                    UI.editCompTree:SetItemBackgroundColour( event:GetItem(), unusedCompColour )
                elseif #modulesContainingFile == 1 then
                    UI.editModuleTree:SelectItem( module_id[modulesContainingFile[1]] )
                    editModuleTreeSelectionChanged()
                    
                    for _, thisId in pairs( targetTreeId ) do
                        UI.editTargetTree:SetItemBackgroundColour( thisId, wx.wxWHITE )
                    end
                    
                    for _, file in ipairs( compRel[modulesContainingFile[1]] ) do
                        if buildRoot .. file.source == getPathName( UI.editCompTree, comp ) then
                            UI.editTargetTree:EnsureVisible( targetTreeId[file.target] )
                            UI.editTargetTree:SetItemBackgroundColour( targetTreeId[file.target], wx.wxGREEN )
                        end
                    end
                else
                    wx.wxMessageBox( "Die Datei \"" .. getPathName( UI.editCompTree, comp ) .. "\" findet Verwendung in:\n" .. moduleFileString , "Komponentenverwendung ermittelt" )
                    UI.editCompTree:SetItemBackgroundColour( comp, wx.wxWHITE )
                    
                    local moduleStart, moduleEnd = moduleFileString:find( getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() ), 1, true )
                    if moduleStart ~= nil then
                        local moduleToSelectIn = moduleFileString:sub( moduleStart, moduleEnd )
                        local fileSource = buildRoot .. getPathName( UI.editCompTree, comp )
                        
                        if compRel[moduleToSelectIn] then
                            for _, file in pairs( compRel[moduleToSelectIn] ) do
                                if file.source == fileSource then
                                    UI.editTargetTree:EnsureVisible( targetTreeId[file.target] )
                                    UI.editTargetTree:SetItemBackgroundColour( targetTreeId[file.target], wx.wxGREEN ) 
                                end
                            end
                        end
                    end
                    
                end
            end
        elseif #UI.editCompTree:GetSelections() > 1 then
            wx.wxMessageBox( "Beim Ermitteln der Verwendung darf nur eine einzige Datei ausgewählt sein.", "Komponentenverwendung ermitteln" )
        else
            wx.wxMessageBox( "Es konnte keine Selektion festgestellt werden", "Komponentenverwendung ermitteln" )
        end
    end
    
    function findSelectedCompSource()
        --Zielbaum
        if #(UI.editTargetTree:GetSelections() ) > 1 then
            wx.wxMessageBox( "Beim Ermitteln der Herkunft einer zugeordneten Komponente darf nur ein einzelnes Item ausgewählt sein.",
                "Zuordnung kann nicht ermittelt werden" )
            return -1
        end
    
        if UI.editTargetTree:ItemHasChildren( focusedTreeGetSelection() ) or compRel[getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() )] == nil then
            UI.editTargetTree:Expand( focusedTreeGetSelection )
            return -1
        end
        
        local file
        for i, thisFile in ipairs( compRel[getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() )] ) do
            if thisFile.target == getPathName( UI.editTargetTree, focusedTreeGetSelection() ) then
                file = thisFile
                break
            end
        end
        if not file then
            wx.wxMessageBox( "Der Datensatz dieser Datei konnte nicht ermittelt werden!\n\n" ..
                "Gesucht: \"" .. getPathName( UI.editTargetTree, focusedTreeGetSelection() ) .. "\"\n" ..
                "In: \"" .. getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() ) .. "\"", "Fehler Quell-Ermittlung", wx.wxICON_ERROR )
            return
        end
        
        local path = ""
        for node in file.source:gmatch( "[^\\]+" ) do
            path = path .. "\\" .. node
            if path:find( "\\" ) == 1 then path = path:sub( 2 ) end
            if item_id[buildRoot .. path] == nil then
                wx.wxMessageBox( "Quelle: " .. file.source, "Quelle konnte ermittelt, aber nicht markiert werden" )
                return
            end
        end
        
        UI.editCompTree:UnselectAll()
        UI.editCompTree:EnsureVisible( item_id[buildRoot .. file.source] )
        
        if prevBgColourItem then
            UI.editCompTree:SetItemBackgroundColour( prevBgColourItem, wx.wxWHITE )
        end
        
        prevBgColour = UI.editCompTree:GetItemBackgroundColour( item_id[buildRoot .. file.source] )
        prevBgColourItem = item_id[buildRoot .. file.source]
        
        UI.editCompTree:SetItemBackgroundColour( item_id[buildRoot .. file.source], wx.wxGREEN )
        updateEditCompTreePathLbl( item_id[buildRoot .. file.source] )
    end
    
    
    editFrameKeyListenObjects = {
        --Liste der Objekte im EditFrame, die einen Keylistener benötigen.
        --Frames können keine Key-Events auslösen, daher erhalten die relevanten Windows einen Keylistener
        UI.editFrame,
        UI.editCompTree,
        UI.editModuleTree,
        UI.editCommentCtrl,
        UI.editTargetTree,
        UI.editModulePanel,
        UI.editCompPanel,
    }
    
    for _, object in pairs( editFrameKeyListenObjects ) do --Sämtliche Keyboard-Events im Bearbeitungsfenster
        object:Connect( wx.wxEVT_KEY_DOWN, function(event)
            --print( "pressed",event:GetKeyCode() )
            
            if event:ControlDown() then
                -- Alle Fenster
                if event:GetKeyCode() == 83 then --Strg + S
                    editFrameSaveButtonPressed()
                elseif event:GetKeyCode() == 90 and UI.editToolbar:GetToolEnabled( UI.eTbUndo:GetId() ) then --Strg + Z
                    undoEdit()
                elseif event:GetKeyCode() == 89 and UI.editToolbar:GetToolEnabled( UI.eTbRedo:GetId() ) then --Strg + Y
                    redoEdit()
                elseif event:GetKeyCode() == 87 then --Strg + W
                    closeEditFrame()
                end
            end
            
             if event:ShiftDown() then
                if event:GetKeyCode() == 89 then --Strg + Y
                    addSelectedComps( event:ControlDown() )
                end
            end
                
            -- Modulbaum & Zielbaum
            if UI.editFrame:FindFocus():GetId() == UI.editModuleTree:GetId() 
            or UI.editFrame:FindFocus():GetId() == UI.editTargetTree:GetId() then
                if event:ControlDown() then
                    if event:GetKeyCode() == 78 then --Strg + N
                        createNewTreeItem( focusedTree, focusedTreeGetSelection() )
                    elseif event:GetKeyCode() == 68 then --Strg + D
                        deleteSelectedTreeItems()
                    elseif event:GetKeyCode() == 67 then --Strg + C
                        copyTreeItems()
                    elseif event:GetKeyCode() == 88 then --Strg + X
                        cutTreeItems()
                    elseif event:GetKeyCode() == 86 and UI.editToolbar:GetToolEnabled( UI.eTbChildPaste:GetId() ) then --Strg + V
                        pasteTreeItems()
                    end
                else
                    if event:GetKeyCode() == 127 then --entf
                        deleteSelectedTreeItems()
                    elseif event:GetKeyCode() == 27 then --esc
                        abortTreeItemCutting()
                    end
                end
            --Komponentenexplorer
            elseif UI.editFrame:FindFocus():GetId() == UI.editCompTree:GetId() then
                if event:ControlDown() then
                    if event:GetKeyCode() == 85 then --Strg + U
                        updateMarkSelectedComps()
                    end
                end
            end
            ctrlKeyIsPressed = event:ControlDown()
            event:Skip()
        end )
        
        object:Connect( wx.wxEVT_KEY_UP, function(event)
            ctrlKeyIsPressed = event:ControlDown()
            event:Skip()
        end )
    end
    
    --Kontextmenüs Bearbeitungsfenster
    do --editModuleTree
        UI.editModuleTree:Connect( wx.wxEVT_COMMAND_TREE_ITEM_RIGHT_CLICK, function(event)
        --implements editModuleTreeRClicked
            UI.editModuleTree:SelectItem( event:GetItem() )
            event:Skip()
        end )
        
        local optionAdd
        local optionDelete
        local optionCopy
        local optionCut
        local optionPaste
        local optionRename
        local optionHelp
        
        --Kontextmenü definieren
        UI.editModuleTree:Connect( wx.wxEVT_CONTEXT_MENU, function(event)
            local contextMenu = wx.wxMenu()
            
            optionAdd =     contextMenu:Append( 0, "Neues Modul anhängen" )
            optionDelete =  contextMenu:Append( 1, "Löschen" )
            optionCopy =    contextMenu:Append( 2, "Kopieren" )
            optionCut =     contextMenu:Append( 3, "Ausschneiden" )
            optionPaste =   contextMenu:Append( 4, "Einfügen" )
            optionRename =  contextMenu:Append( 5, "Umbenennen" )
            contextMenu:AppendSeparator()
            optionHelp =    contextMenu:Append( 6, "Hilfe" )
            
            optionPaste:Enable( UI.editToolbar:GetToolEnabled( UI.eTbChildPaste:GetId() ) )
            
            UI.editModuleTree:PopupMenu( contextMenu )            
        end )
        
        --Eventhandling Kontextmenü
        UI.editModuleTree:Connect( wx.wxEVT_COMMAND_MENU_SELECTED, function(event)
            if event:GetId() == optionAdd:GetId() then
                createNewTreeItem( UI.editModuleTree, UI.editModuleTree:GetSelection() )
            elseif event:GetId() == optionDelete:GetId() then
                deleteSelectedTreeItems()
            elseif event:GetId() == optionCopy:GetId() then
                copyTreeItems()
            elseif event:GetId() == optionCut:GetId() then
                cutTreeItems()
            elseif event:GetId() == optionPaste:GetId() then
                pasteTreeItems()
            elseif event:GetId() == optionRename:GetId() then
                UI.editModuleTree:EditLabel( UI.editModuleTree:GetSelection() )
            elseif event:GetId() == optionHelp:GetId() then
                openManual( 13 )
            end
        end )
    end
    
    do --editCompTree
        UI.editCompTree:Connect( wx.wxEVT_COMMAND_TREE_ITEM_RIGHT_CLICK, function(event)
        --implements editCompTreeRClicked
            UI.editCompTree:SelectItem( event:GetItem() )
            event:Skip()
        end )
        
        local optionAssignAuto
        local optionAssign
        local optionMarkUpdate
        local optionFindUsage
        local optionHelp
        
        --Kontextmenü definieren
        UI.editCompTree:Connect( wx.wxEVT_CONTEXT_MENU, function(event)
            local contextMenu = wx.wxMenu()
            
            optionAssignAuto =  contextMenu:Append( 0, "Zuordnen, Ziel automatisch bestimmen" )
            optionAssign =      contextMenu:Append( 1, "Dem markierten Zielordner zuordnen" )
            optionMarkUpdate =  contextMenu:Append( 2, "Markierung umschalten: Updatefähig / Nicht-updatefähig" )
            contextMenu:AppendSeparator()
            optionFindUsage =   contextMenu:Append( 3, "Verwendung anzeigen" )
            contextMenu:AppendSeparator()
            optionHelp =        contextMenu:Append( 4, "Hilfe" )
            
            UI.editCompTree:PopupMenu( contextMenu )            
        end )
        
        --Eventhandling Kontextmenü
        UI.editCompTree:Connect( wx.wxEVT_COMMAND_MENU_SELECTED, function(event)
            if event:GetId() == optionAssignAuto:GetId() then
                addSelectedComps( true )
            elseif event:GetId() == optionAssign:GetId() then
                addSelectedComps( false )
            elseif event:GetId() == optionMarkUpdate:GetId() then
                updateMarkSelectedComps()
            elseif event:GetId() == optionFindUsage:GetId() then
                findSelectedCompUsage( UI.editCompTree:GetSelections()[1] )
            elseif event:GetId() == optionHelp:GetId() then
                openManual( 13 )
            end
        end )
    end
    
    do --editTargetTree
        UI.editTargetTree:Connect( wx.wxEVT_COMMAND_TREE_ITEM_RIGHT_CLICK, function(event)
        --implements editModuleTreeRClicked
            UI.editTargetTree:SelectItem( event:GetItem() )
            focusedTree = UI.editTargetTree
            event:Skip()
        end )
        
        local optionAdd
        local optionDelete
        local optionCopy
        local optionCut
        local optionPaste
        local optionRename
        
        local optionUnassign
        local optionShowSource
        local optionHelp
        
        --Kontextmenü definieren
        UI.editTargetTree:Connect( wx.wxEVT_CONTEXT_MENU, function(event)
            local contextMenu = wx.wxMenu()
            
            optionAdd =     contextMenu:Append( 0, "Ordner anhängen" )
            optionDelete =  contextMenu:Append( 1, "Löschen" )
            optionCopy =    contextMenu:Append( 2, "Kopieren" )
            optionCut =     contextMenu:Append( 3, "Ausschneiden" )
            optionPaste =   contextMenu:Append( 4, "Einfügen" )
            optionRename =  contextMenu:Append( 5, "Umbenennen" )
            contextMenu:AppendSeparator()
            optionUnassign =    contextMenu:Append( 6, "Zuordnung lösen" )
            optionShowSource =  contextMenu:Append( 7, "Herkunft anzeigen" )
            contextMenu:AppendSeparator()
            optionHelp =        contextMenu:Append( 8, "Hilfe" )
            
            optionPaste:Enable( UI.editToolbar:GetToolEnabled( UI.eTbChildPaste:GetId() ) )           
            
            UI.editTargetTree:PopupMenu( contextMenu )            
        end )
        
        --Eventhandling Kontextmenü
        UI.editTargetTree:Connect( wx.wxEVT_COMMAND_MENU_SELECTED, function(event)
            if event:GetId() == optionAdd:GetId() then
                createNewTreeItem( UI.editTargetTree, focusedTreeGetSelection() )
            elseif event:GetId() == optionDelete:GetId() then
                deleteSelectedTreeItems()
            elseif event:GetId() == optionCopy:GetId() then
                copyTreeItems()
            elseif event:GetId() == optionCut:GetId() then
                cutTreeItems()
            elseif event:GetId() == optionPaste:GetId() then
                pasteTreeItems()
            elseif event:GetId() == optionRename:GetId() then
                UI.editTargetTree:EditLabel( focusedTreeGetSelection() )
            elseif event:GetId() == optionUnassign:GetId() then
                deleteSelectedTreeItems()
            elseif event:GetId() == optionShowSource:GetId() then
                findSelectedCompSource()
            elseif event:GetId() == optionHelp:GetId() then
                openManual( 14 )
            end
        end )
    end
    

	UI.editFrame:Connect( wx.wxEVT_CLOSE_WINDOW, function(event)
	--implements editFrameClosed
        if closeEditFrame( true ) == 0 then os.exit() end
    end )
    
    UI.editToolbar:Connect( UI.eTbLeaveEditFrame:GetId(), wx.wxEVT_COMMAND_TOOL_CLICKED, function(event)
	--implements eTbLeaveEditFramePressed
        closeEditFrame()
	end )
    
    UI.editToolbar:Connect( UI.eTbSave:GetId(), wx.wxEVT_COMMAND_TOOL_CLICKED, function(event)
	--implements eTbSavePressed
        editFrameSaveButtonPressed()
	end )
	
	UI.editToolbar:Connect( UI.eTbUndo:GetId(), wx.wxEVT_COMMAND_TOOL_CLICKED, function(event)
	--implements eTbUndoPressed
        undoEdit()
	end )
	
	UI.editToolbar:Connect( UI.eTbRedo:GetId(), wx.wxEVT_COMMAND_TOOL_CLICKED, function(event)
	--implements eTbRedoPressed
        redoEdit()
    end )
    
    UI.editToolbar:Connect( UI.eTbChildAdd:GetId(), wx.wxEVT_COMMAND_TOOL_CLICKED, function(event)
	--implements eTbChildAddPressed
        createNewTreeItem( focusedTree, focusedTreeGetSelection() )
	end )
	
	UI.editToolbar:Connect( UI.eTbChildDelete:GetId(), wx.wxEVT_COMMAND_TOOL_CLICKED, function(event)
	--implements eTbChildDeletePressed
        deleteSelectedTreeItems()
	end )
	
	UI.editToolbar:Connect( UI.eTbChildCopy:GetId(), wx.wxEVT_COMMAND_TOOL_CLICKED, function(event)
	--implements eTbChildCopyPressed
        copyTreeItems()
	end )
	
	UI.editToolbar:Connect( UI.eTbChildCut:GetId(), wx.wxEVT_COMMAND_TOOL_CLICKED, function(event)
	--implements eTbChildCutPaste
        cutTreeItems()
	end )
	
	UI.editToolbar:Connect( UI.eTbChildPaste:GetId(), wx.wxEVT_COMMAND_TOOL_CLICKED, function(event)
	--implements eTbChildPastePressed
        pasteTreeItems()
	end )    

    UI.editToolbar:Connect( UI.eTbTreeDefaultStructure:GetId(), wx.wxEVT_COMMAND_TOOL_CLICKED, function(event)
	--implements etbDefaultStructurePressed
        createDefaultTargetStructure()
	end )
	
	UI.editToolbar:Connect( UI.eTbCompAssign:GetId(), wx.wxEVT_COMMAND_TOOL_CLICKED, function(event)
	--implements eTbCompAssignPressed
        addSelectedComps( false )
	end )
	
    UI.editToolbar:Connect( UI.eTbCompAssignStructure:GetId(), wx.wxEVT_COMMAND_TOOL_CLICKED, function(event)
	--implements eTbCompAssignPressed
        addSelectedComps( true )
	end )
	
	UI.editToolbar:Connect( UI.eTbCompUnassign:GetId(), wx.wxEVT_COMMAND_TOOL_CLICKED, function(event)
	--implements eTbCompUnassignPressed
        local prevFocusedTree = focusedTree
        focusedTree = UI.editTargetTree
        deleteSelectedTreeItems()
        if prevFocusedTree then prevFocusedTree:SetFocus( true ) end
	end )
	
	UI.editToolbar:Connect( UI.eTbCompNoUpdate:GetId(), wx.wxEVT_COMMAND_TOOL_CLICKED, function(event)
	--implements eTbCompNoUpdatePressed
        updateMarkSelectedComps()
	end )
	
	UI.editToolbar:Connect( UI.eTbCompRefresh:GetId(), wx.wxEVT_COMMAND_TOOL_CLICKED, function(event)
	--implements eTbRefreshPressed
        refreshEditFrame()
	end )
	
	UI.editToolbar:Connect( UI.eTbOpenManual:GetId(), wx.wxEVT_COMMAND_TOOL_CLICKED, function(event)
	--implements eTbOpenManualPressed
        openManual()
	end )
	
    UI.editTargetTree:Connect( wx.wxEVT_COMMAND_TREE_ITEM_ACTIVATED, function(event)
	--implements editTargetTreeDoubleClicked
        findSelectedCompSource()
	end )
    
    UI.editTargetTree:Connect( wx.wxEVT_COMMAND_TREE_SEL_CHANGED, function(event)
	--implements editTargetTreeSelectionChanged
        for _, tTId in pairs( targetTreeId ) do
            UI.editTargetTree:SetItemBold( tTId, false )
        end
        UI.editTargetTree:SetItemBold( event:GetItem(), true )
        UI.editTargetTree:SelectItem( event:GetItem() ) -- Wenn man mit der Tastatur navigiert wird das Item nur halb selektiert
        event:Skip()
	end )
    
    UI.editTargetTree:Connect( wx.wxEVT_MOTION, function(event)
	--implements mouseMovedInEditTargetTree
        treeLabelCorrection()
        event:Skip()
    end )
    
    UI.editTargetTree:Connect( wx.wxEVT_COMMAND_TREE_BEGIN_LABEL_EDIT, function(event)
	--implements editLblStarted
        treeLabelEditStart( event )
	end )
    
	
	UI.editTargetTree:Connect( wx.wxEVT_COMMAND_TREE_END_LABEL_EDIT, function(event)
	--implements editLblEnded
        treeLabelEditEnd( event )
        event:Skip()
	end )
    
    UI.editTargetTree:Connect( wx.wxEVT_COMMAND_TREE_BEGIN_DRAG, function(event)
	--implements editTargetTreeBeginDrag
        UI.editTargetTree:SetFocus()
        focusedTree = UI.editTargetTree
        treeBeginDrag( event )
	end )
    
    UI.editTargetTree:Connect( wx.wxEVT_COMMAND_TREE_END_DRAG, function(event)
	--implements editTargetTreeEndDrag
        treeEndDrag( event )
	end )
    
    UI.editTargetTree:Connect( wx.wxEVT_DROP_FILES, function(event)
    --implements filesDroppedOnEditTargetTree
        local invalidFiles = {}
        local function getCorrectFilePath( filePath )
            --gsub unterstützt den "plain"-Parameter nicht. Deshalb workaround mit string.find
            local gsubIsStupid1, gsubIsStupid2 = filePath:find( "d$\\", 1, true )
            if gsubIsStupid1 ~= nil then
                filePath = filePath:sub( 1, gsubIsStupid1 -1 ) .. filePath:sub( gsubIsStupid2 +1 )
            end
            return filePath
        end
        for _, file in pairs( event:GetFiles() ) do
            file = getCorrectFilePath( file )
            if file:find( buildRoot, 1, true ) ~= 1 then
                table.insert( invalidFiles, file )
            end
        end
        
        if #invalidFiles > 0 then
            local invalidFilesString = ""
            table.sort( invalidFiles )
            for _, invalidFile in ipairs( invalidFiles ) do
                invalidFilesString = invalidFilesString .. "\n" .. invalidFile
            end
            wx.wxMessageBox( "Die folgenden Dateien sind ungültiger Herkunft. Stelle sicher, dass sie von \"" .. 
                buildRoot .. "\" stammen!\n" .. invalidFilesString, "Ungültige Dateien", wx.wxICON_WARNING )
        end
        
        local previousCompSelections = {}
        for _, compId in pairs( UI.editCompTree:GetSelections() ) do
            table.insert( previousCompSelections, getPathName( UI.editCompTree, compId ) )
            print( "prev Selected:", getPathName( UI.editCompTree, compId ) )
        end
        
        UI.editCompTree:UnselectAll()
        
        for _, file in pairs( event:GetFiles() ) do
            file = getCorrectFilePath( file )
            if not table.contains( invalidFiles, file ) and item_id[file] then
                UI.editCompTree:SelectItem( item_id[file] )
            end
        end
        
        addSelectedComps( true )
        UI.editCompTree:UnselectAll()
        
        for _, prevSelected in pairs( previousCompSelections ) do
            UI.editCompTree:SelectItem( item_id[prevSelected] )
        end
    end )
    
    UI.editMainSplitter:Connect( wx.wxEVT_COMMAND_SPLITTER_DOUBLECLICKED, function(event)
	--implements editFrameSash1DClicked
        UI.editMainSplitter:SetSashPosition( editFrameSash1PosDefault )
	end )
    
    UI.editCompMainSplitter:Connect( wx.wxEVT_COMMAND_SPLITTER_DOUBLECLICKED, function(event)
	--implements editFrameSash2DClicked
        UI.editCompMainSplitter:SetSashPosition( editFrameSash2PosDefault )
	end )
    
    UI.editCompTree:Connect( wx.wxEVT_COMMAND_TREE_SEL_CHANGED, function(event)
	--implements editCompTreeSelectionChanged
        local selections = UI.editCompTree:GetSelections()
        
        for item in childrenOf( UI.editCompTree, UI.editCompTree:GetRootItem() ) do
            UI.editCompTree:SetItemBold( item, false )
        end
        for _, selection in pairs( selections ) do
            UI.editCompTree:SetItemBold( selection, true )
        end
        
        updateEditCompTreePathLbl(selections[1])
        event:Skip()
	end )
    
    UI.editCompTree:Connect( wx.wxEVT_COMMAND_TREE_ITEM_ACTIVATED, function(event)
	--implements editCompTreeDoubleClicked
        findSelectedCompUsage( event:GetItem() )
        event:Skip()
	end )    
    
    UI.editCompTree:Connect( wx.wxEVT_COMMAND_TREE_ITEM_EXPANDED, function(event)
	--implements componentExpanded
        markParent( event:GetItem() )
        event:Skip()
	end )
    
    UI.editModuleTree:Connect( wx.wxEVT_MOTION, function(event)
	--implements mouseMovedInEditModuleTree
        treeLabelCorrection()
        event:Skip()
    end )
    
    UI.editModuleTree:Connect( wx.wxEVT_COMMAND_TREE_BEGIN_LABEL_EDIT, function(event)
	--implements editLblStarted
        treeLabelEditStart( event )
	end )
    
	
	UI.editModuleTree:Connect( wx.wxEVT_COMMAND_TREE_END_LABEL_EDIT, function(event)
	--implements editLblEnded
        treeLabelEditEnd( event )
        event:Skip()
	end )
    
    UI.editModuleTree:Connect( wx.wxEVT_COMMAND_TREE_BEGIN_DRAG, function(event)
	--implements editModuleTreeBeginDrag
        UI.editModuleTree:SetFocus()
        focusedTree = UI.editModuleTree
        treeBeginDrag( event )
	end )
    
    UI.editModuleTree:Connect( wx.wxEVT_COMMAND_TREE_END_DRAG, function(event)
	--implements editModuleTreeEndDrag
        treeEndDrag( event )
	end )
    
    UI.editModuleTree:Connect( wx.wxEVT_COMMAND_TREE_SEL_CHANGING, function(event)
    --implements editModuleTreeSelectionChanging
    
        expandedTargetTreeItems = expandedTargetTreeItems or {}
        expandedTargetTreeItems[getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() )] = {}
        
        moduleTreeSelectionChanging( UI.editModuleTree, UI.editTargetTree, UI.editModuleTree:GetSelection() )
        
        saveComment()        
        event:Skip()
    end )
	
    UI.editModuleTree:Connect( wx.wxEVT_COMMAND_TREE_SEL_CHANGED, function(event)
	--implements editModuleTreeSelectionChanged
        editModuleTreeSelectionChanged()
    end )
    
    UI.editCommentCtrl:Connect( wx.wxEVT_COMMAND_TEXT_UPDATED, function(event)
	--implements textUpdated
        editHappened( true, true )
        event:Skip()
	end )    
    
    UI.editTargetTree:Connect( wx.wxEVT_SET_FOCUS, function(event)
	--implements editTargetTreeGotFocus
        for _, id in pairs( targetTreeId ) do
            UI.editTargetTree:SetItemBackgroundColour( id, wx.wxWHITE )
        end
        
        focusedTree = UI.editTargetTree
        enableTreeEditing( true )
        updateEditCompLbl()
        
        treeLabelCorrection()
        
        event:Skip()
	end )
	
	UI.editModuleTree:Connect( wx.wxEVT_SET_FOCUS, function(event)
	--implements editModuleTreeGotFocus
        focusedTree = UI.editModuleTree
        enableTreeEditing( true )
        
        if targetTreeId then
            for _, thisId in pairs( targetTreeId ) do
                UI.editTargetTree:SetItemBackgroundColour( thisId, wx.wxWHITE )
            end
        end
        
        treeLabelCorrection()
        
        event:Skip()
	end )
    
    UI.editCompTree:Connect( wx.wxEVT_SET_FOCUS, function(event)
    --implements editCompTreeGotFocus
        if prevBgColourItem then
            UI.editCompTree:SetItemBackgroundColour( prevBgColourItem, wx.wxWHITE )
        end
        
        focusedTree = nil
        enableTreeEditing( false )
        event:Skip()
    end )
    
    UI.editCommentCtrl:Connect( wx.wxEVT_KILL_FOCUS, function(event)
	--implements editCommentCtrlKillFocus
        saveComment()
        event:Skip()
	end )

-- create editNameFrame
    UI.editNameFrame = wx.wxFrame (UI.editFrame, wx.wxID_ANY, "Modulbezeichnung eingeben", wx.wxDefaultPosition, wx.wxSize( 500,130 ), wx.wxDEFAULT_FRAME_STYLE+wx.wxTAB_TRAVERSAL+wx.wxFRAME_FLOAT_ON_PARENT )
	UI.editNameFrame:SetSizeHints( wx.wxDefaultSize, wx.wxDefaultSize )
    UI.editNameFrame:SetIcon( programIcon )
    UI.editNameFrame:SetBackgroundColour( wx.wxWHITE )
	
	UI.editNameBox = wx.wxBoxSizer( wx.wxVERTICAL )
	
	UI.editNameLbl = wx.wxStaticText( UI.editNameFrame, wx.wxID_ANY, "", wx.wxDefaultPosition, wx.wxDefaultSize, 0 )
	UI.editNameLbl:Wrap( -1 )
	UI.editNameBox:Add( UI.editNameLbl, 0, wx.wxALL, 5 )
	
	UI.editNameTxtctrl = wx.wxTextCtrl( UI.editNameFrame, wx.wxID_ANY, "", wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxTE_PROCESS_ENTER )
	UI.editNameBox:Add( UI.editNameTxtctrl, 0, wx.wxALL + wx.wxEXPAND, 5 )
	
	UI.editNameBtnGrid = wx.wxGridSizer( 0, 2, 0, 0 )
	
	UI.editNameConfirmBtn = wx.wxButton( UI.editNameFrame, wx.wxID_ANY, "Speichern", wx.wxDefaultPosition, wx.wxDefaultSize, 0 )
	UI.editNameBtnGrid:Add( UI.editNameConfirmBtn, 0, wx.wxALL + wx.wxALIGN_CENTER_HORIZONTAL, 5 )
	
	UI.editNameCancelBtn = wx.wxButton( UI.editNameFrame, wx.wxID_ANY, "Abbrechen", wx.wxDefaultPosition, wx.wxDefaultSize, 0 )
	UI.editNameBtnGrid:Add( UI.editNameCancelBtn, 0, wx.wxALL + wx.wxALIGN_CENTER_HORIZONTAL, 5 )
	
	
	UI.editNameBox:Add( UI.editNameBtnGrid, 1, wx.wxEXPAND, 5 )
	
	
	UI.editNameFrame:SetSizer( UI.editNameBox )
	UI.editNameFrame:Layout()
	
	UI.editNameFrame:Centre( wx.wxBOTH )
	
	-- Connect Events
    
    function addNewModule( parentId, moduleName )    
        -- Fügt ein Element einer Baumstruktur hinzu. Die ID wird der Tabelle des dazugehörigen Baums hinzugefügt
        -- Die Funktion liegt hier, da sie von der Maske aufgerufen wird, in der man den Namen des neuen Elements eintragen kann
        --
        -- parentId:    wxTreeItemId   Das Element, dem das neue Modul angehängt wird
        -- moduleName:  string         Die Bezeichnung des neuen Elements
        
        
        if not validateName( focusedTree, parentId, moduleName ) then
            return
        end
        
        if focusedTree == UI.editTargetTree then
            local correctPath = alignFolderName( getPathName( focusedTree, parentId ) .. "\\" .. moduleName )
            if correctPath ~= -1 then
                moduleName = correctPath:gsub( getPathName( focusedTree, parentId ) .. "\\", "" )
            end
        end
        
        local tableRef
        if focusedTree == UI.editModuleTree then
            tableRef = module_id
        elseif focusedTree == UI.editTargetTree then
            tableRef = targetTreeId
        else
            wx.wxMessageBox( "Name konnte nicht hinzugefügt werden, da keine Baumstruktur ausgewählt ist!", "Fehler beim Einfügen eines Elements.", wx.wxICON_ERROR )
        end
        
        --Diese Anweisung tut folgendes:
        --id_table[neuer Knoten] = Append(Pfad des ausgewählen Knotens, Name neuer Knoten)
        
        tableRef[ getPathName( focusedTree, parentId ) .. "\\" .. moduleName ] = focusedTree:AppendItem( tableRef[getPathName( focusedTree, parentId )], moduleName )
            
        focusedTree:Expand( parentId )
        sortChildren( focusedTree, parentId )
        if focusedTree == UI.editTargetTree then setTreeFoldersFirst( focusedTree, parentId ) end
        
        focusedTree:UnselectAll()
        focusedTree:SelectItem( tableRef[getPathName( focusedTree, parentId ) .. "\\" .. moduleName] )
        if focusedTree == UI.editModuleTree then 
            focusedTree:SetItemTextColour( tableRef[getPathName( focusedTree, parentId ) .. "\\" .. moduleName], emptyModuleColour )
        end
        
        UI.editNameFrame:Show( false )
        UI.editFrame:Enable( true )
        UI.editFrame:SetFocus()
        focusedTree:SetFocus()
        editHappened( true )
    end
	
	UI.editNameFrame:Connect( wx.wxEVT_CLOSE_WINDOW, function(event)
	--implements editNameClosed
        UI.editNameFrame:Show( false )
        UI.editFrame:Enable( true )
        UI.editFrame:SetFocus()
	end )
    
    UI.editNameTxtctrl:Connect( wx.wxEVT_COMMAND_TEXT_ENTER, function(event)
	--implements enterPressed
        addNewModule( focusedTreeGetSelection(), UI.editNameTxtctrl:GetValue() )
	end )
    
	UI.editNameConfirmBtn:Connect( wx.wxEVT_COMMAND_BUTTON_CLICKED, function(event)
	--implements editNameConfirmBtnPressed
        addNewModule( focusedTreeGetSelection(), UI.editNameTxtctrl:GetValue() )
	end )
	
	UI.editNameCancelBtn:Connect( wx.wxEVT_COMMAND_BUTTON_CLICKED, function(event)
	--implements editNameCancelBtnPressed
        UI.editNameFrame:Show( false )
        UI.editFrame:Enable( true )
        UI.editFrame:SetFocus()
	end )
	
-- create loadingScreen
    UI.loadingScreen = wx.wxDialog (wx.NULL, wx.wxID_ANY, "", wx.wxDefaultPosition, wx.wxSize( 463,120 ), wx.wxDEFAULT_DIALOG_STYLE )
	UI.loadingScreen:SetSizeHints( wx.wxDefaultSize, wx.wxDefaultSize )
    UI.loadingScreen:SetIcon( programIcon )
	
	UI.loadingDlgBox = wx.wxBoxSizer( wx.wxVERTICAL )
	
	UI.loadingDlgLbl = wx.wxStaticText( UI.loadingScreen, wx.wxID_ANY, "Das Programm wird geladen. Bitte warten...", wx.wxDefaultPosition, wx.wxDefaultSize, 0 )
	UI.loadingDlgBox:Add( UI.loadingDlgLbl, 0, wx.wxALL + wx.wxEXPAND + wx.wxALIGN_CENTER_HORIZONTAL, 5 )
	
	UI.loadingDlgGauge = wx.wxGauge( UI.loadingScreen, wx.wxID_ANY, 100, wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxGA_SMOOTH )
	UI.loadingDlgGauge:SetValue( 0 )
    UI.loadingDlgGauge:SetMaxSize( wx.wxSize( -1,10 ) )
	UI.loadingDlgBox:Add( UI.loadingDlgGauge, 0, wx.wxALL + wx.wxEXPAND, 5 )
	
    UI.loadingDlgAdditionalInfo = wx.wxStaticText( UI.loadingScreen, wx.wxID_ANY, "", wx.wxDefaultPosition, wx.wxDefaultSize, 0 )
	UI.loadingDlgBox:Add( UI.loadingDlgAdditionalInfo, 0, wx.wxALL + wx.wxEXPAND, 5 )
	
	UI.loadingScreen:SetSizer( UI.loadingDlgBox )
	UI.loadingScreen:Layout()
	
	UI.loadingScreen:Centre( wx.wxBOTH )
    
    -- Connect Events
    
    UI.loadingScreen:Connect( wx.wxEVT_CLOSE_WINDOW, function(event) 
    --implements loadingScreenClosed
        loadingCanceled = true
        event:Skip()
    end )
    
    UI.loadingScreen:Connect( wx.wxEVT_MOVE, function(event)
        --implements loadingScreenMoved
        UI.loadingDlgAdditionalInfo:SetLabel( "Während du dieses Fenster verschiebst, pausiert der Ladevorgang :D" )
    end )
    
    --Globale Funktionen
function main()
    -- Methode, die bei Aufruf des Programms ausgeführt wird
    
    fastMode = false --Nur zu Testzwecken. Führt länger andauernde Methoden einfach nicht aus
    
    -- Titel um "(Server)" oder "(Lokal)" ergänzen
    local frames = {
        UI.mainFrame,
        UI.editFrame,
        UI.loadingScreen,
    }
    for _, frame in pairs( frames ) do
        frame:SetTitle( "CA-Link Auslieferungsassistent (" .. ( databaseRoot:find( "\\\\ham-vscalink01", 1, true ) == 1 and "Server" or "Lokal" )  .. ")" )
    end
    UI.editFrame:SetTitle( UI.editFrame:GetTitle() .. " - Bearbeitungsfenster" )
    
    if fastMode then UI.mainFrame:Show() end
    
    removeDataRevisionsFolder()
    
    initialiseDataTables()
    fillModuleTree( UI.moduleTree )
    
    if not fastMode then fillExplorerTree( UI.editCompTree, true ) end
    if loadingCanceled then os.exit() end
    
    if fastMode then item_id = {} end
    
    local unusedItem_id = {}
    for k, v in pairs( item_id ) do
        unusedItem_id[k] = v
    end
    
    missingFiles = {} --Enthält nur die fehlenden Dateien des Nightly-Builds
    if not fastMode then
        for _, filePathTable in pairs( compRel ) do
            for _, filePath in pairs( filePathTable ) do
                if item_id[buildRoot .. filePath.source] == nil then
                    if not table.contains( missingFiles, filePath.source ) then
                        table.insert( missingFiles, filePath.source )
                    end
                else
                    --Für die Püfung ungenutzter Komponenten
                    if unusedItem_id[buildRoot .. filePath.source] ~= nil then
                        unusedItem_id[buildRoot .. filePath.source] = nil
                    end
                end
            end
        end
        table.sort( missingFiles, function( a, b ) return a:upper() < b:upper() end )
    end
    
    ----Muss global deklariert sein-----------
    incompleteCvsModules = {} 
    missingCvsFiles = {}
    ------------------------------------------
    
    UI.loadingDlgLbl:SetLabel( "Module werden auf fehlende Komponenten geprüft..." )
    if not fastMode then markIncompleteModules( UI.moduleTree, true, false ) end
    
    --Ordner aus den zuzuordnenden Komponenten ausschließen    
    unusedFiles = {}
    for k, v in pairs( unusedItem_id ) do
        if not UI.editCompTree:ItemHasChildren( v ) then
            table.insert( unusedFiles, k )
        end
    end
    
    UI.loadingScreen:Show( false )
    UI.mainFrame:Show( true )
    UI.mainFrame:Move( mainFramePosition )
    
    UI.mainFrame:Maximize( userSettings[os.getenv("USERNAME")]["mainFrameIsMaximized"] or false )
    UI.editFrame:Maximize( userSettings[os.getenv("USERNAME")]["editFrameIsMaximized"] or false )
   
end

function fillModuleTree( wxTreeCtrl, rebuild )
    -- Ruft die Methode "createModuleTree" nach einigen Vorbereitungen auf
    --
    -- wxTreeCtrl: Referenz auf die zu füllende Baumstruktur
    
    --Falls es nicht der erste Aufbau ist: Merken, welche Knoten aufgeklappt und markiert waren
    if rebuild then
        expandedModules = {}
        prevSelectedModule = getPathName( wxTreeCtrl, wxTreeCtrl:GetSelection() )
        for moduleName, moduleId in pairs( module_id ) do
            if UI.editModuleTree:IsExpanded( moduleId ) then
                table.insert( expandedModules, moduleName )
            end
        end
    end
    
    wxTreeCtrl:DeleteAllItems()
    local root_id = wxTreeCtrl:AddRoot( "proALPHA" )
    if not module_id then module_id = {} end
    for k in pairs( module_id ) do module_id[k] = nil end
    module_id["proALPHA"] = root_id
    createModuleTree( wxTreeCtrl, modules, root_id )
    wxTreeCtrl:Expand( root_id )
    
    if rebuild then
        for _, moduleName in pairs( expandedModules ) do
            if module_id[moduleName] then
                wxTreeCtrl:Expand( module_id[moduleName] )
            end
        end
        if module_id[prevSelectedModule] then
            wxTreeCtrl:SelectItem( module_id[prevSelectedModule] )
        end
    end
end

function createModuleTree( wxTreeCtrl, structureTable, parentId )
    -- Baut rekursiv eine Baumstruktur durch Auslesen einer Tabelle auf
    --
    -- wxTreeCtrl:      Referenz auf die zu füllende Baumstruktur
    -- structureTable:  Tabelle, aus der die Struktur ausgelesen wird
    -- parentId:        ID des Elements, dem aktuell Elemente hinzugefügt werden. Nötig, da rekursiv
    --                  Beim normalen Aufruf ist hier also die ID des Root-Elements zu übergeben
    
    if not( wxTreeCtrl == UI.editModuleTree or wxTreeCtrl == UI.editTargetTree or wxTreeCtrl == UI.moduleTree ) then
        wx.wxMessageBox( "Die Funktion \"createModuleTree\" wurde für eine ungültige Baumstruktur aufgerufen:\n" ..
            tostring(wxTreeCtrl), "Fehler in Funktion!", wx.wxICON_ERROR )
        return -1
    end
    
    local tableRef
    if wxTreeCtrl == UI.editModuleTree or wxTreeCtrl == UI.moduleTree then
        tableRef = module_id
    else
        tableRef = targetTreeId
    end
    
    for i = 1, 2, 1 do
        for name, content in pairs( structureTable )do
            --print( "state of ID-Table" ); for k, v in pairs( tableRef ) do print( k, v ) end
            if i == 1 and type(content) == "table" then
                if tableRef[getPathName( wxTreeCtrl, parentId ) .. "\\" .. name] == nil then
                    itemWasAdded = true
                    local tmpId = wxTreeCtrl:AppendItem( parentId, name )
                    tableRef[getPathName( wxTreeCtrl, tmpId )] = tmpId
                    sortChildren( wxTreeCtrl, tableRef[getPathName( wxTreeCtrl, parentId )] )                    
                end
                createModuleTree( wxTreeCtrl, content, tmpId or tableRef[getPathName( wxTreeCtrl, parentId ) .. "\\" .. name] )
            elseif i == 2 and type(content) ~= "table" then
                local tmpId = wxTreeCtrl:AppendItem( parentId, content )
                tableRef[getPathName( wxTreeCtrl, tmpId )] = tmpId
                sortChildren( wxTreeCtrl, parentId )
            end
            
        end
    end
end
    
function fillExplorerTree( explorerTree, firstCheck )
    -- Ruft nach einigen Vorbereitungen die Methode "createExplorerTree" auf
    --
    -- explorerTree:    Referenz auf die zu füllende Baumstruktur
    
    UI.loadingDlgGauge:SetRange( numberOfFiles + ( firstCheck and UI.moduleTree:GetChildrenCount( UI.moduleTree:GetRootItem(), true ) +1 or 0 ) )
    numberOfFiles = 0
    UI.loadingDlgGauge:SetValue( 0 )
    loadingCanceled = false
    UI.loadingScreen:Show( true )
    UI.loadingDlgLbl:SetLabel( "Komponenten werden importiert..." )
    explorerTree:DeleteAllItems()
    item_id = {} 
    
    local root_id = explorerTree:AddRoot( "build" )
    item_id[getPathName( explorerTree, root_id )] = root_id
    createExplorerTree( explorerTree, buildRoot:sub( 1, buildRoot:len() -1 ) )
    if loadingCanceled then
        return -1
    end
    
    UI.loadingDlgAdditionalInfo:SetLabel( "Import abgeschlossen!" )
    
    setTreeFoldersFirst( explorerTree )
    mergeDataFiles() --Um numberOfFiles zu speichern
    
    explorerTree:Expand( root_id )
end

function createExplorerTree( explorerTree, root )
    -- Baut rekursiv den Komponentenexplorer durch Auslesen eines Verzeichnisses auf
    --
    -- explorerTree:    Referenz auf die zu füllende Baumstruktur
    -- root:            Pfad des Elternknotens 
    
    for entity in lfs.dir(root) do
        if loadingCanceled then
            return
        end
        if entity ~= "." and entity ~= ".." then
            local fullPath = root .. "\\" ..entity
            if not table.find( ignoreCompList, fullPath:sub( buildRoot:len() +1 ) ) then
                local mode=lfs.attributes(fullPath,"mode")
                local parent = ""
                for path in root:gmatch( "([^\\]+)" ) do
                    parent = parent .. path .. "\\"
                end
                parent = parent:sub( 1, parent:len() -1 )
                if mode == "directory" then 
                    item_id[fullPath] = explorerTree:AppendItem( item_id[parent], entity )
                    --print( "Appending: " .. entity, "to: " .. parent, "Index: " .. fullPath )
                    createExplorerTree( explorerTree, fullPath );
                elseif mode == "file" then
                    UI.loadingDlgGauge:SetValue( UI.loadingDlgGauge:GetValue() + 1 )
                    UI.loadingDlgAdditionalInfo:SetLabel( "Importiere " .. fullPath )
                    numberOfFiles = numberOfFiles + 1
                    
                    item_id[fullPath] = explorerTree:AppendItem( item_id[parent], entity )
                    --print( "Appending: " .. entity, "to: " .. parent, "Index: " .. fullPath )
                end
            end
        end
    end
    sortChildren( explorerTree, item_id[root], false )
end

function serialize ( o, file, indent )
    -- Serialisiert Objekte in einer Datei
    --
    -- o:       Zu serialisierendes Objekt
    -- file:    Filehandle auf die Output-Datei
    -- indent:  Einrückung (sollte zu Beginn "    " sein)
        
    if type( o ) == "number" then
        file:write(o)
    elseif type( o ) == "string" then
        file:write( string.format( "%q", o ) )
    elseif type( o ) == "boolean" then
        file:write( o and "true" or "false" )
    elseif type( o ) == "table" then
        local tableItems = 0
        for _, _ in pairs( o ) do
            tableItems = tableItems +1
        end
        file:write( tableItems == 0 and "{" or "{\n" )
        
        for k, v in sortedKeys( o ) do
            if type( k ) ~= "number" then
                file:write( indent .. "[" )
                serialize( k, file, indent .. "    " )
                file:write( "] = " )
            else
                file:write( indent )
            end
            serialize( v, file, indent .. "    " )
            file:write( ",\n" )
        end
        
        file:write(tableItems == 0 and "}" or indent:gsub( "    ", "", 1 ) .. "}" )
    else
        error( "cannot serialize a " .. type(o) )
    end
end

function getPathName( wxTreeCtrl, child_id )
    -- Gibt den "Weg" zu einem Element in einem Baum als String an. Die Abzweigungen sind durch "\" gekennzeichnet
    -- Beispiel für Rückgabewert: "proALPHA\6.1\Solid Edge\ST05"
    
    -- wxTreeCtrl:  Referenz auf die Baumstruktur
    -- child_id:    Das Element der Baumstruktur, dessen Pfad ermittelt werden soll
    
    local path = {}
    table.insert( path, wxTreeCtrl:GetItemText( child_id ) )
    local function getParentTitle( child_id )
        if wxTreeCtrl:GetItemParent(child_id):IsOk() then
            table.insert( path, wxTreeCtrl:GetItemText( wxTreeCtrl:GetItemParent( child_id ) ) )
            getParentTitle( wxTreeCtrl:GetItemParent( child_id ) )
        end
    end
    getParentTitle( child_id )
    local fullName = ""
    for i = #path, 1, -1 do
        if path[i] ~= "build" then --Umbauen, wenn editCompTree für CVS funktionieren soll
            fullName = fullName .. path[i] .. "\\"
        end
    end
    fullName = fullName:sub( 1, fullName:len() -1 ) --Entfernt den "\" am Ende
    if wxTreeCtrl == UI.resultTree then
        fullName = "Root" .. fullName --Da das Rootelement versteckt ist, hat es keinen Namen i guess
    elseif wxTreeCtrl == UI.editCompTree then
        fullName = buildRoot .. fullName
        if fullName:sub( - 1 ) == "\\" then fullName = fullName:sub( 1, fullName:len() -1 ) end
    end
    return fullName
end

function showCompsForSelectedModule( inputTree, outputTree, displayParentComps, selection, clearTargetTree )
    -- Zeigt alle zugeordneten Komponenten für das angegebene Modul an
    --
    -- wxTreeCtrl:          Modulbaum, in dem ein Modul ausgewählt wird
    -- wxListBox:           Der Baum, in der die Komponenten dargestellt werden
    -- displayParentComps:  Ob die Komponenten der Elternknoten auch angezeigt werden sollen
    -- selection:           Das Modul des Modulbaums, dessen Komponenten ermittelt werden sollen
    -- clearListBox:        Ob die Ergebnisliste vor Befüllung gelöscht werden soll. Relevent wegen Multiselekt

    
    if not selection:IsOk() then
        outputTree:DeleteAllItems()
        return
    end
    
    if clearTargetTree then
        outputTree:DeleteAllItems()
        moduleTreeSelectionChanging( inputTree, outputTree, selection ) --Um ausgeklappte Items zu sichern
    end
    
    local fullName = getPathName( inputTree, selection )
    
    if not moduleComps then
        moduleComps = {}
    end
    moduleComps[fullName] = {}
    
    targetTreeId = {}
    targetTreeId["Root"] = outputTree:AddRoot( "Root" )
    
    if outputTree == UI.resultTree then
        local tmp = outputTree:AppendItem( outputTree:GetRootItem(), fullName:gsub( "\\", "/" ) )
        targetTreeId[getPathName( outputTree, tmp )] = tmp
    end
    
    if UI.cadUpdateCb:IsChecked() then
        displayParentComps = false
    end
    
    --Alle Dateien in Zwischenliste speichern - Erlaubt die alphabetisch sortierte Darstellung, 
    --da alle Komponenten vor dem Sortieren bekannt sein müssen
    
    if displayParentComps then
        local subName = ""
        for rootName in fullName:gmatch( "[^\\]+" ) do
            if subName == "" then 
                subName = rootName
            else
                subName = subName .. "\\" .. rootName  
            end
            if compRel[subName] then
                for _, component in ipairs( compRel[subName] ) do
                    local newComp = {}; newComp.source = component.source; newComp.target = component.target
                    for i, existingComp in pairs( moduleComps[fullName] ) do
                        if existingComp.target == newComp.target then
                            table.remove( moduleComps[fullName], i )
                            break
                        end
                    end
                    table.insert( moduleComps[fullName], newComp )
                end
            end 
        end
    else
        if compRel[fullName] then
            for  _, component in ipairs( compRel[fullName] ) do
                local newComp = {}; newComp.source = component.source; newComp.target = component.target
                table.insert( moduleComps[fullName], newComp )
            end
        end
    end
    
    --moduleComps sortieren
    
    local sortedModuleComps = sortedModuleComps or {}
    sortedModuleComps[fullName] = {}
    
    for _, comp in pairs( moduleComps[fullName] ) do
        table.insert( sortedModuleComps[fullName], comp.target )
    end
    table.sort( sortedModuleComps[fullName], function ( a, b ) return a:upper() < b:upper() end )
    
    for i, target in ipairs( sortedModuleComps[fullName] ) do
        local tmp = target
        sortedModuleComps[fullName][i] = {}
        sortedModuleComps[fullName][i].target = tmp
    end
    
    for _, sortedFile in ipairs( sortedModuleComps[fullName] ) do
        for _, unsortedFile in ipairs( moduleComps[fullName] ) do
            if sortedFile.target == unsortedFile.target then
                sortedFile.source = unsortedFile.source
                break
            end
        end
    end
    
    -- Über die Liste iterieren, die die anzuzeigenden Komponenten enthält
    for _, component in ipairs( sortedModuleComps[fullName] ) do
        local nodePath = ""
        
        local fileToCheck
        if UI.mainCompSrcRb:GetSelection() == 1 or outputTree == UI.editTargetTree then
            fileToCheck = component.source
        else
            fileToCheck = string.gsub( component.target, "Root\\", "" )
        end
        
        local currItem
        local destPath = ( outputTree == UI.resultTree ) and component.target:gsub( "Root", "Root\\" .. fullName:gsub( "\\", "/" ) ) or component.target
        
        -- Vollständigen Dateipfad ermitteln, wenn die Option in der Toolbar aktiviert ist
        if outputTree == UI.resultTree and UI.mTbResultListFullPath:IsToggled() then
            local fileName; for tmp in destPath:gmatch( "[^\\]+" ) do fileName = tmp end
            local fileNameStartIdx, fileNameEndIdx = destPath:find( fileName, 1, true )
            
            if fileNameEndIdx == destPath:len() then
                local sourcePath = string.gsub( component.source, "\\", "/" ):sub( 1, - ( fileName:len() +2 ) )
                if UI.mainCompSrcRb:GetSelection() == 1 then
                    sourcePath = "build/" .. sourcePath
                else
                    local branchStart, branchEnd = sourcePath:find( ".-/" )
                    if branchStart == 1 then sourcePath = sourcePath:sub( branchEnd +1 ) end
                    sourcePath = "deploy/cvs/" .. sourcePath
                end
                destPath = destPath .. " (" .. sourcePath .. ")"
            end
        end
        
        -- Den Zielbaum aus dem Pfad der Komponente aufbauen
        for node in string.gmatch( destPath, "[^\\]+" ) do
            local thisNodePath = ( nodePath == "" and "" or nodePath .. "\\" ) .. node
            if not targetTreeId[thisNodePath] then
                local tmpId = outputTree:AppendItem( targetTreeId[nodePath], node )
                targetTreeId[thisNodePath] = tmpId
            end
            nodePath = thisNodePath
            currItem = nodePath
        end
        
        if UI.mainUpdateCb:IsChecked() and table.contains( noUpdateComps, component.source ) then
            outputTree:SetItemTextColour( targetTreeId[destPath], noUpdateCompColour )
        end
        
        if table.contains( ( UI.mainCompSrcRb:GetSelection() == 1 or outputTree == UI.editTargetTree ) and missingFiles or missingCvsFiles, fileToCheck ) then
            local currId = targetTreeId[currItem]
            while currId:IsOk() do
                outputTree:SetItemTextColour( currId, missingCompColour )
                currId = outputTree:GetItemParent( currId )
            end
        end
    end
    outputTree:Expand( outputTree:GetRootItem() )
end

function table.contains( t, element )
    -- Ermittelt, ob eine Tabelle ein Element enthält
    for _, value in pairs( t ) do
        if value == element then
            return true
        end
    end
    return false
end

function table.find( tableRef, o )
    -- Sucht nicht nach identischen Objekten (wie table.contains) und kann daher mit Pattern verwendet werden
    for k, v in pairs( tableRef ) do
        local i = o:find( v )
        if i == 1 then return true end
    end
    return false
end

function table.copy( orig )
    --Kopiert den Inhalt einer Tabelle (orig) und gibt die Referenz der Kopie zurück
    local orig_type = type( orig )
    local copy
    if orig_type == "table" then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[table.copy( orig_key )] = table.copy( orig_value )
        end
    else
        copy = orig
    end
    return copy
end

function validateName( wxTreeCtrl, parentId, name, itemId )
    -- Überprüft, ob der Name eines Baumobjektes gültig ist, z.B. beim Umbennen oder Neuanlegen
    -- Wirft eine Fehlermeldung und gibt zurück, ob der Name gültig ist
    
    -- wxTreeCtrl:      Baumstruktur, die das zu prüfende Element enthält
    -- wxTreeCtrlId:    Der Parent des zu überprüfenden Items
    -- name:            Die neue, zu überprüfende Bezeichnung des Elements
    -- itemId:          Die ID eines vorhandenen Elements. Nur für Umbenennung
    
    local invalidChars = {
        [[/]],
        [[\]],
        [[:]],
        [[*]],
        [[?]],
        [["]],
        [[<]],
        [[>]],
        [[|]],
    }
    
    if name:gsub( " ", "" ) == "" then
        wx.wxMessageBox( "Der Name darf nicht leer sein.", "Ungültige Bezeichnung", wx.wxICON_ERROR )
        return false
    elseif name == wxTreeCtrl:GetItemText( wxTreeCtrl:GetRootItem() ) then
        wx.wxMessageBox( "Der Name darf nicht identisch zur Bezeichnung des Root-Elements sein.", "Ungültige Bezeichnung", wx.wxICON_ERROR )
        return false
    else
        for c in name:gmatch( "." ) do
            if table.contains( invalidChars, c ) then
                local icStr = ""; for _, ic in pairs( invalidChars ) do icStr = icStr .. ic .. " " end
                icStr:sub( 1, icStr:len() -1 )
                wx.wxMessageBox( "Ein Element darf keines der folgenden Zeichen enthalten:\n" .. icStr, 
                    "Modulname ungültig", wx.wxICON_ERROR )
                return false
            end
        end
        for child_id in childrenOf( wxTreeCtrl, parentId ) do
            if wxTreeCtrl:GetItemText( child_id ):lower() == name:lower() then
                local exists = true
                if itemId and getPathName( wxTreeCtrl, itemId ) == getPathName( wxTreeCtrl, child_id ) then
                    exists = false
                end
                if exists then
                    wx.wxMessageBox( "Das Element \"" .. wxTreeCtrl:GetItemText( child_id ) .. "\" existiert in diesem Knoten bereits.", "Ungültige Bezeichnung", wx.wxICON_ERROR )
                    return false
                end
                
            end
        end
        return true
    end
end

function insertComponent( modulePath, filePath, targetPath, replaceDestFile )
    -- Ordnet einem Modul eine Komponente hinzu.
    --
    -- modulePath:      Pfadangabe des Moduls
    -- filePath:        Pfadangabe der Komponente
    -- targetPath:      Pfadangabe des Zielordners, in den die Komponente eingefügt wird
    -- replaceDestFile: Falls im Zielordner bereits eine gleichnamige Komponente liegt, entscheidet dieser Parameter, ob sie ersetzt werden soll
    -- Die ersten 3 Parameter können mit der Methode "getPathName" ermittelt werden
    
    local subStrStart, subStrEnd = filePath:find( buildRoot, 1, true )
    if subStrStart == 1 then
        filePath = filePath:sub( subStrEnd +1 )
    end
    if item_id[buildRoot .. filePath] == nil then
        wx.wxMessageBox( "Eine Komponente konnte nicht zugeordnet werden\n" ..
            "Quellpfad ungültig: \"" .. filePath .. "\"", "Hinweis", wx.wxICON_ERROR )
        return -1
    end
    if module_id[modulePath] == nil then
        wx.wxMessageBox( "Eine Komponente konnte nicht zugeordnet werden\n" ..
            "Modul ungültig: \"" .. modulePath .. "\"", "Hinweis", wx.wxICON_ERROR )
        return -1
    end
    if targetTreeId[targetPath] == nil then
        wx.wxMessageBox( "Eine Komponente konnte nicht zugeordnet werden\n" ..
            "Zielpfad ungültig: \"" .. targetPath .. "\"", "Hinweis", wx.wxICON_ERROR )
        return -1
    end
    
    if compRel[modulePath] == nil then
        compRel[modulePath] = {}
    end
    
    local fileName
    for tmp in filePath:gmatch( "[^\\]+" ) do
        fileName = tmp
    end
    
    if replaceDestFile and targetTreeId[targetPath .. "\\" .. fileName] then
        UI.editTargetTree:Delete( targetTreeId[targetPath .. "\\" .. fileName] )
        for i, file in ipairs( compRel[modulePath] ) do
            if file.target == targetPath .. "\\" .. fileName then
                --Quell-Datei evtl. als unverwendet markieren
                if not fileIsInUse( file.source, modulePath ) then
                    local currId = item_id[buildRoot .. file.source]
                    UI.editCompTree:SetItemBackgroundColour( currId, unusedCompColour )
                    
                    currId = UI.editCompTree:GetItemParent( currId )
                    while currId:IsOk() do
                        UI.editCompTree:SetItemBackgroundColour( currId, unusedCompColour )
                        currId = UI.editCompTree:GetItemParent( currId )
                    end
                end
                table.remove( compRel[modulePath], i )
            end
        end
        targetTreeId[targetPath .. "\\" .. fileName] = nil
    end
    
    if targetTreeId[targetPath .. "\\" .. fileName] == nil then
        local tmpId = UI.editTargetTree:AppendItem( targetTreeId[targetPath], fileName )
        targetTreeId[getPathName( UI.editTargetTree, tmpId )] = tmpId
        
        sortChildren( UI.editTargetTree, targetTreeId[targetPath] )       
        --UI.editTargetTree:Expand( targetTreeId[targetPath] ) --Kann als praktisch oder störend empfunden werden
        
        local file = {}
        file.source = filePath
        file.target = targetPath .. "\\" .. fileName
        
        table.insert( compRel[modulePath], file )
        
        for k, v in pairs( unusedFiles ) do
            if v == buildRoot .. filePath then
                unusedFiles[k] = nil
                break
            end
        end
        
        local currId = item_id[buildRoot .. filePath]
        while currId:IsOk() do
            markParent( currId )
            currId = UI.editCompTree:GetItemParent( currId )
        end
        
        for _, id in pairs( item_id ) do
            UI.editCompTree:SetItemBold( id, false )
        end
    else
        wx.wxMessageBox( "Die Datei " .. targetPath .. "\\" .. fileName .. " ist bereits zugeordnet.", "Keine Zuordnung möglich" )
    end
end

function insertComponentFolder( modulePath, filePath, targetPath, replaceDestFile )
    -- Fügt einen Ordner aus dem Komponentenexplorer dem editTargetTree hinzu
    -- Ordner werden rekursiv hinzugefügt. Diese Methode funktioniert ausschließlich für Ordner!
    -- Um eine einzelne Komponenten hinzuzufügen, verwende die Methode "insertComponent".
    --
    -- Alle Parameter sind identisch zu "insertComponent"
    
    if item_id[filePath] == nil then
        wx.wxMessageBox( "Ungültiger Quellpfad\"" .. tostring( filePath ) .. "\"", "Fehler Komponentenzuordnung", wx.wxICON_ERROR )
        return
    end
    
    for child_id in childrenOf( UI.editCompTree, item_id[filePath] ) do        
        local childPath = filePath .. "\\" .. UI.editCompTree:GetItemText( child_id )
        local childTargetPath = targetPath .. "\\" .. UI.editCompTree:GetItemText( child_id )
        
        for existingTargetPath, id in pairs( targetTreeId ) do
            if childTargetPath:lower() == existingTargetPath:lower() and childTargetPath ~= existingTargetPath then
                childTargetPath = existingTargetPath
                break
            end
        end
        
        if UI.editCompTree:ItemHasChildren( item_id[childPath] ) then
            if targetTreeId[childTargetPath] == nil then
                local parent = ""
                for node in childTargetPath:gmatch( "[^\\]+\\" ) do
                    parent = parent .. node
                end
                parent = parent:sub( 1, parent:len() -1 )
                local newFolder = ""
                for node in childTargetPath:gmatch( "[^\\]+" ) do
                    newFolder = node
                end
                --print( "appending", newFolder .. "(newFolder)", "to", parent .. "(parent)" )
                targetTreeId[childTargetPath] = UI.editTargetTree:AppendItem( targetTreeId[parent], newFolder )
            end
            insertComponentFolder( modulePath, childPath, childTargetPath, replaceDestFile )
        else
            insertComponent( modulePath, childPath, targetPath, replaceDestFile )
        end
    end
end

function updateEditCompLbl()
    -- Aktualisiert den Text oberhalb des Baums zugeordneter Komponenten im Bearbeitungsfenster
    if UI.editModuleTree:GetSelection():IsOk() then
        local itemNum = compRel[getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() )] and #compRel[getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() )] or 0
        UI.editCompLbl:SetLabel( itemNum .. " Komponente" .. ( itemNum == 1 and "" or "n" ) .. " für Modul: " .. getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() ) )
    else
        UI.editCompLbl:SetLabel( "Kein Modul ausgewählt" )
    end
end

function updateEditCompTreePathLbl( compId )
    --Aktualisiert den Herkunftspfad, der oberhalb des Komponentenexplorers angezeigt wird
    if compId and compId:IsOk() then
        local path = getPathName( UI.editCompTree, compId )
        local parentPath = ""
        for part in path:gmatch( "[^\\]+" ) do
            if path:sub( - string.len( part ) ) ~= part then
                parentPath = parentPath .. "\\" .. part
            end
        end
        UI.editCompTreePathLbl:SetLabel( parentPath:sub( 2 ) )
    else
        UI.editCompTreePathLbl:SetLabel( "Keine Komponente ausgewählt" )
    end
end

function removeDuplicateComponents()
    -- Entfernt Komponenten, die bereits einem übergeordneten Modul zugeordnet sind
    --
    -- Gibt einen String mit allen doppelt zugeordneten Komponenten und
    -- einen String der Module, denen die Komponenten schon zugeordnet sind, zurück
    
    local removedCompsString = ""
    local parentsContainingCompString = ""
    
    for moduleName in pairs( compRel ) do
        local parent = ""
        --Zu jedem KomponentenArray Parents ermitteln 
        for node in moduleName:gmatch( "[^\\]+" ) do
            if parent == "" then 
                parent = node
            else
                parent = parent .. "\\" .. node  
            end
            if parent == moduleName then break end
            --Für jede Komponente des zu überprüfenden Elements ermitteln, ob der aktuelle parent sie enthält
            if compRel[parent] then
                for i, moduleFile in pairs( compRel[moduleName] ) do
                    for _, parentFile in pairs( compRel[parent] ) do
                        if string.lower( parentFile.source ) == string.lower( moduleFile.source ) then
                            if not removedCompsString:find( moduleFile.source ) then removedCompsString = removedCompsString .. moduleFile.source .. "\n" end
                            parentsContainingCompString = parentsContainingCompString .. parent .. "\n"
                            --Die Datei evtl. aus der Zielstruktur entfernen
                            if targetTreeId and targetTreeId[moduleFile.target] then
                                UI.editTargetTree:Delete( targetTreeId[moduleFile.target] )
                            end
                            compRel[moduleName][i] = nil
                            break
                        end
                    end
                end
            end
        end
    end
    return removedCompsString, parentsContainingCompString
end

function mergeDataFiles( version ) 
    -- Verschmilzt alle Daten-Tabellen in eine einzige Datei.
    -- siehe auch: initialiseDataTables()
    
    if version == nil then version = "" end
    local currFile = io.open( ( version == "" and databaseRoot or dataRevisionRoot ) .. "data" .. version .. ".lua", "w+" )
    
    for tableName, tableData in pairs( dataFiles ) do
        --print( tableName, tableData, dataFiles[tableName] )
        currFile:write( tableName .. " = " )
        serialize( tableData, currFile, "    " )
        currFile:write( "\n" )
        os.remove( databaseRoot .. tableName .. ".lua" )
    end
    if version ~= "" then
        local treeFile = io.open( databaseRoot .. "tmpTargetStructure.lua", "w" )
        treeFile:write( "tmpTargetStructure = {" )
        serializeTree( UI.editTargetTree, UI.editTargetTree:GetRootItem(), treeFile, "" )
        treeFile:close()
        
        if fileExists( databaseRoot .. "tmpTargetStructure.lua" ) then
            dofile( databaseRoot .. "tmpTargetStructure.lua" )
        else
            tmpTargetStructure = {}
        end
        
        targetStructure = targetStructure or {}        
        targetStructure[getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() )] = tmpTargetStructure
        
        currFile:write( "targetStructure = " )
        serialize( targetStructure, currFile, "    " )
        currFile:write( "\n" )
        
        os.remove( databaseRoot .. "tmpTargetStructure.lua" )
    end
    currFile:write( "numberOfFiles = " .. numberOfFiles )
    currFile:close()
end

function editHappened( edited, dontCreateRevision )
    -- Setzt eine globale Variable und den Titel des Bearbeitungsfensters nach Speicherungen oder Bearbeitungen
    -- Kümmert sich außerdem um das Verwalten von Revisionen für Rückgängig / Wiederholen
    --
    -- edited:  Ob etwas editiert wurde oder nicht (z.B. false nach Speichern)
    
    if edited then
        --Nur, wenn sich der Bearbeitungsstatus ändert, soll ein Stern prefixed werden
        if not somethingWasEdited then
            UI.editFrame:SetTitle( "* " .. UI.editFrame:GetTitle() )
        end
        UI.editToolbar:EnableTool( UI.eTbSave:GetId(), true )
        
        if not dontCreateRevision then
            editRevision = editRevision +1
            saveChanges( editRevision )
            
            UI.editToolbar:EnableTool( UI.eTbUndo:GetId(), true )
            UI.editToolbar:EnableTool( UI.eTbRedo:GetId(), false )
            
            local dataNumber = editRevision +1
            while fileExists( dataRevisionRoot .. "data" .. dataNumber .. ".lua" ) do
                os.remove( dataRevisionRoot .. "data" .. dataNumber .. ".lua" )
                dataNumber = dataNumber +1
            end
        end
    else
        UI.editToolbar:EnableTool( UI.eTbSave:GetId(), false )
        UI.editFrame:SetTitle( UI.editFrame:GetTitle():gsub( "* ", "", 1 ) )
    end
    
    somethingWasEdited = edited
end

function fileExists( file )
    -- Überprüft, ob eine Datei existiert
    
    -- file: Pfadangabe
    
	if lfs.attributes( file ) then
        return true
    else
        return false
    end
end	

function serializeTree( wxTreeCtrl, root_id, file, indent )
    -- Serialisiert die Struktur eines Baumes in eine Datei
    
    -- wxTreeCtrl:  Referenz auf den Baum
    -- root_id:     ID des obersten Knotens. Benötigt, da rekursiv
    -- file:        Filehandle zur Datei, in der gespeichert werden soll. Die Datei muss vorher geöffnet sein
    -- indent:      Einrückung zur besseren Lesbarkeit der Datei (sollte "" sein)
    
    if wxTreeCtrl:GetItemText( root_id ) ~= wxTreeCtrl:GetItemText( wxTreeCtrl:GetRootItem() ) then
        file:write( indent .. "[\"" .. wxTreeCtrl:GetItemText( root_id ) .. "\"] = { \n" )
    end
    for child_id in childrenOf( wxTreeCtrl, root_id ) do
        if child_id:IsOk() then
            if wxTreeCtrl:ItemHasChildren( child_id ) == false then
                --print( "Inserting \"" ..  wxTreeCtrl:GetItemText( child_id ) .. "\" into \"" .. wxTreeCtrl:GetItemText( root_id ) .."\"" )
                file:write( indent .. "    [\"" .. wxTreeCtrl:GetItemText( child_id ) .."\"] = {},\n" )
            else
                --print( "Creating table: \"" .. wxTreeCtrl:GetItemText( child_id ) .. "\" inside of \"" .. wxTreeCtrl:GetItemText( root_id ) .."\"" )
                serializeTree( wxTreeCtrl, child_id, file, indent .. "    " )
            end
        end
    end
    
    if wxTreeCtrl:GetItemText( root_id ) == wxTreeCtrl:GetItemText( wxTreeCtrl:GetRootItem() ) then
        file:write( "}" )
    else
        file:write( indent.. "},\n" )
    end
end

function initialiseDataTables()
    --Richtet die Variable "dataFiles" ein, welche zum Serialisieren der Daten ausgelesen wird.
    --Wann immer 'Datenbanken' in data.lua hinzugefügt werden, müssen diese hier vermerkt werden
    
    dataFiles["comments"] = comments
    dataFiles["noUpdateComps"] = noUpdateComps
    dataFiles["modules"] = modules
    dataFiles["compRel"] = compRel
    
    for fileName, _ in pairs( dataFiles ) do
        if fileExists( databaseRoot .. fileName ) then
            os.remove( databaseRoot .. fileName )
        end
    end
end

function rebuildResultTree( showParentComps )
    -- Diese Funktion kann immer verwendet werden, wenn der Komponentenbaum im Hauptfenster aktualisiert werden soll,
    -- z.B. Wenn sich eines der folgenden Dinge ändert: Selektierte Module, Dateipfad ja/nein, CAD-Update toggled, CA-Link Udpate toggled, ...
    
    -- showParentComps:         bool, ob die zugeordneten Dateien der Elternknoten auch dargestellt werden sollen oder ausschließlich die der ausgewählten Module
    -- switchedFromEditFrame:   Beim Wechsel vom Bearbeitungs- zum Hauptfenster beziehen sich die IDs auf andere Elemente
    
    local expandedItems = {}
    local selectedItems = {}
    targetTreeId = targetTreeId or {}
    
    for tTName, tTId in pairs( targetTreeId ) do
        if UI.resultTree:IsExpanded( tTId ) then
            table.insert( expandedItems, tTName )
        end
    end
    for _, selection in pairs( UI.resultTree:GetSelections() ) do
        local itemName = getPathName( UI.resultTree, selection )
        local iNStart, iNEnd = itemName:find( "%(.-%)" )
        if iNEnd == itemName:len() then itemName = itemName:sub( 1, iNStart -2 ) end
        table.insert( selectedItems, itemName )
    end
    
    UI.resultTree:DeleteAllItems()
    for _, selection in pairs( UI.moduleTree:GetSelections() ) do
        showCompsForSelectedModule( UI.moduleTree, UI.resultTree, showParentComps, selection , false )
    end
    
    markIncompleteModules( UI.moduleTree, false, not showParentComps )
    
    for _, tTName in pairs( expandedItems ) do
        if targetTreeId[tTName] then 
            resultTreeVetoEvtItemExpanded = true
            UI.resultTree:Expand( targetTreeId[tTName] )
            resultTreeVetoEvtItemExpanded = false
        end
    end
    
    setTreeFoldersFirst( UI.resultTree )
    
    for _, selectedName in pairs( selectedItems ) do
        for tTName, tTId in pairs( targetTreeId ) do
            if tTName == selectedName or tTName:find( selectedName .. " (", 1, true ) == 1 then
                UI.resultTree:SelectItem( tTId )
            end
        end
    end    
end

function markAllComponents( newComps )
    -- Färbt alle Komponenten des Komponentenexplorers, sowohl ungenutzte als auch nicht updatefähige
    
    -- newComps: Bei der Markierung werden unbekannte Dateien überprüft. Nötig bei refresh des Komponentenexplorers
    -- Dafür muss, bevor unbekannte Komponenten hinzukommen, eine Kopie der Tabelle "item_id" angefertigt werden (prevItem_id)
    
    if fastMode then return -1 end
    
    local item_id_size = 0
    for _, thisItemId in pairs( item_id ) do
        if not UI.editCompTree:ItemHasChildren( thisItemId ) then
            item_id_size = item_id_size +1
        end
    end
    UI.loadingDlgGauge:SetRange( item_id_size )
    UI.loadingDlgGauge:SetValue( 0 )
    loadingCanceled = false
    UI.loadingScreen:Show( true )
    UI.loadingDlgLbl:SetLabel( "Komponenten werden auf Verwendung überprüft..." )
    
    
    for compName, compId in pairs( item_id ) do
        if loadingCanceled then 
            wx.wxMessageBox( "Der Vorgang wurde abgebrochen, die Komponenten sind nicht korrekt markiert!", "Markierung abgebrochen!" )
            return 
        end
        local markAsLonely = false
        if newComps and prevItem_id[compName] == nil then
            --New item found
            local subStrStart, subStrEnd = compName:find( buildRoot, 1, true )
            local fileName = compName:sub( subStrEnd +1 )
            local itemInUse = false
            if not fileIsInUse( fileName )  then
                markAsLonely = true
            end
        end  
        --Nur Komponenten (keine Ordner) sind in unusedFiles[] enthalten
        if not UI.editCompTree:ItemHasChildren( compId ) then  
            if table.contains( unusedFiles, compName ) or markAsLonely then
                local parentId = UI.editCompTree:GetItemParent( compId )
                while parentId:IsOk() and UI.editCompTree:GetItemBackgroundColour( parentId ):GetAsString( wx.wxC2S_HTML_SYNTAX ) ~= unusedCompColour:GetAsString( wx.wxC2S_HTML_SYNTAX ) do
                    UI.editCompTree:SetItemBackgroundColour( parentId, unusedCompColour )
                    parentId = UI.editCompTree:GetItemParent( parentId )
                end
                UI.editCompTree:SetItemBackgroundColour( compId, unusedCompColour )
                UI.loadingDlgGauge:SetValue( UI.loadingDlgGauge:GetValue() +1 )
                UI.loadingDlgAdditionalInfo:SetLabel( "Unbenutzt: " .. getPathName( UI.editCompTree, compId ) )
            else
                UI.editCompTree:SetItemBackgroundColour( compId, wx.wxWHITE )
                UI.loadingDlgGauge:SetValue( UI.loadingDlgGauge:GetValue() +1 )
                UI.loadingDlgAdditionalInfo:SetLabel( "Zugeordnet: " .. getPathName( UI.editCompTree, compId ) )
            end
            if table.contains( noUpdateComps, compName:sub( buildRoot:len() +1 ) ) then
                UI.editCompTree:SetItemTextColour( compId, noUpdateCompColour )
                UI.loadingDlgAdditionalInfo:SetLabel( "Nicht updatefähig: " .. getPathName( UI.editCompTree, compId ) )
            else
                UI.editCompTree:SetItemTextColour( compId, wx.wxBLACK )
            end
        end
    end
    UI.loadingScreen:Show( false )
    UI.editFrame:SetFocus()
end

function markParent( parent_id )
    -- Setzt den Hintergrund eines Ordners auf Gelb oder Weiß, indem geprüft wird, ob alle Kinder zugeordnet sind.
    -- Wird diese Funnktion auf ein Element ohne Kinder angewendet, wird es automatisch weiß sein, da keine
    -- nicht zugeordneten Komponenten enthalten sind.
    
    -- parent_id: Die ID des zu überprüfenden Ordners
    
    local containsUnassigned = false
    for child_id in childrenOf( UI.editCompTree, parent_id ) do
        if UI.editCompTree:ItemHasChildren( child_id ) then
            markParent( child_id )
        end
        if UI.editCompTree:GetItemBackgroundColour( child_id ):GetAsString( wx.wxC2S_HTML_SYNTAX ) == unusedCompColour:GetAsString( wx.wxC2S_HTML_SYNTAX ) then
            --print( "\"" .. UI.editCompTree:GetItemText( child_id ) .. "\" ist nicht zugeordnet" )
            UI.editCompTree:SetItemBackgroundColour( parent_id, unusedCompColour )
            containsUnassigned = true
            break
        end
    end

    if not containsUnassigned then
        --print( "\"" .. UI.editCompTree:GetItemText( parent_id ) .. "\" enthält nur zugeordnete Komponenten" )
        UI.editCompTree:SetItemBackgroundColour( parent_id, wx.wxWHITE )
    else
        --print( "\"" .. UI.editCompTree:GetItemText( parent_id ) .. "\" enthält nicht zugeordnete Komponenten" )
        UI.editCompTree:SetItemBackgroundColour( parent_id, unusedCompColour )
    end
end

function saveChanges( version )
    -- Speichert den aktuellen Stand des Bearbeitungsfensters in "data(version).lua" 
    
    -- Version: Der Änderungsindex. Benutzt für Rückgängig-Funktion, um ein aktuelles Abbild zu erstellen
    -- Wird keine Versionsnummer angegeben, wird eine endgültige Speicherung durchgeführt (in data.lua)
    
    local currFile = io.open( databaseRoot .. "modules.lua", "w+" )
    currFile:write( "modules = {\n" )
    serializeTree( UI.editModuleTree, UI.editModuleTree:GetRootItem(), currFile, "" )       
    currFile:close()
    dofile( databaseRoot .. "modules.lua" )
    dataFiles[ "modules" ] = modules
    
    if not version then --Änderungen endgültig speichern
        
        --Backup erstellen, falls beim Speichern etwas schiefgeht
        local bakInFile = io.open( databaseRoot .. "data.lua", "r" )
        local bakInStream = bakInFile:read( "*all" )
        bakInFile:close()
        local bakOutFile = io.open( databaseRoot .. "data(automaticBackup).lua", "w+" )
        bakOutFile:write( bakInStream )
        bakOutFile:close()
        
        saveComment()
        
        fillModuleTree( UI.moduleTree ) --why
        
        local expandedDestItems = {}
        for tTName, tTId in pairs( targetTreeId ) do
            if UI.editTargetTree:ItemHasChildren( tTId ) and UI.editTargetTree:IsExpanded( tTId ) then
                table.insert( expandedDestItems, tTName )
            end
        end
        
        fillModuleTree( UI.editModuleTree, true )
        showCompsForSelectedModule( UI.editModuleTree, UI.editTargetTree, false, UI.editModuleTree:GetSelection(), true )
        setTreeFoldersFirst( UI.editTargetTree, UI.editTargetTree:GetRootItem() )
        
        for _, tTName in pairs( expandedDestItems ) do
            if targetTreeId[tTName] then
                UI.editTargetTree:Expand( targetTreeId[tTName] )
            end
        end
        
        markIncompleteModules( UI.editModuleTree, false, true )
        
        removeDuplicateComponents() 
    end
    
    mergeDataFiles( version )
    
    if not version then 
        local saveNote
        if databaseRoot == "\\\\ham-vscalink01\\deploy\\program\\deploy\\" then
            saveNote = "Sie werden aber beim nächsten Nightly-Build überschrieben, wenn du die Datei \"" .. databaseRoot .. "data.lua\" " ..
                "nicht in Mercurial eincheckst!"
        else
            saveNote = "Denke daran, die folgende Datei in Mercurial einzuchecken:\n\"" .. databaseRoot .. "data.lua\"."
        end
        
        wx.wxMessageBox( "Die Änderungen wurden erfolgreich gespeichert!\n" .. saveNote, "Erfolg!" )
        editHappened( false ) 
    end
end

function restoreEditRevision()
    -- Stellt beim Drücken auf "Rückgängig" oder "Wiederholen" den Stand einer Revision her
    -- Dabei wird auf die globale Variable "editRevision" Bezug genommen, die vorher bestimmt werden muss
    
    local compRelCopy = {}
    for moduleName, filePathTable in pairs( compRel ) do
        compRelCopy[moduleName] = {}
        for k, v in pairs( filePathTable ) do
            compRelCopy[moduleName][k] = v
        end
    end
    
    --print( "loading Revision: " .. editRevision )
    dofile( dataRevisionRoot .. "data" ..editRevision .. ".lua" )
    initialiseDataTables()
    
    local expandedDestItems = {}
    for tTName, tTId in pairs( targetTreeId ) do
        if UI.editTargetTree:ItemHasChildren( tTId ) and UI.editTargetTree:IsExpanded( tTId ) then
            table.insert( expandedDestItems, tTName )
        end
    end
    
    fillModuleTree( UI.editModuleTree, true )

    updateEditCompLbl()
    if UI.editModuleTree:GetSelection():IsOk() then
        showCompsForSelectedModule( UI.editModuleTree, UI.editTargetTree, false, UI.editModuleTree:GetSelection(), true )
    else
        UI.editTargetTree:DeleteAllItems()
    end
    
    if UI.editTargetTree:GetRootItem():IsOk() then
        createModuleTree( UI.editTargetTree, targetStructure[getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() )] or {}, UI.editTargetTree:GetRootItem() )
        setTreeFoldersFirst( UI.editTargetTree, UI.editTargetTree:GetRootItem() )
    end
    
    for _, tTName in pairs( expandedDestItems ) do
        if targetTreeId[tTName] then UI.editTargetTree:Expand( targetTreeId[tTName] ) end        
    end
    
    markIncompleteModules( UI.editModuleTree, false, true )
    --Text farblich markieren, um auf noUpdateComps hinzuweisen
    for compName, compId in pairs( item_id ) do
        UI.editCompTree:SetItemTextColour( compId, wx.wxBLACK )
    end
    for _, compName in pairs( noUpdateComps ) do
        if item_id[buildRoot .. compName] then
            UI.editCompTree:SetItemTextColour( item_id[buildRoot .. compName], noUpdateCompColour )
        end
    end
    
    --editCompTree auf Veränderungen der compRel überprüfen
    local compRelSize = 0
    for k, v in pairs( compRel ) do
        compRelSize = compRelSize +1
    end
    local compRelCopySize = 0
    for k, v in pairs( compRelCopy ) do
        compRelCopySize = compRelCopySize +1
    end
    
    if compRelSize < compRelCopySize then
        --Komponententabellen wurden entfernt
        --Ermitteln, ob die Komponenten der gelöschten Tabelle noch benutzt werden
        for moduleName, filePathTable in pairs( compRelCopy ) do
            if compRel[moduleName] == nil then
                for _, moduleToCheck in pairs( compRelCopy[moduleName] ) do
                    local fileIsUsed = false
                    for innerModuleName, innerFilePathTable in pairs( compRelCopy ) do
                        if innerModuleName ~= moduleName then
                            for k, v in pairs( compRelCopy[innerModuleName] ) do
                                if v.source == moduleToCheck then
                                    fileIsUsed = true
                                    break
                                end
                            end
                            if fileIsUsed then break end
                        end
                    end
                    if not fileIsUsed and item_id[buildRoot .. moduleToCheck.source] then
                        UI.editCompTree:SetItemBackgroundColour( item_id[buildRoot .. moduleToCheck.source], unusedCompColour )
                        local parentId = UI.editCompTree:GetItemParent( item_id[buildRoot .. moduleToCheck.source] )
                        while parentId:IsOk() do
                            UI.editCompTree:SetItemBackgroundColour( parentId, unusedCompColour )
                            parentId = UI.editCompTree:GetItemParent( parentId )
                        end
                    end
                end
            end
        end
    elseif compRelSize > compRelCopySize then
        --Komponententabellen wurden hinzugefügt
        --Alle Komponenten der neuen Tabellen als verwendet markieren
        for moduleName, filePathTable in pairs( compRel ) do
            if compRelCopy[moduleName] == nil then
                for _, newComp in pairs( compRel[moduleName] ) do
                    if item_id[buildRoot .. newComp.source] then
                        UI.editCompTree:SetItemBackgroundColour( item_id[buildRoot .. newComp.source], wx.wxWHITE )
                        local parentId = UI.editCompTree:GetItemParent( item_id[buildRoot .. newComp.source] )
                        while parentId:IsOk() do
                            markParent( parentId )
                            parentId = UI.editCompTree:GetItemParent( parentId )
                        end
                    end
                end
            end
        end
    elseif compRelSize == compRelCopySize then
        local unusedItem_id = {}
        for k, v in pairs( item_id ) do
            unusedItem_id[k] = v
            UI.editCompTree:SetItemBackgroundColour( v, wx.wxWHITE )
        end
        for _, filePathTable in pairs( compRel ) do
            for _, filePath in pairs( filePathTable ) do
                if not ( item_id[buildRoot .. filePath.source] == nil or unusedItem_id[buildRoot .. filePath.source] == nil ) then
                    unusedItem_id[buildRoot .. filePath.source] = nil
                end
            end
        end      
        unusedFiles = {}
        for k, v in pairs( unusedItem_id ) do
            if not UI.editCompTree:ItemHasChildren( v ) then
                table.insert( unusedFiles, k ) 
                UI.editCompTree:SetItemBackgroundColour( v, unusedCompColour )
                local parentId = UI.editCompTree:GetItemParent( v )
                while parentId:IsOk() and UI.editCompTree:GetItemBackgroundColour( parentId ):GetAsString( wx.wxC2S_HTML_SYNTAX ) ~= unusedCompColour:GetAsString( wx.wxC2S_HTML_SYNTAX ) do
                    UI.editCompTree:SetItemBackgroundColour( parentId, unusedCompColour )
                    parentId = UI.editCompTree:GetItemParent( parentId )
                end
            end
        end
    end
    
    markParent( UI.editCompTree:GetRootItem() )
    for _, id in pairs( item_id ) do
        UI.editCompTree:SetItemBold( id, false )
    end
    
    if editRevision == 0 then
        UI.editToolbar:EnableTool( UI.eTbUndo:GetId(), false )
    end
    
    UI.editCommentCtrl:ChangeValue( comments[getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() )] or "" )
    
    --Um Speicher freizugeben
    compRelCopy = nil
    noUpdateCompsCopy = nil
    UI.editFrame:SetFocus( true )
    
end

function markIncompleteModules( moduleTree, firstCheck, ignoreChildren )
    loadingCanceled = false
    -- Überprüft die gesamte Modulbaumstruktur auf Module mit fehlenden Komponenten und markiert diese
    
    -- moduleTree:      Die zu überprüfende Baumstruktur
    -- firstCheck:      Bool, ob es sich um die erste Überprüfung handelt
    -- ignoreChildren:  Bool, ob die Kinder eines Moduls markiert werden sollen, wenn sie einem unvollständigen Modul untergeordnet sind
    
    if UI.cadUpdateCb:IsChecked() then
        ignoreChildren = true --Die Checkbox deaktiviert Abhängigkeiten von Modulen
    end
    local checkNb
    local checkCvs
    
    if UI.mainCompSrcRb:GetSelection() == 0 then
        checkNb = false
        checkCvs = true
    else
        checkNb = true
        checkCvs = false
    end
    
    for moduleName, moduleId in pairs( module_id ) do
        moduleTree:SetItemTextColour( moduleId, wx.wxBLACK )
    end
    
    if ( not firstCheck ) and checkCvs then
        -- Das Überprüfen auf unvollständige Module bei Verwendung von CVS-Komponenten dauert lange und wird nur beim Programmstart durchgeführt.
        -- Danach wird für das Bestimmen unvollständiger CVS-Module eine bei Erstprüfung angefertigte Liste ausgelesen
        for key, moduleName in pairs( incompleteCvsModules ) do
            if module_id[moduleName] then
                moduleTree:SetItemTextColour( module_id[moduleName], missingCompColour )
                if not ignoreChildren and moduleTree:ItemHasChildren( module_id[moduleName] ) then
                    for child_id in childrenOf( moduleTree, module_id[moduleName] ) do
                        moduleTree:SetItemTextColour( child_id, missingCompColour )
                    end
                end
            else
                table.remove( incompleteCvsModules, key )
            end
        end
    else
        for moduleName, moduleId in sortedKeys( module_id ) do
            UI.loadingDlgAdditionalInfo:SetLabel( "Prüfe auf Vollständigkeit: " .. moduleName )
            if compRel[moduleName] then
                for _, comp in pairs( compRel[moduleName] ) do
                    if loadingCanceled then
                        wx.wxMessageBox( "Der Ladevorgang wurde abgebrochen! Unvollständige Module sind nicht gekennzeichnet!", "Markierung abgebrochen!" )
                        return
                    end
                    --if true then return end
                    if ( checkNb and table.contains( missingFiles, comp.source ) ) 
                    or ( checkCvs and not fileExists( cvsRoot .. string.sub( comp.target, 6 ) ) )
                    then
                        --moduleId ist unvollständig
                        moduleTree:SetItemTextColour( moduleId, missingCompColour )
                        if UI.mainCompSrcRb:GetSelection() == 0 then
                            if not table.contains( incompleteCvsModules, getPathName( moduleTree, moduleId ) ) then
                                table.insert( incompleteCvsModules, getPathName( moduleTree, moduleId ) )
                            end
                            local tmpName = string.gsub( comp.target, "Root\\", "" ) --weil string.gsub 2 Werte zurückgibt und table.insert bei 3 Parametern kaputt geht
                            table.insert( missingCvsFiles, tmpName )
                        end
                        if moduleTree:ItemHasChildren( moduleId ) and ( not ignoreChildren ) then
                            local childId = ""
                            for i = 1, moduleTree:GetChildrenCount( moduleId ), 1 do
                                if i == 1 then
                                    childId = moduleTree:GetFirstChild( moduleId )
                                else
                                    childId = moduleTree:GetNextSibling( childId )
                                end
                                moduleTree:SetItemTextColour( childId, missingCompColour )
                            end
                        end
                    end
                end
            end
            UI.loadingDlgGauge:SetValue( UI.loadingDlgGauge:GetValue() +1 )
        end
    end
    
    -- Leere Module ermitteln. Auszuschließen sind diejenigen, die befüllte Module enthalten.
    for module in childrenOf( moduleTree, moduleTree:GetRootItem(), true ) do
        if compRel[getPathName( moduleTree, module )] == nil and comments[getPathName( moduleTree, module )] == nil then
            moduleTree:SetItemTextColour( module, emptyModuleColour )
        else
            local currId = module
            while currId:IsOk() do
                currId = moduleTree:GetItemParent( currId )
                if moduleTree:GetItemTextColour( currId ):GetAsString( wx.wxC2S_HTML_SYNTAX ) == emptyModuleColour:GetAsString( wx.wxC2S_HTML_SYNTAX ) then
                    moduleTree:SetItemTextColour( currId, wx.wxBLACK )
                end
            end
        end
    end
    
    UI.loadingScreen:Show( false )
    if UI.mainFrame:IsShown() then
        UI.mainFrame:Enable( true )
        UI.mainFrame:SetFocus()
    end
end

function saveUserSettings()
    -- Füllt eine Liste mit Einstellungen für den aktuellen Nutzer und speichert sie in einer eigenen Datei
    
    local user = os.getenv( "USERNAME" )
    
    --Die Usersettings sollen zentral auf dem Server gespeichert werden! Dadurch müssen sie nicht
    --eingecheckt werden, außerdem sind sie bei lokaler und remote-Nutzung identisch!
    
    if not customFolderPath then customFolderPath = userSettings[user]["packagePath"] or "" end
    
    dofile( userSettingsPath )
    
    userSettings[user] = {}
    userSettings[user]["mainSplitterSashPos"]   = UI.mainSplitter:GetSashPosition()
    userSettings[user]["editFrameSash1Pos"]     = UI.editMainSplitter:GetSashPosition()
    userSettings[user]["editFrameSash2Pos"]     = UI.editCompMainSplitter:GetSashPosition()
    userSettings[user]["zipToolPath"]           = zippingToolPath
    userSettings[user]["mainFrameSize_Height"]  = UI.mainFrame:GetSize():GetHeight()
    userSettings[user]["mainFrameSize_Width"]   = UI.mainFrame:GetSize():GetWidth()
    userSettings[user]["mainFrameIsMaximized"]  = UI.mainFrame:IsMaximized()
    userSettings[user]["editFrameSize_Height"]  = UI.editFrame:GetSize():GetHeight()
    userSettings[user]["editFrameSize_Width"]   = UI.editFrame:GetSize():GetWidth()
    userSettings[user]["editFrameIsMaximized"]  = UI.editFrame:IsMaximized()
    userSettings[user]["mainFrameXPos"]         = UI.mainFrame:GetPosition().x
    userSettings[user]["mainFrameYPos"]         = UI.mainFrame:GetPosition().y
    userSettings[user]["editFrameXPos"]         = UI.editFrame:GetPosition().x
    userSettings[user]["editFrameYPos"]         = UI.editFrame:GetPosition().y
    userSettings[user]["lastUsed"]              = os.date("%c")
    userSettings[user]["packagePath"]           = customFolderPath
    userSettings[user]["AdobePdfReader"]        = adobePath
    
    local userFile = io.open( userSettingsPath, "w+" )
    userFile:write( "userSettings = " )
    serialize( userSettings, userFile, "    " )
    userFile:close()
end

function sortedKeys( t )
    --Stellt einen Iterator bereit, der ein Array nach sortierten Indizes (keys) ausgibt
    --Usage: for k, v in sortedKeys(table) do print (k, v) end
    
    --t: Die in sortierter Reihenfolge zu iterierende table
    
    local tmpT = {}
    local i = 0
    for k, v in pairs( t ) do
        table.insert( tmpT, k )
    end
    table.sort( tmpT, function( a, b ) if type( a ) == "string" and type( b ) == "string" then return a:upper() < b:upper() else return a < b end end )
    return function()
        i = i +1 
        return tmpT[i], t[tmpT[i]]
    end
end

function removeDataRevisionsFolder()
    -- Löscht den Ordner databaseRoot\dataRevisisions
    if fileExists( databaseRoot .. "editMode.lock" ) then
        return -1
    end
    
    for filePath in lfs.dir( dataRevisionRoot ) do
        os.remove( dataRevisionRoot .. filePath )
    end
    lfs.rmdir( dataRevisionRoot )
end

function fileIsInUse( fileName, thisModuleName )
    -- Diese Datei überprüft, ob eine Datei verwendet wird
    
    -- fileName:        Der Pfad der Datei. Bezieht sich auf die Herkunft. Beispiel: "default\\Standard110\\calink.ini"
    -- thisModuleName:  Exkludiert dieses Modul von der Suche
    
    local fileIsUsed = false
    for moduleName, filePathTable in pairs( compRel ) do
        if moduleName ~= thisModuleName then
            for _, file in ipairs( filePathTable ) do
                if fileName == file.source then fileIsUsed = true; break end
            end
        end
    end
    --print( "file is used:", fileName, fileIsUsed )
    return fileIsUsed
end

function setTreeFoldersFirst( treeCtrl, parentId )
    -- Die Funktion verschiebt alle Dateien bzw. Baumelemente ohne Kinder ans Ende einer Baumstruktur.
    -- Die Reihenfolder der Ordner und Kinder untereinander bleibt unverändert
    
    -- targetTree:  Der zu sortierende Baum
    -- parentId:    Die ID des Elements, dessen Inhalt sortiert werden soll. Funktion ist rekursiv
    
    if not( treeCtrl == UI.editTargetTree or treeCtrl == UI.resultTree or treeCtrl == UI.editCompTree ) then
        error( "The method 'setTreeFoldersFirst' was called on an invalid wxTreeCtrl: " .. tostring( treeCtrl ), 2 )
    end
    
    if parentId == nil then
        parentId = treeCtrl:GetRootItem()
    end

    
    for childId in childrenOf( treeCtrl, parentId ) do
        local isFolder = false
        local moduleTree
        local name = treeCtrl:GetItemText( childId )
        
        if UI.mainFrame:IsShown() and treeCtrl == UI.resultTree then moduleTree = UI.moduleTree
        elseif UI.editFrame:IsShown() and treeCtrl == UI.editTargetTree then moduleTree = UI.editModuleTree
        end
        
        -- Um leere Ordner von Dateien zu unterscheiden, wird gesucht, ob eine Datei mit dem Namen des Elements in der Zuordnungstabelle liegt
        if moduleTree and moduleTree:GetSelection():IsOk() and compRel[getPathName( moduleTree, moduleTree:GetSelection() )] then
            isFolder = true
            local childPath = getPathName( treeCtrl, childId )
            for _, file in ipairs( compRel[getPathName( moduleTree, moduleTree:GetSelection() )] ) do
                if file.target == childPath then
                    isFolder = false
                    break
                end
            end
        end
        
        
        if name ~= "" and ( not treeCtrl:ItemHasChildren( childId ) ) and ( not isFolder ) then
            local prevTxtColour = treeCtrl:GetItemTextColour( childId )
            local prevBgColour = treeCtrl:GetItemBackgroundColour( childId )
            
            treeCtrl:Delete( childId )
            local tmpId = treeCtrl:AppendItem( parentId, name )
            
            treeCtrl:SetItemTextColour( tmpId, prevTxtColour )
            treeCtrl:SetItemBackgroundColour( tmpId, prevBgColour )
            
            if treeCtrl == UI.editTargetTree or treeCtrl == UI.resultTree then
                targetTreeId[getPathName( treeCtrl, tmpId )] = tmpId
            elseif treeCtrl == UI.editCompTree then
                item_id[getPathName( treeCtrl, tmpId )] = tmpId 
            end
        else
            setTreeFoldersFirst( treeCtrl, childId )
        end
    end
end

function sortChildren( treeCtrl, parentId, recurse )
    -- Sortiert eine Baumstruktur mit einem "natural-sort" Algorithmus
    
    -- treeCtrl: Die zu sortierende Baumstruktur
    -- parentId: Der Knoten, dessen Kinder sortiert werden sollen. nil => Root
    -- recurse:  Bool, ob rekursiv oder iterativ traversiert wird
    
    -- Wenn nur treeCtrl übergeben wird, wird der gesamte Baum sortiert.
    
    --http://notebook.kulchenko.com/algorithms/alphanumeric-natural-sorting-for-humans-in-lua
    local function alphanumsort(o)
        local function padnum(d) return ("%03d%s"):format(#d, d) end
        table.sort(o, function(a,b)
            return tostring(a):upper():gsub("%d+",padnum) < tostring(b):upper():gsub("%d+",padnum) end)
        return o
    end    
    
     local function moveElement( treeCtrl, tableRef, sourceId, targetId )
        local tmp = treeCtrl:AppendItem( targetId, treeCtrl:GetItemText( sourceId ) )
        tableRef[getPathName( treeCtrl, tmp )] = tmp
        
        treeCtrl:SetItemBackgroundColour( tmp, treeCtrl:GetItemBackgroundColour( sourceId ) )
        treeCtrl:SetItemTextColour( tmp, treeCtrl:GetItemTextColour( sourceId ) )        
        
        return tmp
    end   
    
    local function moveChildren( treeCtrl, tableRef, sourceId, targetId )
        for child in childrenOf( treeCtrl, sourceId ) do
            local newId = moveElement( treeCtrl, tableRef, child, targetId )
            if treeCtrl:ItemHasChildren( child ) then
                moveChildren( treeCtrl, tableRef, child, newId )
            end
        end
    end
    
    local tableRef
    if treeCtrl == UI.moduleTree or treeCtrl == UI.editModuleTree then
        tableRef = module_id
    elseif treeCtrl == UI.editCompTree then
        tableRef = item_id
    elseif treeCtrl == UI.resultTree or treeCtrl == UI.editTargetTree then
        tableRef = targetTreeId
    else
        error( "The method 'sortChildren' was called on an invalid wxTreeCtrl: " .. tostring( treeCtrl ), 2 )
    end
    
    if parentId == nil then
        parentId = treeCtrl:GetRootItem()
        if recurse == nil then recurse = true end
    end
    
    local expandedChildren = {}
    local selectedChildren = {}
    for child in childrenOf( treeCtrl, parentId, true ) do
        if treeCtrl:IsExpanded( child ) then
            table.insert( expandedChildren, getPathName( treeCtrl, child ) )
        end
        if treeCtrl:IsSelected( child ) then
            table.insert( selectedChildren, getPathName( treeCtrl, child ) )
        end
    end
    
    local sortedTreeTable = {}
    local i = 1
    for child in childrenOf( treeCtrl, parentId ) do
        sortedTreeTable[i] = treeCtrl:GetItemText( child )
        i = i +1
    end
    
    sortedTreeTable = alphanumsort( sortedTreeTable )
    
    for _, itemName in ipairs( sortedTreeTable ) do
        local oldId = tableRef[getPathName( treeCtrl, parentId ) .. "\\" .. itemName]
        if oldId == nil then error( "Das Element '" .. itemName .. "' ist seiner ID-Table nicht zugeordnet", 2 ) end
        local newId = moveElement( treeCtrl, tableRef, oldId, parentId )
        
        if treeCtrl:ItemHasChildren( oldId ) then
            moveChildren( treeCtrl, tableRef, oldId, newId )
            if recurse then sortChildren( treeCtrl, newId, true ) end
        end        
        treeCtrl:Delete( oldId )
    end  
    
    for _, childName in pairs( expandedChildren ) do
        if tableRef[childName] then
            treeCtrl:Expand( tableRef[childName] )
        end
    end  
    
    for _, childName in pairs( selectedChildren ) do
        if tableRef[childName] then
            treeCtrl:SelectItem( tableRef[childName], true )
        end
    end
end

function childrenOf( tree, parentId, recurse )
    -- Stellt einen Iterator bereit, mit dem man über die Kinder eines Baumelements iterieren kann
    
    -- tree:        Die Baumstruktur, in der iteriert wird
    -- parentId:    Das Item, über dessen Kinder iteriert werden soll
    -- recurse:     Bool, ob rekursiv oder iterativ traversiert werden soll
    --              Elemente werden immer in der Reihenfolge traversiert, in der sie dargestellt werden
    
    local i = 0
    local childIdTable = {}
    local tmpItem
    
    for j = 1, tree:GetChildrenCount( parentId, false ), 1 do
        if j == 1 then tmpItem = tree:GetFirstChild( parentId )
        else tmpItem = tree:GetNextSibling( tmpItem )
        end
        table.insert( childIdTable, tmpItem )
        if recurse and tree:ItemHasChildren( tmpItem ) then
            for innerChild in childrenOf( tree, tmpItem, true ) do
                table.insert( childIdTable, innerChild )
            end
        end
    end
    
    return function()
        i = i +1
        return childIdTable[i]
    end
end

function alignFolderName( folderPath )
    -- Falls ein übergeordnetes Modul bereits einen Zielordner mit gleichem Namen aber unterschiedlicher
    -- Groß- / Kleinschreibung hat, gibt diese Funktion den Namen des vorhandenen Orders zurück
    
    -- folderPath:  Der neu erzeugte Pfad des Zielorders, der auf Vorkommen mit unterschiedlicher Schreibweise geprüft werden soll
    
    local child = "" 
    local parent = ""
    local moduleName = getPathName( UI.editModuleTree, UI.editModuleTree:GetSelection() ) .. "\\"    
    
    local i = 1
    for node in moduleName:gmatch( "[^\\]+" ) do
        if i == 1 then parent = node end
        if i == 2 then child = parent .. "\\" .. node end
        if i == 3 then break end
        i = i+1
    end
    
    
    
    while child do
        --print( "child: "  .. child .. "\tparent: " .. parent .. "\n" )
        if compRel[parent] then
            for _, file in ipairs( compRel[parent] ) do
                local existingFolder = ""
                for node in string.gmatch( file.target, "[^\\]+" ) do
                    if existingFolder == "" then
                        existingFolder = node
                    else
                        existingFolder = existingFolder .. "\\" .. node
                    end
                    if existingFolder:lower() == folderPath:lower() and existingFolder ~= folderPath then
                        --wx.wxMessageBox( "Der Ordner \n\"" .. existingFolder .."\" existiert bereits im Parent-Modul \n\"" .. parent .. "\" und wird daher in seiner Schreibweise angepasst." )
                        return existingFolder
                    end
                end
            end
        end
        
        parent = child
        --child = moduleName:match( child .. "\\.-\\" )
        --child kann chars enthalten, die von match irrtümlich als pattern interpretiert werden
        
        --Post nicht wie die Gelbe die Briefe versendet, sondern im Sinne von "danach"
        local childPost = moduleName:sub( child:len() +2 )
        --print( "extracting next child from " .. childPost .. "\n" )
        child = child .. "\\"
        for c in childPost:gmatch( "." ) do
            if c == "\\" then break end
            child = child .. c
        end
        if childPost == "" then child = nil end
    end
    return -1
end

function focusedTreeGetSelection()
    -- Funktioniert nur für UI.editModuleTree & UI.editTargetTree
    -- Da es sich um Single- und Multiselektbäume handelt, vereint diese Methode die speziellen Operatoren,
    -- die benötigt sind, um bei der Selektion eines einzelnen Elements dieses zu ermitteln
    
    -- Ist keines oder mehr als ein Element selektiert, gibt die Methode ein ungültiges Baumobjekt zurück
    
    if focusedTree == UI.editTargetTree then
        local selections = UI.editTargetTree:GetSelections()
        if #selections == 1 then
            return selections[1]
        else
            return UI.editTargetTree:GetItemParent( UI.editTargetTree:GetRootItem() ) --invalid
        end
    elseif focusedTree == UI.editModuleTree then
        return UI.editModuleTree:GetSelection()
    end
end

main()
wx.wxGetApp():MainLoop()