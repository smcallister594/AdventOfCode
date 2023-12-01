$ErrorActionPreference = 'Stop'
$inputs = Get-Content -Path .\input.txt

$numericMap = @{
    'one' = 1
    'two' = 2
    'three' = 3
    'four' = 4
    'five' = 5
    'six' = 6
    'seven' = 7
    'eight' = 8
    'nine' = 9
}

[int]$sums = 0
$finalResults = @()
foreach ($input in $inputs){
    Write-Host "-------------------------"
    Write-Host "Processing input '$input'"
    $matches = @()
    [string]$sum = ""

    # Search for textual keys
    foreach ($key in $numericMap.Keys) {
        $index = $input.LastIndexOf($key)

        while ($index -ge 0) {
            # Write-Host "Found '$key' at index $index"
            $matches += [PSCustomObject]@{
                Key = $key
                Value = $numericMap[$key]
                Index = $index
            }

            if ($index -eq 0) {
                break  # Break if the index is already at the start of the string
            }

            $index = $input.LastIndexOf($key, $index - 1)
        }
    }

    # Search for numeric values
    $numericKeys = $numericMap.Values | ForEach-Object { "$_" }
    foreach ($key in $numericKeys) {
        $index = $input.LastIndexOf($key)

        while ($index -ge 0) {
            # Write-Host "Found numeric value '$key' at index $index"
            $matches += [PSCustomObject]@{
                Key = $key
                Value = $key
                Index = $index
            }

            if ($index -eq 0) {
                break  # Break if the index is already at the start of the string
            }

            $index = $input.LastIndexOf($key, $index - 1)
        }
    }

    $sortedMatches = $matches | Sort-Object Index
    $finalResult = $sortedMatches.Value -join ''

    $numericCharacters = [regex]::Matches($string, '\d+').Value -join ''
    [string]$firstNumber = [regex]::Matches($finalResult, '\d')[0].Value
    [string]$lastNumber = [regex]::Matches($finalResult, '\d')[-1].Value
    $sum = $firstNumber + $lastNumber
    
    $finalResults += $finalResult
    $sums = $sums + $sum
}

Write-Host "Final sum: $sums"
