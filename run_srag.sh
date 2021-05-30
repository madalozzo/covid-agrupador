NAME=srag
echo -e "\e[1;32m Script de microdados $NAME \e[0m"
cd entradas/$NAME
echo -e "\n\e[1;32m $(date)\n \e[0m"

echo -e "\e[1;33m Contando tamanho dos datasets antigos... \e[0m"
ANTERIOR_LINHAS=$(cat * | wc -l)
ANTERIOR_ARQUIVOS=$(ls -t | wc -l)
echo -e "\e[1;32m Feito! \e[0m"

echo -e "\e[1;33m Apagando datasets antigos \e[0m"
rm -rf dados-*
echo -e "\e[1;32m Feito! \e[0m"

function baixa () {
	ESTADO=$1
  	wget https://s3-sa-east-1.amazonaws.com/ckan.saude.gov.br/dados-$ESTADO.csv
	i=1
	while true; do
		wget https://s3-sa-east-1.amazonaws.com/ckan.saude.gov.br/dados-$ESTADO-$i.csv
		if [[ -f "dados-$ESTADO-$i.csv" ]]; then
			i=$[$i+1]
		else
			break;
		fi
	done
}

echo -e "\e[1;33m Baixando datasets novos... \e[0m"
baixa 'ac'
baixa 'al'
baixa 'am'
baixa 'ap'
baixa 'ba'
baixa 'ce'
baixa 'df'
baixa 'es'
baixa 'go'
baixa 'ma'
baixa 'mg'
baixa 'ms'
baixa 'mt'
baixa 'pa'
baixa 'pb'
baixa 'pe'
baixa 'pi'
baixa 'pr'
baixa 'rj'
baixa 'rn'
baixa 'ro'
baixa 'rr'
baixa 'rs'
baixa 'sc'
baixa 'se'
baixa 'sp'
baixa 'to'
echo -e "\e[1;32m Feito! \e[0m"

echo -e "\e[1;33m Contando tamanho dos datasets novos... \e[0m"
ATUAL_LINHAS=$(cat * | wc -l)
ATUAL_ARQUIVOS=$(ls -t | wc -l)
echo -e "\e[1;32m Feito! \e[0m"

echo -e "\e[1;33m Quantidade arquivos anterior: \e[0m $ANTERIOR_ARQUIVOS"
echo -e "\e[1;33m Quantidade arquivos atual   : \e[0m $ATUAL_ARQUIVOS"
echo -e "\e[1;33m Tamanho dataset anterior: \e[0m $ANTERIOR_LINHAS"
echo -e "\e[1;33m Tamanho dataset atual   : \e[0m $ATUAL_LINHAS"
DIFERENCA=$(echo "$ATUAL_LINHAS-$ANTERIOR_LINHAS" | bc)
echo -e "\e[1;33m Diferença: \e[0m $DIFERENCA"
echo ' '

cd ../..
echo -e "\e[1;33m Limpando agrupamentos anteriores... \e[0m"
rm -rf resultados/$NAME/*
echo -e "\e[1;32m Feito! \e[0m"


function agrupa () {
	ESTADO=$1
	node index.js entradas/$NAME/dados-$ESTADO.csv 'municipioNotificacaoIBGE' $NAME ';'
	
	i=1
	while true; do
		if [[ -f "entradas/$NAME/dados-$ESTADO-$i.csv" ]]; then
			node index.js entradas/$NAME/dados-$ESTADO-$i.csv 'municipioNotificacaoIBGE' $NAME ';'
			i=$[$i+1]
		else
			break;
		fi
	done
}
echo -e "\e[1;33m Gerando agrupamentos por munícipio \e[0m"
agrupa 'ac'
agrupa 'al'
agrupa 'am'
agrupa 'ap'
agrupa 'ba'
agrupa 'ce'
agrupa 'df'
agrupa 'es'
agrupa 'go'
agrupa 'ma'
agrupa 'mg'
agrupa 'ms'
agrupa 'mt'
agrupa 'pa'
agrupa 'pb'
agrupa 'pe'
agrupa 'pi'
agrupa 'pr'
agrupa 'rj'
agrupa 'rn'
agrupa 'ro'
agrupa 'rr'
agrupa 'rs'
agrupa 'sc'
agrupa 'se'
agrupa 'sp'
agrupa 'to'
echo -e "\e[1;32m Feito! \e[0m"

echo -e "\e[1;33m Total de agrupamentos criados: \e[0m"
ls -t resultados/$NAME/ | wc -l

echo -e "\n\e[1;32m $(date)\n Script finalizado! \e[0m"