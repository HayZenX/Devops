# Image de base légère
FROM alpine:3.18

# Installer curl et bash
RUN apk add --no-cache curl bash

# Créer un utilisateur non-root
RUN adduser -D curluser

# Passer à l'utilisateur non-root
USER curluser

ENTRYPOINT ["curl"]

CMD ["https://example.com"]
