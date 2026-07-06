$fichierCsv = "deplacerUsersDansGroupes.csv"
$donnees = Import-Csv -Path $fichierCsv -Delimiter ";"

foreach ($ligne in $donnees) {
    Add-LocalGroupMember -Group $ligne.nomGroupe -Member $ligne.nomUser
}