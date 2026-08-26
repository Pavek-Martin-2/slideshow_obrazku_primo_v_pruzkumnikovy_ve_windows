cls

# slideshow fotky v adresari pomoci mpv

# test command "mpv"
$c1 ="mpv" # mpv nekde v ceste PATH ( %CD% v cmd.exe )
if (-not (Get-Command $c1 -ErrorAction SilentlyContinue )) {
Write-Warning "prikaz $c1 nenalezen" # nanesel prikaz "mpv"
# cestu do adresare z "mpv" dejte do global variable %PATH% !
sleep 5
exit 1
}

# PWD (%CD%)
[string] $pwd = Get-Location
$d_pwd = $pwd.Length
#echo $d_pwd
if ($d_pwd -ne 3 ){ $pwd+="\" } 

#Write-Host -ForegroundColor Yellow $pwd
#echo $pwd.GetTypeCode()

$pole_include = @("*.jpg", "*.png", "*.bmp", "*.jpeg") # tady se daj pridavat dalsi formaty potek (*.psd apod.)
$pole_out = @()
$pole_files = @()

#$pole_files += Get-ChildItem -Include $pole_include -Name
$pole_files += Get-ChildItem -Include $pole_include -Name # | Sort-Object sortovalo ale divne

$file_slideshow = "R:\" # na ramdisk, zde pripadne upravit napr. na "C:\Windows\temp\"
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
$vloz = $pwd
$vloz += $pole_files[$bb]
$pole_out += $vloz
echo $vloz
}

Remove-Item -Path $file_slideshow -ErrorAction SilentlyContinue
sleep -Milliseconds 300

Set-Content -Path $file_slideshow -Encoding Unicode -Value $pole_out
sleep -Milliseconds 300

# pocet vterin zobrazeni jednoho obrazku
# --image-display-duration=1 - FUNGUJE !!
$duration = "--image-display-duration="
$vterin = Read-Host -Prompt "zadej pocet vterin zobrazeni jednoho obrazku ( Enter=0.5 )"
# zadat napr. 2 a <enter> pro 2 vteriny pauzu mezi obrazkama slideshow

$duration += $vterin
#echo $duration
#sleep 3

if ($vterin -like ""){
$duration = "--image-display-duration=0.5" # default pauza slideshow 0.5 s
}

# mpv --fullscreen=yes/no
# --quiet - nabude zobrazovat cas videa u fotky + error...

#mpv --fs --osd-level=0 --image-display-duration=5 --loop-playlist=yes --playlist=slideshow.txt
#mpv "--fs" "--osd-level=0" "--image-display-duration=5" "--loop-playlist=yes" "--playlist=R:\slideshow.txt"
#mpv "--fs" "--osd-level=0" $duration "--loop-playlist=yes" "--playlist=R:\slideshow.txt"
#mpv "--fs" "--osd-level=0" $duration "--loop-playlist=yes" "--shuffle" "--playlist=R:\slideshow.txt"
mpv "--fullscreen=yes" "--quiet" "--osd-level=0" $duration "--loop-playlist=yes" "--playlist=R:\slideshow.txt"

Remove-Item -Path $file_slideshow -ErrorAction SilentlyContinue
sleep -Milliseconds 300

# PS: slideshow prohlizeni obrazku se force ukonci klavesou "q" jako quit :)
