# 1. Désactiver tous les utilisateurs des OU
Get-ADUser -Filter * -SearchBase 'OU=Direction,DC=ballereau,DC=lab' | Set-ADUser -Enabled $false -Verbose
Get-ADUser -Filter * -SearchBase 'OU=Comptabilite,DC=ballereau,DC=lab' | Set-ADUser -Enabled $false -Verbose
Get-ADUser -Filter * -SearchBase 'OU=Developpement,DC=ballereau,DC=lab' | Set-ADUser -Enabled $false -Verbose
Get-ADUser -Filter * -SearchBase 'OU=Usine,DC=ballereau,DC=lab' | Set-ADUser -Enabled $false -Verbose

# 2. Vérifier que les utilisateurs spécifiques ont bien été désactivés
$utilisateurs = 'shiny', 'sad', 'paris', 'mendes', 'Human'

foreach($nomUser in $utilisateurs) {
    $compte = Get-ADUser -Filter "Name -eq '$nomUser'" -Properties Enabled

    if ($compte.Enabled -eq $false) {
        Write-Host "Le compte de $nomUser a bien été désactivé."
    }
    else {
        Write-Host "Le compte de $nomUser est toujours actif."
    }
}

# 3. Supprimer tous les utilisateurs de l'OU Usine
Get-ADUser -Filter * -SearchBase 'OU=Usine,DC=ballereau,DC=lab' | Remove-ADUser -Confirm:$false -Verbose

# 4. Supprimer l'OU Usine
# 1) Retirer la protection
Set-ADOrganizationalUnit -Identity 'OU=Usine,DC=ballereau,DC=lab' `
  -ProtectedFromAccidentalDeletion $false -Verbose

# 2) Suppression de l'OU
Remove-ADOrganizationalUnit -Identity 'OU=Usine,DC=ballereau,DC=lab' -Confirm:$false -Verbose

# 5. Vérifier que l'OU n'apparait plus
if (Get-ADOrganizationalUnit -Filter "Name -eq 'Usine'") {
    Write-Host "L'OU Usine existe encore"
}
else {
    Write-Host "L'OU n'existe pas"
}
