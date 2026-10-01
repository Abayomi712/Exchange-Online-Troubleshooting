

# Exchange Online Message Trace Tool 🔍

When an important email goes missing, users often blame the IT department. This PowerShell script helps you find out **exactly** what happened to any email sent to your tenant within the last 10 days, completely eliminating the guesswork.

### What This Script Does (In Plain English)
* 🔐 **Securely Connects:** It opens a official Microsoft login window so you can safely sign in to your Exchange Online admin account.
* 🕵️‍♂️ **Tracks the Email:** It automatically searches through Microsoft's backend delivery logs for a specific email address over the last few days.
* 📊 **Creates a Report:** Instead of making you click through endless admin menus, it packages the delivery results into a clean, easy-to-read Excel/CSV file on your computer.

### How to Run It
1. Right-click the **Get-ExchangeMessageTraceReport.ps1** file above and download it to your computer.
2. Open PowerShell as an Administrator.
3. Run the script by typing its name and adding the email you want to trace. 
   *Example:*
   `.\Get-ExchangeMessageTraceReport.ps1 -RecipientEmail "user@yourdomain.com" -DaysLookback 3`
4. Look in your folder for a new file called `ExchangeMessageTraceReport.csv` to see your results!

---
*Safety Note: This script contains zero hardcoded passwords or private company data. It is completely safe to run in any standard Microsoft 365 environment.*

