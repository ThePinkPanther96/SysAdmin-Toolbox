# Define the list of target endpoints
$endpoints = @(
    "COMPUTER-1","COMPUTER-2","COMPUTER-3","COMPUTER-4",
    "COMPUTER-5","COMPUTER-6","COMPUTER-7","COMPUTER-8",
    "COMPUTER-9","AND-SO-ON","AND-SO-ON"
)

# Define the path to the PowerShell script file on the local machine
$scriptPath = "C:\Path\To\Deployment\Script" # Place here the script to execute.

# Loop through each endpoint and execute the script file from the local machine
foreach ($endpoint in $endpoints) {
    Write-Host "Executing script on $endpoint"

    try {
        # Create a new remote PowerShell session
        $session = New-PSSession -ComputerName $endpoint -ErrorAction Stop

        # Invoke the script from the local machine on the remote endpoint
        Invoke-Command -Session $session -FilePath $scriptPath

        # Check the exit code of the script execution
        if ($?) {
            Write-Host "Script executed successfully on $endpoint" -ForegroundColor "Green"
        } else {
            Write-Host "Failed to execute script on $endpoint"
        }
    } 
    catch {
        Write-Host "Failed to establish a session with $endpoint : $_" -ForegroundColor "Red"
        Write-Host "Moving to the next machine."
        continue
    } 
    finally {
        # Close the remote PowerShell session if it was created successfully
        if ($session) {
            Remove-PSSession -Session $session
        }
    }
}
