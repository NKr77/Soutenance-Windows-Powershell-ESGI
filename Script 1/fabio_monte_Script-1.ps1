# Script 1 - Creation de l'arborescence des OUs de "LaFiliale" (CSV + boucle)
# Modeles : CreationSousOU.ps1 (boucles) / ScriptCompletUserOU.ps1 (test existence) / fichiersCSV.ps1 (Import-Csv)
# /!\ Adapter DC=Monte,DC=lab a votre domaine

# Creation de l'OU principale "LaFiliale" si elle n'existe pas
if (Get-ADOrganizationalUnit -Filter "Name -eq 'LaFiliale'" -SearchBase "DC=Monte,DC=lab" -ErrorAction SilentlyContinue) {
    Write-Host "L'OU LaFiliale existe deja dans l'Active Directory." -ForegroundColor Yellow
}
else {
    New-ADOrganizationalUnit -Name "LaFiliale" -Path "DC=Monte,DC=lab" `
        -ProtectedFromAccidentalDeletion $true `
        -Description "OU principale de La Filiale" -verbose
    Write-Host "Creation de l'OU LaFiliale" -ForegroundColor Green
}

# Import du CSV (OUs + sous-OUs a creer)
$listeOU = Import-Csv -Path ".\OUCreation.csv" -Delimiter ";"

# Boucle sur les OUs de niveau 2 (Services, Production, Recherche, Ventes)
ForEach ($ligneOU in $listeOU) {

    # Verification existence avant creation
    if (Get-ADOrganizationalUnit -Filter "Name -eq '$($ligneOU.name)'" -SearchBase $ligneOU.path -ErrorAction SilentlyContinue) {
        Write-Host "L'OU $($ligneOU.name) existe deja (chemin : OU=$($ligneOU.name),$($ligneOU.path))" -ForegroundColor Yellow
    }
    else {
        New-ADOrganizationalUnit -Name $ligneOU.name -Path $ligneOU.path `
            -ProtectedFromAccidentalDeletion $true `
            -Description $ligneOU.name -verbose
        Write-Host "L'OU $($ligneOU.name) a ete creee (chemin : OU=$($ligneOU.name),$($ligneOU.path))" -ForegroundColor Green
    }

    # Boucle sur les sous-OUs (niveau 3), separees par ':' dans le CSV
    $tabSubOU = $ligneOU.namesubOU -split ":"

    ForEach ($subOU in $tabSubOU) {

        if (Get-ADOrganizationalUnit -Filter "Name -eq '$subOU'" -SearchBase $ligneOU.PathsubOU -ErrorAction SilentlyContinue) {
            Write-Host "L'OU $subOU existe deja (chemin : OU=$subOU,$($ligneOU.PathsubOU))" -ForegroundColor Yellow
        }
        else {
            New-ADOrganizationalUnit -Name $subOU -Path $ligneOU.PathsubOU `
                -ProtectedFromAccidentalDeletion $true `
                -Description $subOU -verbose
            Write-Host "L'OU $subOU a ete creee (chemin : OU=$subOU,$($ligneOU.PathsubOU))" -ForegroundColor Green
        }
    }

    # Petite pause entre chaque bloc
    Start-Sleep -Milliseconds 500
}
