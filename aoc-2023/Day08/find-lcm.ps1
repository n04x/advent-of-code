Function Find-LCM {
    PARAM (
    [Parameter(ValueFromPipeline=$true)]
    # [System.String]$String,
    # [System.Double]$Number,
    [System.Array]$Values
    )
    $array=@()
    [System.Double]$product=1
    # $Numbers = $String.Split(",")
    $Numbers = $Values
    foreach ($Number in $Numbers) {
        $sqrt=[math]::sqrt($number)
        $Factor=2
        $count=0
        while ( ($Number % $Factor) -eq 0) {
            $count+=1
            $Number=$Number/$Factor
            if (($array | Where-Object {$_ -eq $Factor}).count -lt $count) {
                $array+=$Factor
            }
        }
        $count=0
        $Factor=3
        while ($Factor -le $sqrt) {
            while ( ($Number % $Factor) -eq 0) {
                $count+=1
                $Number=$Number/$Factor
                if (($array | Where-Object {$_ -eq $Factor}).count -lt $count) {
                    $array+=$Factor
                    }
                }           
            $Factor+=2
            $count=0
        }
        if ($array -notcontains $Number) {
            $array+=$Number
        }
    }
    foreach($arra in $array) {$product = $product * $arra}
    $product
}