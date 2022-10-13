## ⚙️ Execução do projeto
Para compilar e executar, basta rodar o script sh "compileAndRun.sh", presente na pasta raiz do projeto, estando em uma máquina linux. Caso não esteja em uma máquina linux, abra o arquivo e rode todos os comandos presentes nele, ignorando a primeira linha `(#!/bin/bash)`


```bash
   #Comandos necessarios caso nao rode com o Script
   g++ -std=c++11 -fopenmp -lm -c -o decision_treep.o decision_tree.cpp

    g++ -std=c++11 -fopenmp -lm -o dtp.exe decision_treep.o
    
    time ./dtp.exe dt_train2.txt dt_test2.txt dt_result.txt
```


# Explicação sobre a aplicação.


A aplicação possui 3 classes(DecisionTree, InputReader, OutputReader) ao todo alem da main, onde as tecnicas de paralelização foram aplicadas exclusivamente na classe DecisionTree, visto que e nela que ocorre os processamentos basseados na arvore de decisão.

Há uma criaçao dos ramos base da arvore de decição logo depois ocorre um processo de criaçao de uma tabela para armazenar as probabilidades de mudar para cada ramo. Logo depois ocorre um processo de verificação das respotas.

Por fim e gerado a acuracia do algotimo.

## Locais Paralelizados.

A primeira função a ser paraleilizada foi void run(Table table, int nodeIndex) visto que ela é a primeira ser rodada no momento da criação do objeto pois esta sendo chamada dentro do construtor.

A ideia central foi paraleizar sem depreciar o funcionamento geral do algoritmo, para isso, criamos uma seção crítica em momentos onde a ordem de execução das instruções era importante.

Demostraçao de codigo a baixo:

```bash
        #pragma omp parallel for
		for (int i = 0; i < initialTable.attrValueList[selectedAttrIndex].size(); i++)
		{
			string attrValue = initialTable.attrValueList[selectedAttrIndex][i];

			Table nextTable;
			vector<int> candi = attrValueMap[attrValue];

			#pragma omp critical
			{
				for (int i = 0; i < candi.size(); i++)
				{
					nextTable.data.push_back(table.data[candi[i]]);
				}
			}
            ...
            ...
            ...
        }
```

Ocorreu tambem uma paraleizaçao na função int getSelectedAttribute(Table table) com o intuito de encontrar o valor max para o atributo, assim como seu índice. Apesar de ter funcionado a paralelizaçao deste metodo nao foi obitdo um resultado significativo para a amostragem.


```bash
int getSelectedAttribute(Table table)
	{
		int maxAttrIndex = -1;
		double maxAttrValue = 0.0;

		// except label
		#pragma omp paralleo for shared(maxAttrValue, maxAttrIndex) private(i)
		for (int i = 0; i < initialTable.attrName.size() - 1; i++)
		{
			if (maxAttrValue < getGainRatio(table, i))
			{
				maxAttrValue = getGainRatio(table, i);
				maxAttrIndex = i;
			}
		}

		return maxAttrIndex;
	}
```

	
Houveram algumas tentativas de paralelizar os metodos getMajorityLabel() e printTree() ambas falharam pois modificavam o funcionamento geral do sistema.



# Repositório original: https://github.com/bowbowbow/DecisionTree


#pragma omp parallel for
		for (int i = 0; i < initialTable.attrValueList[selectedAttrIndex].size(); i++)
		{
			string attrValue = initialTable.attrValueList[selectedAttrIndex][i];

			Table nextTable;
			vector<int> candi = attrValueMap[attrValue];

			#pragma omp critical
			{
				for (int i = 0; i < candi.size(); i++)
				{
					nextTable.data.push_back(table.data[candi[i]]);
				}
			}