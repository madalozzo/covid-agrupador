# Agrupador

Recebe como entrada um csv e agrupa em arquivos por alguma propriedade escolhida.
Pode ser usado para separar um grande csv em dados agrupados por municipios, estados, regioes ou qualquer outra propriedade.


## uso:

>node index.js arquivo_de_entrada indice_do_agrupador nome_pasta_saída  
>ex:
>node index.js entradavacinacao/vacinacao.csv 16 vacinas

acompanha alguns scripts em bash com dados do RS, de SRAG e vacinas

obs.: Nos dados de SRAG, o primeiro arquivo do estado da Bahia, não contem todas as colunas completas, por isso o script run_vacinas.sh não funciona como esperado para separar por municípios.