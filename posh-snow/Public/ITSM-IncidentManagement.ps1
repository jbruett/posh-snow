Function Get-Incident {
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory=$false,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        [string]$Number,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
        [string[]]$Category,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
        [string[]]$AssignmentGroup,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$false)]
        [boolean]$Active = $true,
        [Parameter(Mandatory=$true)]
        [pscredential]$Credential
    )
    
    if($active){
        $queryString = "active=true&"  
    }else {
        $queryString = "active=false&"
    }

    $invalidparams = @('Active','Credential','Verbose','WhatIf','Debug','ErrorAction','WarningAction','InformationAction','ErrorVariable','WarningVariable','InformationVariable','OutVariable','OutBuffer','PipelineVariable')
    
    $queryparams = @()
    foreach($param in $PSBoundParameters.GetEnumerator()){
        if($param.key -notin $invalidparams){
            $queryparams += $param
        }
    }
    
    $paramcount = 0
    foreach($param in $queryparams){
        $key = $param.Key.ToString()
        $value = $param.Value.ToString()   
        
        if($key -eq 'assignmentgroup'){
            $key = 'assignment_group'
        }
        
        if($value -is [system.string[]]){
            $valuecount = 0
            foreach($item in $value){
                $compressedvalue += $item.tostring()

                if($valuecount -ne $value.length){
                    $compressedvalue += ','
                }
            }
            $value = $compressedvalue
        }
        [string]$value = $value.replace(' ','+')
        write-verbose $value
        $querystring += "$key=$value"
        
        $paramcount ++
        
        if($paramcount -ne $queryparams.Count){
            $querystring += '&'
        }
    }
    write-verbose "$querystring"
    $result = Invoke-RestMethod -Uri "https://dev14884.service-now.com/api/now/v2/table/incident?sysparm_query=$($queryString.ToLower())" -Credential $Credential -ContentType 'application/json'
    
    write-output $result 
}