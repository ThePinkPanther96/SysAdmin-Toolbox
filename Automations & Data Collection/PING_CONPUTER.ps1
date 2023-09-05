[void] [System.Reflection.Assembly]::LoadWithPartialName(“System.Drawing”)
 [void] [System.Reflection.Assembly]::LoadWithPartialName(“System.Windows.Forms”) 

#begin to draw forms
 $Form = New-Object System.Windows.Forms.Form
 $Form.Text = “Computer Pinging Tool”
$Form.Size = New-Object System.Drawing.Size(300,150)
 $Form.StartPosition = “CenterScreen”

$Form.KeyPreview = $True
 $Form.Add_KeyDown({if ($_.KeyCode -eq “Enter”)
 {ping_computer}})
 $Form.Add_KeyDown({if ($_.KeyCode -eq “Escape”)
 {$Form.Close()}})

$label = New-Object System.Windows.Forms.Label
 $label.Location = New-Object System.Drawing.Size(5,5)
 $label.Size = New-Object System.Drawing.Size(240,30)
 $label.Text = “Enter a PC name or IP to test if it can respond to ping. Click ‘OK’ or hit ENTER to run…”
$Form.Controls.Add($label)

$textbox = New-Object System.Windows.Forms.TextBox
 $textbox.Location = New-Object System.Drawing.Size(5,40)
 $textbox.Size = New-Object System.Drawing.Size(120,20)
 $textbox.Text = “”
$Form.Controls.Add($textbox)

$OKButton = New-Object System.Windows.Forms.Button
 $OKButton.Location = New-Object System.Drawing.Size(140,38)
 $OKButton.Size = New-Object System.Drawing.Size(75,23)
 $OKButton.Text = “OK”
$OKButton.Add_Click({ping_computer_click})
 $Form.Controls.Add($OKButton)

$result_label = New-Object System.Windows.Forms.label
 $result_label.Location = New-Object System.Drawing.Size(5,65)
 $result_label.Size = New-Object System.Drawing.Size(240,30)
 $result_label.Text = “Results:”
$Form.Controls.Add($result_label)




function ping_computer {
 #ping the comptuer from $textbox.Text
 $computername=$textbox.Text
 write-host "pinging $computername"
 if ($computername -ne “”) {
if (Test-Connection $ComputerName -quiet -Count 2){

$result_label.Text = “$ComputerName has network connection”
write-host “$ComputerName has network connection”

}
else{
 write-host “$ComputerName does not have network connection”
$result_label.Text = “$ComputerName does not have network connection”
}
 }
else{
 $result_label.Text = “No comptuer name entered”
}
 }


<#function ping_computer {
 #ping the comptuer from $textbox.Text
 $computername=$textbox.Text
 if ($computername -ne “”) {
if (Test-Connection $ComputerName -quiet -Count 2){
 $result_label_results = New-Object System.Windows.Forms.label
 $result_label_results.Location = New-Object System.Drawing.Size(5,95)
 $result_label_results.Size = New-Object System.Drawing.Size(275,30)
 $result_label_results.Text = “$ComputerName has network connection”
$Form.Controls.Add($result_label_results)
 }
 else{
 $result_label_results = New-Object System.Windows.Forms.label
 $result_label_results.Location = New-Object System.Drawing.Size(5,95)
 $result_label_results.Size = New-Object System.Drawing.Size(275,30)
 $result_label_results.Text = “$ComputerName does not have network connection”
$Form.Controls.Add($result_label_results)

}
 }
 else{
 $result_label_results = New-Object System.Windows.Forms.label
 $result_label_results.Location = New-Object System.Drawing.Size(5,95)
 $result_label_results.Size = New-Object System.Drawing.Size(240,30)
 $result_label_results.Text = “No comptuer name entered”
$Form.Controls.Add($result_label_results)
 }

}
#>

#Show form
 $Form.Topmost = $True
 $Form.Add_Shown({$Form.Activate()})
 [void] $Form.ShowDialog()
