cls

# vytvoreni zastupce souboru + nastaveni vlastnosti zastupce

Set-PSDebug -Strict # jakakoliv nedeklarovana promenna pri jejim zavolani udela chybu skriptu

Remove-Variable cesta_adresar, cesta_adresar_2 -ErrorAction SilentlyContinue
$cesta_adresar = Read-Host "zadej cestu do adresare z fotkama pro slideshow "

if (-not ( Test-Path $cesta_adresar )) { 
Write-Warning "tento adresar neexistuje"
sleep 3
exit
}

# pokud by bylo na konci lomitko tak ho urizne
if ( $cesta_adresar[-1] -like "\") {
#echo "uriznu lomitko na konci"
$cesta_adresar_2 = $cesta_adresar.Substring(0, $cesta_adresar.Length -1)
}else{
$cesta_adresar_2 = $cesta_adresar
}

Write-Host -ForegroundColor Cyan $cesta_adresar_2
#echo $cesta_adresar_2
#exit

# pozpatku hleda prvni lomitko v $cesta_adresar_2 a vytvori nazev zastupce
$d_cesta_adresar_2 = $cesta_adresar_2.Length
#echo $d_cesta_adresar_2

$nalezeno = 0

for ( $aa = $d_cesta_adresar_2 -1; $aa -ge 0; $aa-- ) {
$znak = $cesta_adresar_2.Substring($aa,1)
#echo "$aa $znak"
if ( $znak -like "\" ){
$nalezeno = $aa
break
}
}

if ( $nalezeno -eq 0 ){
Write-Host "chyba"
sleep 3
exit
}

$nalezeno ++
#echo $nalezeno
$nazev_zastupce = $cesta_adresar_2.Substring($nalezeno, ($d_cesta_adresar_2 - $nalezeno))
Write-Host -ForegroundColor Yellow $nazev_zastupce


$targetPath = "C:\tools\slideshow "  # tady pripadne menit cestu k souboru "slideshow.exe"

$pocet_vterin = Read-Host "zadej pocet vterin cekani pro slideshow fotek "
$targetPath = [string] $pocet_vterin

if ($pocet_vterin.Length -eq 0 ){
Write-Warning "chyba zadani vterin"
sleep 3
exit
}

$shortcutPath = "slideshow $nazev_zastupce - $targetPath sec. - zástupce.lnk" # nazev zastupce videa
Remove-Item -Path $shortcutPath -ErrorAction SilentlyContinue
sleep -Milliseconds 300

$exec = "C:\tools\slideshow.exe"

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
$shortcut.Description = "$n" # komentar zastupce programu
$shortcut.WorkingDirectory = $cesta_adresar_2 # spustit v
$shortcut.IconLocation = $ikona_mpv # ikona zastupce (ikonu si vezme z mpv.exe )
$shortcut.WindowStyle = $okno[2] # [0]=minimalizovane; [1]=normalni; [2]=maximalizovane okno konzole

if ( $hot.Length -ne 0 ){ # pokud nebude pouze, $hot = ""
$shortcut.Hotkey = $hot # klavesova zkratka spusteni zastupce
}

# ulozeni souboru zastupce *.lnk
$shortcut.Save()

Write-Host -ForegroundColor Yellow "by vytvoren novy soubor " -NoNewline
Write-Host -ForegroundColor Green '"' -NoNewline
Write-Host -ForegroundColor Green $shortcutPath -NoNewline
Write-Host -ForegroundColor Green '"'
sleep 3
