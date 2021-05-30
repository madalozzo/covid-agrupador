/*
Saulo Madalozzo
saulo.madalozzo.it
saulo@madalozzo.it
04/2021
*/

var params = process.argv.slice(2);
const lineReader = require('line-reader');

var arquivo = params[0]
var indexCodigo = params[1]
var destino = params[2]
var separador = params[3]

var fs = require('fs'),
path = require('path'),    
filePath = path.join(__dirname, arquivo);

console.log ('\nEntrada: ' +  arquivo)
console.log ('Coluna: ' +  indexCodigo + ', Separador: \'' + separador + '\', Saída: ' + 'resultados/' + destino + '/')

const { exec }  = require("child_process");

exec("cat " + filePath + " | wc -l", (error, stdout, stderr) => {
	if (error) {
		console.log(`error: ${error.message}`);
        return;
    }
    if (stderr) {
		console.log(`stderr: ${stderr}`);
        return;
    }
	var totalLines = stdout
	// console.log('lendo e criando arquivos...')
	var readLines = 0;
	var cidades = [];
	lineReader.eachLine(filePath, function(line, last) {

		readLines++
		var splitted = line.split(separador);
		if (readLines === 1 && isNaN(indexCodigo)) {
			for(var i in splitted) {
				if (splitted[i] === indexCodigo) {
					indexCodigo = i;
					console.log ('Index Coluna: ' + indexCodigo);
					break;
				}
			}
			if(isNaN(indexCodigo)) {
				console.log ('Coluna de nome' + indexCodigo + ' não encontrado! Saindo.');
				process.exit();
			}
		}
		if (cidades[splitted[indexCodigo]] === undefined) {
			cidades[splitted[indexCodigo]] = line + '\n';
		} else {
			cidades[splitted[indexCodigo]] += line + '\n';
		}
		if ((readLines % 20000) === 0){
			var percent = (readLines/totalLines*100)
			process.stdout.write('\r' + percent.toFixed(2) + '%  ');
			cidades = escreveArquivos(cidades);
		}
		if (last) {
			cidades = escreveArquivos(cidades);
			console.log('\r100%  \nFinalizado');
			return false; // stop reading
		}
	});
});

function escreveArquivos(cidades) {
	for (var index in cidades) {
		fs.appendFileSync(__dirname + '/resultados/' + destino + '/'  + index + '.csv', cidades[index]);
	}
	var cidades = []
	return cidades;
}