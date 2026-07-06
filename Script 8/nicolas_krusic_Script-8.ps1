$csvUsers = Import-Csv -Path "supprimerUtilisateurs.csv" -Delimiter ","

foreach ($ligne in $csvUsers) {
    Remove-LocalUser -Name $ligne.Name
}