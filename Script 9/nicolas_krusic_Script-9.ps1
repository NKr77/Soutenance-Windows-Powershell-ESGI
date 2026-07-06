$csvGroupes = Import-Csv -Path "supprimerGroupes.csv" -Delimiter ","

foreach ($ligne in $csvGroupes) {
    Remove-LocalGroup -Name $ligne.Name
}