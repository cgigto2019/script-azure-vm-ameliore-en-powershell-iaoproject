Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Data Entry Form'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(75,120)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = 'OK'
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(150,120)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = 'Cancel'
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'nombre de VM:'
$form.Controls.Add($label)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,40)
$textBox.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBox)

$form.Topmost = $true

$form.Add_Shown({$textBox.Select()})
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $n_bVM = $textBox.Text
    $nb_VM
}



#New-AzResourceGroup -Name TutorialResources -Location francecentral
$cred = Get-Credential -Message "Enter a username and password for yours virtuals machines." "jack"



for ($i=1; $i -le $nb_VM ; $i++ )
{
    $vm3 = @{
    ResourceGroupName = 'TutorialResources'
    Name = "VM" + $i
    Location = 'francecentral'
    ImageName = 'UbuntuLTS'
    PublicIpAddressName = 'tutorialPublicIp'
    Credential = $cred
    OpenPorts = 3389,22
    }
    $newVM1 = New-AzVM @vmParams
    echo $vm3.Name
    $newVM1
}
# Vérifications

#$pass = "hello_world" | convertto-securestring                                                         
#$mycred = new-object -typename System.Management.Automation.PSCredential -argumentlist "jack", $pass                
#get-ftp -server 10.0.1.1 -cred $mycred -list *.vb

