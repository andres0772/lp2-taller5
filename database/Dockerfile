FROM postgres:16-alpine

copy init.sql /docker-entrypoint-initdb.d/

volume /var/lib/postgresql/data

expose 5432
