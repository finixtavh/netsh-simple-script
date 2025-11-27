$s = 0
while ($s -eq 1) {
    $var = Read-Host "B = Buscar || N = netsh || exit = salir del bucle"

    if ($var -eq "N" -or $var -eq "n"){
        $wifi = Read-Host "::"
        netsh wlan show profile name=$wifi key=clear

    } elseif ($var -eq "B" -or $var -eq "b") { 
        netsh wlan show profile
        
    } elseif ($var -eq "exit") { 
        $s = 1
    }
    Read-Host -prompt "Done"
}
