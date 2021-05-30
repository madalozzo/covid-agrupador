NAME=vacinas
echo -e "\e[1;32m Script de microdados $NAME \e[0m"
cd entradas/$NAME
echo -e "\n\e[1;32m $(date)\n \e[0m"
TIMESTAMP=$(date +"%Y%m%d-%H%M")

echo -e "\e[1;33m Movendo microdados_vacinacao.csv microdados_vacinacao$TIMESTAMP.csv \e[0m"
mv microdados_vacinacao.csv microdados_vacinacao$TIMESTAMP.csv
echo -e "\e[1;32m Feito! \e[0m"

echo -e "\e[1;33m Baixando novo dataset... \e[0m"
wget https://data.brasil.io/dataset/covid19/microdados_vacinacao.csv.gz
echo -e "\e[1;32m Feito! \e[0m"

echo -e "\e[1;33m Descompactando... \e[0m"
7z x microdados_vacinacao.csv.gz
echo -e "\e[1;32m Feito! \e[0m"

echo -e "\e[1;33m Apagando gz... \e[0m"
rm -rf microdados_vacinacao.csv.gz
echo -e "\e[1;32m Feito! \e[0m"

echo -e "\e[1;33m Contando tamanho dos datasets... \e[0m"
ANTERIOR=$(cat microdados_vacinacao$TIMESTAMP.csv | wc -l)
ATUAL=$(cat  microdados_vacinacao.csv | wc -l)

echo -e "\e[1;33m Tamanho dataset anterior: \e[0m $ANTERIOR"
echo -e "\e[1;33m Tamanho dataset atual   : \e[0m $ATUAL"
DIFERENCA=$(echo "$ATUAL-$ANTERIOR" | bc)
echo -e "\e[1;33m Diferença: \e[0m $DIFERENCA"
echo ' '

cd ../..
echo -e "\e[1;33m Limpando agrupamentos anteriores... \e[0m"
rm -rf resultados/$NAME/*
echo -e "\e[1;32m Feito! \e[0m"

echo -e "\e[1;33m Gerando agrupamentos por munícipio \e[0m"
node index.js entradas/$NAME/microdados_vacinacao.csv paciente_codigo_ibge_municipio $NAME ','
echo -e "\e[1;32m Feito! \e[0m"

echo -e "\e[1;33m Total de agrupamentos criados: \e[0m"
ls -t resultados/$NAME/ | wc -l

echo -e "\n\e[1;32m $(date)\n Script finalizado! \e[0m"
