$csvUsers = Import-Csv -Path "supprimerUtilisateurs.csv" -Header "nomUser"

foreach ($ligne in $csvUsers) {
    Remove-LocalUser -Name $ligne.nomUser
}