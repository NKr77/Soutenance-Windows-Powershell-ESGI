# Creation de l'OU principale "laFiliale" si elle n'existe pas
if (Get-ADOrganizationalUnit -Filter "Name -eq 'laFiliale'" -SearchBase "DC=Monte,DC=lab" -ErrorAction SilentlyContinue) {
    Write-Host "L'OU laFiliale existe deja" -ForegroundColor Yellow
}
else {
    New-ADOrganizationalUnit -Name "laFiliale" -Path "DC=Monte,DC=lab" `
        -ProtectedFromAccidentalDeletion $true `
        -Description "OU principale de La Filiale" -verbose
    Write-Host "Creation de l'OU laFiliale" -ForegroundColor Green
}

# Import du CSV (OUs + sous-OUs a creer)
$listeOU = Import-Csv -Path "C:\Users\Fabio Monte\Documents\CSV\OUCreation.csv" -Delimiter ";"

# Boucle sur les OUs (Services, Production, Recherche, Ventes)
ForEach ($ligneOU in $listeOU) {

    # Verification existence avant creation
    if (Get-ADOrganizationalUnit -Filter "Name -eq '$($ligneOU.name)'" -SearchBase $ligneOU.path -ErrorAction SilentlyContinue) {
        Write-Host "L'OU $($ligneOU.name) existe deja" -ForegroundColor Yellow
    }
    else {
        New-ADOrganizationalUnit -Name $ligneOU.name -Path $ligneOU.path `
            -ProtectedFromAccidentalDeletion $true `
            -Description $ligneOU.name -verbose
        Write-Host "L'OU $($ligneOU.name) a ete creee" -ForegroundColor Green
    }

    # Boucle sur les sous-OUs, separees par ':' dans le CSV
    $tabSubOU = $ligneOU.namesubOU -split ":"

    ForEach ($subOU in $tabSubOU) {

        if (Get-ADOrganizationalUnit -Filter "Name -eq '$subOU'" -SearchBase $ligneOU.PathsubOU -ErrorAction SilentlyContinue) {
            Write-Host "L'OU $subOU existe deja" -ForegroundColor Yellow
        }
        else {
            New-ADOrganizationalUnit -Name $subOU -Path $ligneOU.PathsubOU `
                -ProtectedFromAccidentalDeletion $true `
                -Description $subOU -verbose
            Write-Host "L'OU $subOU a ete creee" -ForegroundColor Green
        }
    }

    # Petite pause entre chaque bloc
    Start-Sleep -Milliseconds 500
}
