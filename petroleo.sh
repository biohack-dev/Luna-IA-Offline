# Petróleo Brent do investing.com
url_petroleo="https://br.investing.com/commodities/brent-oil"

# Busca pelo preço usando padrões mais simples e robustos
brent=$(curl -s -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" "$url_petroleo" | grep -oP 'data-test="instrument-price-last"[^>]*>\K[^<]+' | head -1)

if [ -z "$brent" ]; then
    # Tentativa alternativa: buscar o número após "preço de Petróleo Brent hoje é"
    brent=$(curl -s -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" "$url_petroleo" | grep -oP 'preço de Petróleo Brent hoje é \K[\d,\.]+' | head -1)
fi

if [ -z "$brent" ]; then
    # Segunda alternativa: buscar o número após "cotação do Petróleo agora é"
    brent=$(curl -s -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" "$url_petroleo" | grep -oP 'cotação do Petróleo agora é \K[\d,\.]+' | head -1)
fi

if [ -z "$brent" ]; then
    # Terceira alternativa: buscar qualquer número com formato 000,00 próximo ao preço
    brent=$(curl -s -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" "$url_petroleo" | grep -oE '([0-9]{1,3}[,\.][0-9]{2})' | head -1)
fi

if [ -n "$brent" ]; then
    # Converter para formato numérico (trocar vírgula por ponto)
    brent=$(echo "$brent" | sed 's/\.//g' | sed 's/,/./')
    echo "Petroleo $""$brent"
else
    echo "0"
fi
