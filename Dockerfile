FROM galeksandrp/travistest:docker-pg1c-12
CMD ["bash", "-c", "((sleep 30 \
    && psql -c \"ALTER USER postgres PASSWORD '$POSTGRES_PASSWORD';\" \
    && (createuser --no-password $POSTGRES_USER \
      ; psql -c \"ALTER USER $POSTGRES_USER PASSWORD '$POSTGRES_USER_PASSWORD';\") \
      && createdb --owner=$POSTGRES_USER $POSTGRES_DB) &) \
  && exec /opt/pgpro/1c-12/bin/postgres -D /var/lib/pgpro/1c-12/data"]
