Import-Module $PSScriptRoot\..\Posh-Snow -Force

$username = 'admin'
$password = ConvertTo-SecureString -String 'Turb1n3!' -AsPlainText -Force
$credential = New-Object -TypeName pscredential -ArgumentList $username,$password

Describe "IT Service Management - Incident Management" {
  Context "Get-Incident" {
    It "Returns a single record provided a valid incident number" {        
        $result = Get-Incident -Number INC0000002 -Credential $credential -verbose
        $result.result.count | Should BeExactly 1
    }
    It "Returns a single record provided an inactive incident number and active set to false" {
        $result = Get-Incident -Number INC0000010 -Credential $credential -active:$false -verbose
        $result.result.count | Should BeExactly 1
    }
    It "Returns multiple records provided a valid Category and active set to false" {
        $result = Get-Incident -Category Network -Credential $credential -verbose
        $result.result.count | Should BeExactly 4
    }
    It "Returns only active records provided a category" {
        $result = Get-Incident -Category Network -Credential $credential -verbose
        $testresult = $true
        foreach($item in $result) {
            if($item.active -eq $false){
                $testresult = $false
            }
        }
        $testresult | Should Be $true
    }
    It "Returns multiple records provided valid assignment group" {
        $result = Get-Incident -AssignmentGroup 'ITIL User' -Credential $credential -verb
        $result.result.count | Should BeExactly 51
    }
  }
}