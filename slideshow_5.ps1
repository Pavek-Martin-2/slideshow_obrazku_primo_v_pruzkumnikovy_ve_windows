#cls

# slideshow fotky v adresari pomoci mpv
# verze 5 pridava zadani poctu vterin jako prvn parametr
# bez parametu je default a pri chybe zadani nastavi take default 1 vterina

$duration = "--image-display-duration="
$default = "1" # default je jedna vterina cekani mezi fotkama pri slideshow, toto pripadne menit

# test command "mpv"
$c1 ="mpv" # mpv nekde v ceste PATH ( %CD% v cmd.exe )
if (-not (Get-Command $c1 -ErrorAction SilentlyContinue )) {
Write-Warning "prikaz $c1 nenalezen"
sleep 5
exit 1
}

# pwd
[string] $pwd = Get-Location
$d_pwd = $pwd.Length
#echo $d_pwd
if ($d_pwd -ne 3 ){ $pwd+="\" } 
# kdyz neni korenovi adresar, tak prida na konec jeste lomitko, pro sjednoceni, jediny "C:\" ho uz ma..
# takze paklize neni delka $d_pwd = 3, tak pridej lomitko

#Write-Host -ForegroundColor Yellow $pwd
#echo $pwd.GetTypeCode()

$pole_include = @("*.jpg", "*.png", "*.bmp", "*.jpeg") # tady se daj pridavat formaty
$pole_out = @()
$pole_files = @()

#$pole_files += Get-ChildItem -Include $pole_include -Name
$pole_files += Get-ChildItem -Include $pole_include -Name # | Sort-Object sortovalo ale divne

$file_slideshow = "R:\" # zde pripadne upravit napr. na "C:\Windows\temp\"
$file_slideshow += "slideshow.txt"
$d_pole_files = $pole_files.Length

if ($d_pole_files -eq 0 ){
Write-Warning "zadne obrazky v adresari" # neni co prohlizet, ostreni chyby
sleep 5
exit
}

$pripony = ""
for ( $aa = 0; $aa -le $pole_include.Length -1; $aa++ ) {
$pripony += $pole_include[$aa]
$pripony += " "
}

Write-Host -ForegroundColor Cyan $file_slideshow
Write-Host -ForegroundColor Yellow $pripony

for ( $bb = 0; $bb -le $d_pole_files -1; $bb++ ) {                                  
#echo $pole_files[$bb]
$vloz = $pwd
#$vloz += '"' # neslo
$vloz += $pole_files[$bb]
#$vloz += '"'
$pole_out += $vloz
echo $vloz
}

Remove-Item -Path $file_slideshow -ErrorAction SilentlyContinue
sleep -Milliseconds 300

Set-Content -Path $file_slideshow -Encoding Unicode -Value $pole_out
sleep -Milliseconds 300

# spracovani argumentu pocet vterin cekani mezi fotkama
# plus mohutne osetrni chyby vstupu 
if (
#$args.Count -ne 1 -or # pokud budou dva parametry misto jednoho tak priradi default
$args.Count -eq 0 -or # pokud budou dva parametry misto jednoho, bude druhej parametr ignorovat
$args[0] -eq $null -or # paklize parametr neni vubec (da default)
$args[0] -eq "" -or # paklize je parametr prazdny (da default)
$args[0] -like "*,*" -or # nesmi obsahovat carku, musi byt tecka (da default)
$args[0] -like "*-*" # pouze kladna cisla (da default)
# kdyz se napise treba - slideshow_5.exe 023 tak bude bez nuly jenom 23 (jedina "chyba")
) {
Write-Host -ForegroundColor Red "Default"
$duration += $default

} elseif ($args[0] -as [double]) {
# kontrola, zda je zadany parametr ciselný (projde jen s teckou)
$duration += [double]$args[0]

} else {
# pokud je to cokoliv jineho (napr. cisty text), prirad $default
Write-Host -ForegroundColor Red "Default"
$duration += $default
}

echo $duration
sleep 1
#exit

# mpv --fullscreen=yes/no
# --quiet - nabude zobrazovat cas videa u fotky + error...

#mpv --fs --osd-level=0 --image-display-duration=5 --loop-playlist=yes --playlist=slideshow.txt
#mpv "--fs" "--osd-level=0" "--image-display-duration=5" "--loop-playlist=yes" "--playlist=R:\slideshow.txt"
#mpv "--fs" "--osd-level=0" $duration "--loop-playlist=yes" "--playlist=R:\slideshow.txt"
#mpv "--fs" "--osd-level=0" $duration "--loop-playlist=yes" "--shuffle" "--playlist=R:\slideshow.txt"
mpv "--fullscreen=yes" "--quiet" "--osd-level=0" $duration "--loop-playlist=yes" "--playlist=R:\slideshow.txt"

Remove-Item -Path $file_slideshow -ErrorAction SilentlyContinue
sleep -Milliseconds 300

