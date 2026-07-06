# Importation des utilisateurs locaux depuis le fichier CSV
$UsersLocaux = Import-Csv -Path ".\localUsers.csv" -Delimiter ";"

# Création de chaque utilisateur
foreach($user in $UsersLocaux) {
    # Récupération des informations de l'utilisateur
    $nom = $user.nomUser
    $motDePasse = $user.password
    $nomComplet = $user.fullName
    $description = $user.description

    $UserPassword = ConvertTo-SecureString -AsPlainText $motDePasse -Force

    # Création de l'utilisateur local
    New-LocalUser -Name $nom -Password $UserPassword -FullName $nomComplet -Description $description -Verbose
}
