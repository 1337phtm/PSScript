# Adresse Gmail à pré-remplir

$email = Read-Host "Enter @mail "

# URL de connexion avec email pré-rempli
$url = "https://accounts.google.com/signin/v2/identifier?hl=fr&flowName=GlifWebSignIn&flowEntry=ServiceLogin&Email=$email"

# Ouvre dans le navigateur par défaut

Start-Process $url
