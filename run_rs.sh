NAME=rs
echo -e "\e[1;32m Script de microdados $NAME \e[0m"
cd entradas/$NAME
echo -e "\n\e[1;32m $(date)\n \e[0m"
TIMESTAMP=$(date +"%Y%m%d-%H%M")

echo -e "\e[1;33m Baixando novo dataset... \e[0m"
wget  --content-disposition https://ti.saude.rs.gov.br/covid19/download
echo -e "\e[1;32m Feito! \e[0m"

FILENAME=$(ls -t | head -1)
OLDFILENAME=$(ls -t | head -2 | tail -1)

echo -e "\e[1;33m Contando tamanho dos datasets... \e[0m"
ANTERIOR=$(cat $OLDFILENAME | wc -l)
ATUAL=$(cat $FILENAME | wc -l)

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
node index.js entradas/$NAME/$FILENAME 0 $NAME ';'
echo -e "\e[1;32m Feito! \e[0m"

echo -e "\e[1;33m Total de agrupamentos criados: \e[0m"
ls -t resultados/$NAME/ | wc -l

# echo -e "\e[1;33m Apagando antigo... \e[0m"
# rm -rf entradas/$NAME/$OLDFILENAME
# echo -e "\e[1;32m Feito! \e[0m"

echo -e "\n\e[1;32m $(date)\n Script finalizado! \e[0m"