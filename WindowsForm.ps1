# Set up the form ===========================================================

 

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 

 

$objForm = New-Object System.Windows.Forms.Form 
$objForm.Text = "Microsoft Lync Server 2010 Practice Application"
$objForm.Size = New-Object System.Drawing.Size(1200,800) 
$objForm.StartPosition = "CenterScreen"
$objForm.KeyPreview = $True

 # Activate the form =========================================================

 

$objForm.Add_Shown({$objForm.Activate()})

[void] $objForm.ShowDialog()

 

