# BIBILIOTHEQUE
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# CREATION DE LA BOITE DE DIALOGUE
$form = New-Object System.Windows.Forms.Form
$form.Text = '[Skodo]GESTION DES VMs AZURE'
$form.Size = New-Object System.Drawing.Size(400,300)
$form.StartPosition = 'CenterScreen'

# ==============-> BOUTON OK
$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(160,220)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = 'OK'
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)

#==============->BOUTON CANCEL
$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(250,220)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = 'Cancel'
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)



# RESOURCE GROUP MANAGEMENT
$label_GR = New-Object System.Windows.Forms.Label
$label_GR.Location = New-Object System.Drawing.Point(10,80)
$label_GR.Size = New-Object System.Drawing.Size(280,20)
$label_GR.Text = 'CHOISIR DES GROUPRESOURCES:'
$form.Controls.Add($label_GR)

$list_ResourceGroupName= Get-AzResourceGroup  | Select-Object ResourceGroupName

$liste1 = New-Object System.Windows.Forms.Combobox
$liste1.Location = New-Object Drawing.Point (10,100)
$liste1.Size = New-Object System.Drawing.Size(200,300)
$liste1.DropDownStyle = "DropDownList"
 foreach ($elem in $list_ResourceGroupName)
 {
 $liste1.Items.Add($elem.ResourceGroupName)
 }
$liste1.SelectedIndex = 0

$label_GR_option = New-Object System.Windows.Forms.Label
$label_GR_option.Location = New-Object System.Drawing.Point(10,130)
$label_GR_option.Size = New-Object System.Drawing.Size(280,20)
$label_GR_option.Text = 'ou bien créer une nouvelle ResourceGroupName:'
$form.Controls.Add($label_GR_option)

$textBox_newRGN = New-Object System.Windows.Forms.TextBox
$textBox_newRGN.Location = New-Object System.Drawing.Point(10,150)
$textBox_newRGN.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBox_newRGN)

#Attache le contrôle à la fenêtre
$form.controls.add($liste1)

# ========->   INPUT DU NOMBRE DE VM
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'nombre de VM:'
$form.Controls.Add($label)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,40)
$textBox.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBox)


# ========= -> Ecriture de la fenêtre
$form.Topmost = $true
$form.Add_Shown({$textBox.Select()})
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $nb_VM = $textBox.Text
    #$nb_VM
    $Resource_target=$liste1.SelectedItem
    $Resource_new=$textBox_newRGN.Text    

    if(($Resource_new -ne "") -or ($Resource_new -eq $null))
    {
    $Resource_target=$Resource_new
    New-AzResourceGroup -Name $Resource_target -Location francecentral
    }
    else
    {
    $Resource_target=$liste1.SelectedItem
    }
}
Write-Host $Resource_target

#CREATION DE RESOURCEGROUP
#New-AzResourceGroup -Name TutorialResources -Location francecentral
#$cred = Get-Credential -Message "Enter a username and password for yours virtuals machines." "jack"
$password = ConvertTo-SecureString "AZERTY1234$!" -AsPlainText -Force
$user="jack"
#$secureStringPwd = $password | ConvertTo-SecureString -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential -ArgumentList ($user, $password)


for ($i=1; $i -le $nb_VM ; $i++ )
{
    $vm3 = @{
    ResourceGroupName =$Resource_target.ToString()
    Name = "VM" + $i +"o"
    Location = 'francecentral'
    ImageName = 'UbuntuLTS'
    #PublicIpAddressName = 'tutorialPublicIp'+$i
    Credential = $creds
    OpenPorts = 3389,22
    }
    $newVM1 = New-AzVM @vm3
    echo $vm3.Name
    $newVM1
}
# Vérifications

#$pass = "hello_world" | convertto-securestring                                                         
#$mycred = new-object -typename System.Management.Automation.PSCredential -argumentlist "jack", $pass                
#get-ftp -server 10.0.1.1 -cred $mycred -list *.vb

