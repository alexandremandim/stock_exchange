# Stock Exchange

## Distributed system that simulate buy/sell stocks

### This project was developed in the context of program Distributed Systems Paradigms @ uminho

Dropwizard paths:

List all companies:
curl 127.0.0.1:8080/empresas/

Add new company to directory:
curl -X POST "127.0.0.1:8080/empresas?name="empresa1"&info="empresa fixe"

Get all history
curl 127.0.0.1:8080/historicos/
