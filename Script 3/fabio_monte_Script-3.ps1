# Import du CSV des utilisateurs a supprimer
$listeSupress = Import-Csv -Path "C:\Users\Fabio Monte\Documents\CSV\\usersToSupress.csv" -Delimiter ";"

# Boucle sur chaque ligne du CSV
ForEach ($user in $listeSupress) {

    # On ne traite que les lignes marquees 'O' (a supprimer)
    if ($user.aSupprimer -eq "O") {

        # Verification existence avant suppression
        try {
            $userTrouve = Get-ADUser -Filter "Name -eq '$($user.nom)'" -SearchBase $user.localisation -ErrorAction Stop
        }
        catch {
            $userTrouve = $null
        }

        if ($userTrouve) {
            Remove-ADUser -Identity "CN=$($user.nom),$($user.localisation)" -Confirm:$false -verbose
            Write-Host "L'utilisateur $($user.nom) a ete supprime" -ForegroundColor Green
        }
        else {
            Write-Host "L'utilisateur $($user.nom) introuvable" -ForegroundColor Red
        }
    }

    Start-Sleep -Milliseconds 500
}
