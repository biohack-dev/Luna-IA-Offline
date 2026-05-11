#!/bin/bash

valor_gasolina=$(/etc/luna/gasolina.sh)
valor_petroleo=$(/etc/luna/petroleo.sh)
valor_dolar=$(/etc/luna/dolar.sh)
valor_moeda=$(/etc/luna/prata.sh)
valor_ouro=$(/etc/luna/ouro.sh)
tempo=$(cat ~/clima.json | jq ".data .temperature")

echo "Indaiatuba: "$tempo"ºC | "$valor_gasolina" | $valor_petroleo | "$valor_dolar" | " $valor_moeda " | "  $valor_ouro 
