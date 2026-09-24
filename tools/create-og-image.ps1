param(
  [string]$Source = (Join-Path $PSScriptRoot "..\assets\og-community-background.png"),
  [string]$Output = (Join-Path $PSScriptRoot "..\assets\innovatieplatform-facebook.png")
)

Add-Type -AssemblyName System.Drawing

$width = 1200
$height = 630
$canvas = New-Object System.Drawing.Bitmap($width, $height)
$canvas.SetResolution(96, 96)
$graphics = [System.Drawing.Graphics]::FromImage($canvas)
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

$sourcePath = (Resolve-Path $Source).ProviderPath
$sourceImage = [System.Drawing.Image]::FromFile($sourcePath)
$sourceRatio = $sourceImage.Width / $sourceImage.Height
$targetRatio = $width / $height
if ($sourceRatio -gt $targetRatio) {
  $cropHeight = $sourceImage.Height
  $cropWidth = [int]($cropHeight * $targetRatio)
  $cropX = [int](($sourceImage.Width - $cropWidth) / 2)
  $cropY = 0
} else {
  $cropWidth = $sourceImage.Width
  $cropHeight = [int]($cropWidth / $targetRatio)
  $cropX = 0
  $cropY = [int](($sourceImage.Height - $cropHeight) / 2)
}
$graphics.DrawImage(
  $sourceImage,
  (New-Object System.Drawing.Rectangle(0, 0, $width, $height)),
  $cropX,
  $cropY,
  $cropWidth,
  $cropHeight,
  [System.Drawing.GraphicsUnit]::Pixel
)

$ink = [System.Drawing.ColorTranslator]::FromHtml("#16372f")
$green = [System.Drawing.ColorTranslator]::FromHtml("#176f51")
$lime = [System.Drawing.ColorTranslator]::FromHtml("#dcef69")
$cream = [System.Drawing.ColorTranslator]::FromHtml("#fffdf8")
$muted = [System.Drawing.ColorTranslator]::FromHtml("#405a52")

# Preserve a calm, highly readable copy area across social-network crops.
$fadeRect = New-Object System.Drawing.Rectangle(0, 0, 690, $height)
$fadeBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
  $fadeRect,
  [System.Drawing.Color]::FromArgb(250, $cream),
  [System.Drawing.Color]::FromArgb(0, $cream),
  [System.Drawing.Drawing2D.LinearGradientMode]::Horizontal
)
$graphics.FillRectangle($fadeBrush, $fadeRect)

$brandFont = New-Object System.Drawing.Font("Segoe UI", 18, ([System.Drawing.FontStyle]::Bold), [System.Drawing.GraphicsUnit]::Pixel)
$eyebrowFont = New-Object System.Drawing.Font("Segoe UI", 15, ([System.Drawing.FontStyle]::Bold), [System.Drawing.GraphicsUnit]::Pixel)
$headlineFont = New-Object System.Drawing.Font("Segoe UI", 57, ([System.Drawing.FontStyle]::Bold), [System.Drawing.GraphicsUnit]::Pixel)
$bodyFont = New-Object System.Drawing.Font("Segoe UI", 22, ([System.Drawing.FontStyle]::Regular), [System.Drawing.GraphicsUnit]::Pixel)
$buttonFont = New-Object System.Drawing.Font("Segoe UI", 18, ([System.Drawing.FontStyle]::Bold), [System.Drawing.GraphicsUnit]::Pixel)
$inkBrush = New-Object System.Drawing.SolidBrush($ink)
$greenBrush = New-Object System.Drawing.SolidBrush($green)
$mutedBrush = New-Object System.Drawing.SolidBrush($muted)
$creamBrush = New-Object System.Drawing.SolidBrush($cream)
$limeBrush = New-Object System.Drawing.SolidBrush($lime)

# Compact brand marker.
$graphics.FillEllipse($greenBrush, 66, 45, 30, 30)
$graphics.FillEllipse($creamBrush, 76, 55, 10, 10)
$graphics.DrawString("innovatie", $brandFont, $inkBrush, 107, 49)
$innovationWidth = $graphics.MeasureString("innovatie", $brandFont).Width
$graphics.DrawString("platform", $brandFont, $greenBrush, 107 + $innovationWidth - 3, 49)

$graphics.FillRectangle($greenBrush, 66, 119, 31, 3)
$graphics.DrawString("ONDERNEMEN MET LOKALE IMPACT", $eyebrowFont, $greenBrush, 110, 110)

$graphics.DrawString("Word jij het", $headlineFont, $inkBrush, 62, 157)
$graphics.DrawString("digitale hart", $headlineFont, $greenBrush, 62, 220)
$graphics.FillRectangle($limeBrush, 65, 281, 312, 9)
$graphics.DrawString("van jouw", $headlineFont, $inkBrush, 62, 292)
$graphics.DrawString("gemeente?", $headlineFont, $inkBrush, 62, 355)

$graphics.DrawString("Bouw de centrale plek voor alles wat lokaal leeft.", $bodyFont, $mutedBrush, 66, 441)

$buttonPath = New-Object System.Drawing.Drawing2D.GraphicsPath
$buttonRect = New-Object System.Drawing.Rectangle(66, 500, 282, 58)
$radius = 12
$buttonPath.AddArc($buttonRect.X, $buttonRect.Y, $radius, $radius, 180, 90)
$buttonPath.AddArc($buttonRect.Right - $radius, $buttonRect.Y, $radius, $radius, 270, 90)
$buttonPath.AddArc($buttonRect.Right - $radius, $buttonRect.Bottom - $radius, $radius, $radius, 0, 90)
$buttonPath.AddArc($buttonRect.X, $buttonRect.Bottom - $radius, $radius, $radius, 90, 90)
$buttonPath.CloseFigure()
$graphics.FillPath($greenBrush, $buttonPath)
$graphics.DrawString("Ontdek jouw gemeente", $buttonFont, $creamBrush, 105, 517)

$sourceImage.Dispose()
$graphics.Dispose()
$canvas.Save($Output, [System.Drawing.Imaging.ImageFormat]::Png)
$canvas.Dispose()

Write-Output "Open Graph image created: $Output"
