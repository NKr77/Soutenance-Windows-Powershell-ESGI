# Import du CSV des utilisateurs de la filiale
$listeUsers = Import-Csv -Path "C:\Users\Fabio Monte\Documents\CSV\UsersLaFiliale.csv" -Delimiter ";"

# Boucle sur chaque utilisateur du CSV
ForEach ($user in $listeUsers) {

    $sam = "$($user.lastname).$($user.firstname)"
    $mail = "$($user.lastname)@Lafiliale.com"

    # Verification existence avant creation
    if (Get-ADUser -Filter "Name -eq '$($user.lastname)'" -SearchBase $user.pathuser -ErrorAction SilentlyContinue) {
        Write-Host "L'utilisateur $($user.lastname) existe deja" -ForegroundColor Yellow
    }
    else {
        New-ADUser -Name $user.lastname -GivenName $user.firstname -Surname $user.lastname `
            -SamAccountName $sam -UserPrincipalName $mail -EmailAddress $mail `
            -Path $user.pathuser -OfficePhone $user.phone `
            -Description "Fonction $($user.function)" `
            -AccountPassword (ConvertTo-SecureString -AsPlainText "Pa55W0rd" -Force) `
            -ChangePasswordAtLogon $true -Enabled $true -verbose

        Write-Host "L'utilisateur $($user.lastname) a ete cree" -ForegroundColor Green
    }

    # Petite pause entre chaque creation
    Start-Sleep -Milliseconds 500
}
