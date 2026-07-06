$csvGroupes = Import-Csv -Path "supprimerGroupes.csv" -Header "nomGroupe"

foreach ($ligne in $csvGroupes) {
    Remove-LocalGroup -Name $ligne.nomGroupe
}