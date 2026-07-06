# Importation des groupes locaux depuis le fichier CSV
$GroupesLocaux = Import-Csv -Path ".\localGroups.csv" -Delimiter ";"

# Création des groupes
foreach($groupe in $GroupesLocaux) {
    $nom = $groupe.nomGroupe
    $description = $groupe.DescriptionGroupe

    # Création du groupe local
    New-LocalGroup -Name $nom -Description $description -Verbose
}
