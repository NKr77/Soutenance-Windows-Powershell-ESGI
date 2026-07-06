$csvGroupes = Import-Csv -Path "supprimerGroupes.csv" -Header "nomGroupe" -Delimiter ","

foreach ($ligne in $csvGroupes) {
    Remove-LocalGroup -Name $ligne.nomGroupe
}