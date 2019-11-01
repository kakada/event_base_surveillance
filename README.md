# Run the example
Generate the certificates (only needed once):
```bash
docker-compose -f elastic/certificates/create-certs.yml run --rm create_certs
```
Start two Elasticsearch nodes configured for SSL/TLS:
```bash
docker-compose up -d
```

Access the Elasticsearch API over SSL/TLS using the bootstrapped password:
```bash
docker run --rm -v es_certs:/certs --network=es_default elasticsearch:7.4.1 curl --cacert /certs/ca/ca.crt -u elastic:PleaseChangeMe https://es01:9200
```

The elasticsearch-setup-passwords tool can also be used to generate random passwords for all users:
Windows users not running PowerShell will need to remove \ and join lines in the snippet below.

```bash
docker exec es01 /bin/bash -c "bin/elasticsearch-setup-passwords \
auto --batch \
-Expack.security.http.ssl.certificate=certificates/es01/es01.crt \
-Expack.security.http.ssl.certificate_authorities=certificates/ca/ca.crt \
-Expack.security.http.ssl.key=certificates/es01/es01.key \
--url https://localhost:9200"
```

# Tear everything downedit
To remove all the Docker resources created by the example, issue:
```bash
docker-compose down -v
```

For more detail on how to configure docker elasticsearch with ssl/tls, please visit https://www.elastic.co/guide/en/elasticsearch/reference/7.4/configuring-tls-docker.html
