
# Construire l'image Docker
sudo docker build -t dev-app -f 4-dev-app.dockerfile broken-app/

# Lancer le conteneur en détaché (ctrl+c pour arrêter si tu veux)
sudo docker run --rm -p 3000:3000 dev-app

# Exemple de test : curl http://localhost:3000
