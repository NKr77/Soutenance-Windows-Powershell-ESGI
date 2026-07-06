$fichierCsv = "deplacerUsersDansGroupes.csv"
$donnees = Import-Csv -Path $fichierCsv -Delimiter ";"

foreach ($ligne in $donnees) {
    Add-LocalGroupMember -Group $ligne.Groupe -Member $ligne.Utilisateur
}