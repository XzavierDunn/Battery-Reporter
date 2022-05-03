$charge = Get-CimInstance -ClassName Win32_Battery | Measure-Object -Property EstimatedChargeRemaining -Average | Select-Object -ExpandProperty Average
$batStat = (Get-WmiObject Win32_Battery).BatteryStatus

$headers = @{
    'Content-Type'='application/json'
}
$url = "<homeassistant-webhook-URL>"

if ($batStat -eq 1 and $charge -le 22) {
    $body = @{
        "message" = "turn on"
    }
    Invoke-WebRequest -Method 'Post' -Uri $url -Body ($body|ConvertTo-Json) -header $headers
}
elseif ($batStat -eq 2 and $charge -ge 80) {
    $body = @{
        "message" = "off"
    }
    Invoke-WebRequest -Method 'Post' -Uri $url -Body ($body|ConvertTo-Json) -header $headers
}
else {}
