FROM certbot/dns-cloudflare

ENTRYPOINT []

RUN mkdir -p ~/.secrets/certbot \
    && touch ~/.secrets/certbot/cloudflare.ini \
    && chmod go-rwx ~/.secrets/certbot/cloudflare.ini

CMD ["sh", "-c", "echo dns_cloudflare_api_token = $DNS_CLOUDFLARE_API_TOKEN > ~/.secrets/certbot/cloudflare.ini \
&& certbot certonly \
--agree-tos \
--keep-until-expiring \
--dns-cloudflare \
--dns-cloudflare-credentials ~/.secrets/certbot/cloudflare.ini \
-d $DOMAIN \
; echo Start sleep \
; sleep 86400"]
