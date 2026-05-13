Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile("e:\GODOT\AF-Game26\assets\MiniGame_Escovar\boca.png")
$bmp = new-object System.Drawing.Bitmap($img)
$color = $bmp.GetPixel(0,0)
Write-Output ("R: " + $color.R + " G: " + $color.G + " B: " + $color.B + " A: " + $color.A)
