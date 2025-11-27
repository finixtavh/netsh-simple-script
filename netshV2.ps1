$var = ""
$arg = "wlan"
$filepath = "c.txt"
$enableclipboard = $false
$charmultiplier = 40
$lineseparator = "=" * $charmultiplier + "`n"

while ($var -ne "exit") {
    Write-Host "$lineseparator"
    Write-Host "Copiar al portapapeles?= $enableclipboard `nRuta del archivo: $filepath`n $arg"
    $var = Read-Host "`n`nB = Buscar`nN = netsh`nexit = salir del bucle`nC = Config.`nA = Guardar todas las claves`njson = Convertir .txt a .json`n:: "

    if (-not (Test-Path $filepath)) {
        Set-Content -Path $filepath -Value $null
    }

    switch ($var.ToLower()) {
        "b" {
            netsh wlan show profile
        }

        "n" {
            $wifi = Read-Host "Red"
            $wifiprofiles = netsh wlan show profiles

            if ($wifiprofiles -match $wifi) {   
                Invoke-Expression "netsh $arg show profile name=`"$wifi`" key=clear" 
                $se = netsh $arg show profile name="$wifi" key=clear
                $p = ($se | Select-String "Contenido de la clave" | ForEach-Object {
                    ($_ -split ":")[1].Trim()
                })
                $ssid = ($se | Select-String "Nombre de SSID" | ForEach-Object {
                    ($_ -split ":")[1].Trim()
                })
                
                if ($ssid -and $p) {
                    $l = "$($ssid) : $($p)"
                    $l | Out-File -FilePath "$filepath" -Append
                    if ($enableclipboard) {
                        $p | Set-Clipboard
                    }
                } else {
                    Write-Host "content: $ssid ::: $p"
                }

            } else {
                Write-Host "no se encontro el perfil: $wifi`n"
            }
        }

        "c" {
            Write-Host "Configuracion:`n`n"
            $op = Read-Host "T = tipo de conexion (Wlan o Lan) || C = Copiar la contraseña al portapapeles (True o False) || F = Cambiar ruta del archivo"
            switch ($op.toLower()) {
                "t" {
                    if ($arg -eq "wlan") {
                        $config = Read-Host "Cambiar a LAN | S || N`n"
                        if ($config -eq "S" -or $config -eq "s") {
                            $arg = "lan"
                        }
                    } elseif ($arg -eq "lan") {
                        $config = Read-Host "Cambiar a WLAN | S || N`n"
                        if ($config -eq "S" -or $config -eq "s") {
                            $arg = "wlan"
                        }
                    Write-Host "Ahora es: $arg"
                    }
                }
                "c" {
                    if ($enableclipboard -eq $false){
                        $enableclipboard = $true

                    } elseif ($enableclipboard -eq $true) {
                        $enableclipboard = $false

                    }
                    Write-Host "Portapapeles: $enableclipboard"
                }
                "f" {
                    $filepath = Read-Host "Coloca la ruta:"
                }

                "m" {
                    while ($) {
                        $charmultiplier = Read-Host ": "
                        if ($charmultiplier -is [int]) {
                            break
                        }
                    } 
                }   
            }
        }

        "a" {
            $se = netsh $arg show profiles
            $ssids = ($se | Select-String "Perfil de todos los usuarios" | ForEach-Object {
                ($_ -split ":")[1].Trim()
            })

            foreach ($ssid in $ssids) {
                $se = netsh wlan show profile name="`"$ssid`"" key=clear
                $clave = ($se | Select-String "Contenido de la clave" | ForEach-Object {
                    ($_ -split ":")[1].Trim()
                })

                if ($clave) {
                    "$ssid : $clave" | Tee-Object -FilePath $filepath -Append
                }
            }
        }

        "cls" {
            Clear-Host
        }

        "json" {
            Python dicttojson.py $ssid $p
        }
        "exit" {

        }

        default {

            Write-Host "`n`nUsa b para buscar los detalles de la red, n para netsh`n"
        }
    }
}