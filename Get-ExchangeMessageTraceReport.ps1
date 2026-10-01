<#
.SYNOPSIS
    Automated Exchange Online Message Trace Tool.
.DESCRIPTION
    This script connects to Exchange Online and queries the message logs 
    for a specific recipient over a defined period of days (up to 10 days). 
    It exports the matching data to a clean CSV report.
.EXAMPLE
    .\Get-ExchangeMessageTraceReport.ps1 -RecipientEmail "user@yourdomain.com" -DaysLookback 3
#>

param (
    [Parameter(Mandatory = $true, HelpMessage = "Enter the email address to track.")]
    [string]$RecipientEmail,

    [Parameter(Mandatory = $false)]
    [int]$DaysLookback = 2,

    [Parameter(Mandatory = $false)]
    [string]$ExportPath = ".\ExchangeMessageTraceReport.csv"
)

# 1. Ensure the modern ExchangeOnlineManagement module is installed
if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
    Write-Host "ExchangeOnlineManagement module not found. Installing now..." -ForegroundColor Yellow
    Install-Module -Name ExchangeOnlineManagement -Force -AllowClobber -Scope CurrentUser
}

# 2. Set up safety parameters for date ranges (Exchange Online limits standard trace to 10 days)
if ($DaysLookback -gt 10) {
    Write-Error "Standard Message Trace is limited to the past 10 days. Adjusting search lookback to 10 days."
    $DaysLookback = 10
}

$StartDate = (Get-Date).AddDays(-$DaysLookback)
$EndDate = Get-Date

Write-Host "Target Recipient: $RecipientEmail" -ForegroundColor Cyan
Write-Host "Timeframe: Checking logs from $StartDate to $EndDate" -ForegroundColor Cyan

# 3. Connect to your Exchange Online Environment safely via interactive login prompt
Write-Host "Connecting to Exchange Online... Please sign in when prompted." -ForegroundColor Yellow
Connect-ExchangeOnline -UserPrincipalName $Env:USERNAME

# 4. Execute the Message Trace command using modern V2 cmdlets
try {
    Write-Host "Querying Exchange logs..." -ForegroundColor Yellow
    
    $TraceResults = Get-MessageTraceV2 -RecipientAddress $RecipientEmail -StartDate $StartDate -EndDate $EndDate
    
    if ($null -eq $TraceResults) {
        Write-Host "No email messages found matching those criteria within the past $DaysLookback days." -ForegroundColor Red
    } else {
        # 5. Export results cleanly to a safe CSV file format
        $TraceResults | Select-Object ReceivedDateTime, SenderAddress, RecipientAddress, Subject, Status, MessageId | 
            Export-Csv -Path $ExportPath -NoTypeInformation
            
        Write-Host "Success! Your message trace report has been saved to: $ExportPath" -ForegroundColor Green
    }
}
catch {
    Write-Error "An error occurred while tracking the message: $_"
}
finally {
    # Always disconnect the remote PowerShell session securely
    Disconnect-ExchangeOnline -Confirm:$false
    Write-Host "Disconnected safely from Exchange Online." -ForegroundColor Cyan
}
