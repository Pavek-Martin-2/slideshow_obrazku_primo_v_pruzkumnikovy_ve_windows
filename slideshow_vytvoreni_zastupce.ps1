cls

# vytvoreni zastupce souboru + nastaveni vlastnosti zastupce

Set-PSDebug -Strict # jakakoliv nedeklarovana promenna pri jejim zavolani udela chybu skriptu

#$targetPath = "10" # zde manit pocet vterin slideshow mezi fotkama

$targetPath = Read-Host "zadej pocet vterin pro slideshow "
echo $targetPath

$shortcutPath = "slideshow.exe – zástupce $targetPath sekund.lnk" # nazev zastupce videa
Remove-Item -Path $shortcutPath -ErrorAction SilentlyContinue
sleep -Milliseconds 300

$exec = "C:\tools\slideshow.exe" # tady editovat

$ikona_mpv = "C:\Program Files (x86)\mpv-x86_64\mpv.exe,0" # ikona programu mpv.exe (0) ma jenom jednu ikonu
$okno = @("7","1","3") # [0]=minimalizovane; [1]=normalni; [2]=maximalizovane okno konzole
$hot = "" # pradnej strings neudela polozku "Žádné" jako je to bezne ale udela prazdne policko takze musi tam bejt $NULL

# vytvoreni COM objektu
$WshShell = New-Object -ComObject WScript.Shell
# vytvoreni zástupce
$shortcut = $WshShell.CreateShortcut($shortcutPath)


# nastaveni vlastnosti zastupce programu
$shortcut.TargetPath = $exec # nastavení cíle v tomto pripade ale mpvs.bat vcetne cele cesty
$shortcut.Arguments = $targetPath # parametry ktere se predaji programu pri spusteni
$shortcut.Description = "slideshow.exe spusti s $targetPath ti mezerou mezi fotkama" # komentar zastupce programu
$shortcut.WorkingDirectory = "" # spustit v
$shortcut.IconLocation = $ikona_mpv # ikona zastupce (ikonu si vezme z mpv.exe )
$shortcut.WindowStyle = $okno[1] # [0]=minimalizovane; [1]=normalni; [2]=maximalizovane okno konzole

if ( $hot.Length -ne 0 ){ # pokud nebude pouze, $hot = ""
$shortcut.Hotkey = $hot # klavesova zkratka spusteni zastupce
}

# ulozeni souboru zastupce *.lnk
$shortcut.Save()

Write-Host -ForegroundColor Yellow "by vytvoren novy soubor " -NoNewline
Write-Host -ForegroundColor Green '"' -NoNewline
Write-Host -ForegroundColor Green $shortcutPath -NoNewline
Write-Host -ForegroundColor Green '"'
sleep 1

