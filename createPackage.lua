if not compRel then
    error( "Die Datei \"data.lua\" ist nicht geladen.", 2 )
end

if not lfs then
    error( "Das Plugin \"lfs.dll\" ist nicht geladen", 2 )
end

local buildRoot = buildRoot or "\\\\ham-vscalink01\\build\\"
local cvsRoot = cvsRoot or "\\\\ham-vscalink01\\deploy\\cvs\\"
local updateCompNoteWasWritten = false
function createPackage( moduleName, targetPath, useCvsComps, cadUpdate, calMajUpdate )
    -- Erstellt ein Installationspaket anhand der Zuordnungen aus dem Auslieferungsassistenten
    
    -- moduleName   string  Name des Moduls, dessen Paket erstellt werden soll.      Beispiel: "proALPHA\\6.2\\Solid Edge\\2019"
    -- targetPath   string  Pfadangabe des Zielordners inklusive des Paketsamens     Beispiel: "D:\\Projekte\\SE2019 pA6.2"
    -- useCvsComps  bool    Angabe, ob die Komponenten aus dem CVS oder dem Nightly build stammen
    -- cadUpdate    bool    Hiermit werden nur die Komponenten des angegebenen Moduls ohne die der übergeordneten Module kopiert
    -- calMajUpdate bool    CA-Link Major Update: Nicht-updatefähige Dateien werden mit ".new" gekennzeichnet, um vorhandene Dateien nicht zu überschreiben

    local packageNoUpdateComps = {}
    local loadingInfo = ( UI and UI.loadingScreen ) and true or false -- Nur bei vorhandenem Ladebildschirm können Informationen über den Fortschritt ausgegeben werden

    loadingCanceled = false
    
    
    local subName = ""
    for rootName in moduleName:gmatch( "[^\\]+" ) do
        if subName == "" then 
            subName = rootName
        else
            subName = subName .. "\\" .. rootName  
        end
        
        --Bei CAD-Updates interessieren die übergeordneten Module nicht
        if cadUpdate then
            subName = moduleName
        end                     
        if compRel[subName] then
            for _, filePath in ipairs( compRel[subName] ) do
            
                if loadingCanceled then
                    wx.wxMessageBox( "Das Erstellen des Installationspaketes wurde abgebrochen! Der bisherige Fortschritt wurde gelöscht!", "Vorgang abgebrochen!" )
                    os.execute( "rmdir " .. targetPath )
                    return
                end
                
                if fileExists( useCvsComps and cvsRoot .. (filePath.target):gsub( "Root\\", "", 1 ) or buildRoot .. filePath.source ) then
                    local outFilePath = targetPath .. "\\" .. filePath.target:gsub( "Root\\", "", 1 )
                    local inFilePath = useCvsComps and cvsRoot .. (filePath.target):gsub( "Root\\", "", 1 ) or buildRoot .. filePath.source
                    
                    if loadingInfo then UI.loadingDlgAdditionalInfo:SetLabel( "Kopiere " .. inFilePath .."\nnach " .. outFilePath ) end
                        
                    local inFile = io.open( inFilePath, "rb" ) --rb = read binary
                    local inString = inFile:read( "*a" )
                    inFile:close()
                    
                    --'lfs.mkdir' kann nur Ordner in bestehenden Ordnern erzeugen / 'io.write()' kann Dateien nur in bestehenden Ordnern anlegen
                    -- Iterator über den gesamten Pfad zur neuen Komponente, der auf jedem Schritt einen Ordner anlegt
                    local fileName = targetPath:sub( 1, 3 ) --Festplattenbezeichnung vernachlässigen
                    for folderPart in( outFilePath ):sub( 4 ):gmatch( "[^\\]+" ) do
                        fileName = fileName .. "\\" .. folderPart
                        lfs.mkdir( fileName )
                    end
                    --in der letzten Itereation wird ein Ordner angelegt, obwohl es sich um den Dateinamen handelt
                    lfs.rmdir( fileName )
                    
                    local outFile
                    if calMajUpdate and table.contains( noUpdateComps, filePath.source ) then
                        table.insert( packageNoUpdateComps, filePath.target )
                        outFile = io.open( outFilePath .. ".new", "w+b" )
                    else
                        outFile = io.open( outFilePath, "w+b" )
                    end
                    
                    outFile:write( inString )
                    outFile:close()
                    
                    if loadingInfo then 
                        UI.loadingDlgGauge:SetValue( UI.loadingDlgGauge:GetValue() +1 )
                        UI.loadingDlgGauge:SetFocus( true ) --Damit Windows nicht denkt, dass das Fenster keine Rückmeldung mehr liefert
                    end
                else
                    io.stderr:write( "Dem Paket " .. subName .. " fehlt die Datei: " .. ( useCvsComps and cvsRoot .. (filePath.target):gsub( "Root\\", "", 1 ) or buildRoot .. filePath.source ) .. "\n" )
                end
            end
        end
        if cadUpdate then
            break --Es werden nur Komponenten des Moduls selbst, ohne die seiner übergeordneten, kopiert
                  --ohne dieses Break würde der Iterator, der Parent-Komponenten kopiert, weiterlaufen
        end
    end
    
    local readMeFile = io.open( folderPath .. "\\readMe.txt", "a" )
    
    if comments and comments[moduleName] then
        readMeFile:write( comments[moduleName] .. "\n" )
    end
    
    if packageNoUpdateComps and #packageNoUpdateComps > 0 then
        local updateCompNote = "Beim Zusammenstellen dieses Pakets wurden bestimmte Dateien umbenannt, damit sie\n" ..
            "beim Kopieren auf das Kundensystem die vorhandenen Dateien nicht überschreiben.\n"..
            "Sie können an der Dateiendung \".new\" erkannt werden. "..
            "Folgende Dateien sind betroffen:\n\n"
        if not updateCompNoteWasWritten then
            readMeFile:write( updateCompNote )
            updateCompNoteWasWritten = true
        end
        for key, fileName in pairs( packageNoUpdateComps ) do
            readMeFile:write( fileName .. ( key == #packageNoUpdateComps and "" or "\n" ) )
        end
    end
    
    readMeFile:close()
end  
    
function zipPackage( folderPath, targetPath, zippingToolPath, keepOriginal )

    -- Verpackt ein Installatonspaket (oder jeden anderen beliebigen Ordner)
    
    -- folderPath       string  Angabe des Pfades, wo sich das Paket befindet. Inklusive Paketname
    -- targetPath       string  Pfad, wo das Paket erstellt werden soll. Wird keine Angabe gemacht, wird es neben dem Ausgangsordner erstellt
    -- zippingToolPath  string  Installationspfad von "7z.exe"
    -- keepOriginal     bool    Standardmäßig wird das Original nach dem Verpacken entfernt. Hiermit kann es erhalten bleiben

    if targetPath == nil then
        targetPath = folderPath
    end

    if fileExists( zippingToolPath ) and zippingToolPath:find( "7z.exe" ) then
        if loadingInfo then UI.loadingDlgAdditionalInfo:SetLabel( "Installationspaket wird verpackt..." ) end
        local batScript = [[type NUL && "]] .. zippingToolPath .. [[" a "]] .. targetPath .. ".zip\" " 
        
        os.execute( batScript .. "\"" .. folderPath .. "\\*\"" )
        if not keepOriginal then os.execute( "rmdir /s /q \"" .. folderPath .. "\"" ) end
    else
        error( "Invalid Filepath for 7-zip: " .. zippingToolPath, 2 )
    end    
end

