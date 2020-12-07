from tkinter import filedialog
import tkinter as tkinter
from PIL import ImageTk, Image
import os
import pandas as pd
from unidecode import unidecode
import re

#listas essenciais geradas pela funcao CreateFactTable():
#list_keys = lista de chaves lida a partir do arquivo de nomes de estado
#states_list = lista com o nome dos estados
#date_list = lista com as datas trimestrais de leitura de taxa de inadimplencia, no arquivo 'dados_inadimplencia_' + nome do estado + '.csv'
#taxa_inadimplencia = dados de taxa de inadimplencia, no arquivo 'dados_inadimplencia_' + nome do estado + '.csv'
#renda_per_capita_list = lista de renda per capita lida no arquivo renda_domiciliar_per_capita_"  + ANO + "_ibge.csv"
#year_list = lista de ano vindo a partir da coluna de data, para simplificar manipulacao numerica
#trimester_list = lista de trimestre vindo a partir de coluna de data, para simplificar manipulcacao numerica
#region_list = classifica o estado de acordo com a regiao
#****************************************************************************************************
#
#listas adicionais para facilitar a análise, criadas pela funcao Fact_table_addition():
#media_inadimplencia_estado_ano = realiza a media de 4 linhas de estado no ano -> while estado = key e ano = 2016
#media_inadimplencia_brasileira_no_ano = realiza a media de 4 * 27 linhas no ano -> enquanto ano = ano selecionado
#media_renda_per_capita_brasileira_ano = realiza a media da renda per capita em enquanto coluna ano = ano selecionado
#ranking_inadimplencia_ano =  posicao do estado na lista organizada de taxa de inadimplencia no ano
#ranking_per_capita_ano = posicao do estado na lista organizada de renda per capita no ano
#


#criando dicionario de regiao
dict_regions = {"rio de janeiro" : "sudeste", "sao paulo" : "sudeste", "minas gerais": "sudeste", \
"espirito santo":"sudeste", "parana":"sul", "rio grande do sul":"sul", "santa catarina":"sul", \
"goias" : "centro_oeste" , "mato grosso": "centro_oeste", "mato grosso do sul": "centro_oeste", \
"distrito federal": "centro_oeste", \
"acre" : "norte", "amapa": "norte", "amazonas":"norte", "para":"norte", "rondonia":"norte", \
"roraima":"norte", "tocantins":"norte",\
"maranhao" : "nordeste", "piaui" :"nordeste", "ceara": "nordeste", "rio grande do norte": "nordeste",\
"paraiba":"nordeste", "pernambuco":"nordeste", "alagoas":"nordeste", "sergipe":"nordeste", "bahia":"nordeste"}

list_keys = []
sate_code_list = []
def read_keys_file(filepath):
	input_keys_file = open(filepath, 'r')
	for line in input_keys_file:
		list_keys.append(line.split("\n")[0])
		sate_code_list.append(0) #creating an empty list
	return list_keys

read_keys_file("chaves_estados_padronizada.txt")

def CreateFactTable(list_keys):
	global states_list, date_list, taxa_inadimplencia, renda_per_capita_list,year_list, trimester_list, region_list
	states_list = []
	date_list = []
	taxa_inadimplencia_list = []
	renda_per_capita_list = []
	year_list = []
	trimester_list =[]
	region_list = []
	for key in list_keys:
		input_file = open('dados_inadimplencia_' + key + '.csv').readlines()
		first_line = input_file.pop(0)
		for line in input_file:
			line = line.split(";")
			date = line[0]
			if '2020' not in date:
				complete_date = line[0]
				date_list.append(complete_date)
				year = complete_date.split("/")[-1]
				year_list.append(re.findall(r'\d+',year)[0])
				taxa_inadimplencia = (line[1].split("\n"))[0]
				#taxa_inadimplencia must have comma changed by point:
				before_comma = taxa_inadimplencia.split(',')[0]
				after_comma = taxa_inadimplencia.split(',')[1]
				before_comma_number = re.findall(r'\d+',before_comma)[0]
				after_comma_number = re.findall(r'\d+',after_comma)[0]
				taxa_inadimplencia = float(str(before_comma_number)+'.'+ str(after_comma_number))
				taxa_inadimplencia_list.append(taxa_inadimplencia)
				states_list.append(key)
				region_list.append(dict_regions.get(key))
		for i in range(2016,2020):
			input_file_2 = open("renda_domiciliar_per_capita_"  + str(i) + "_ibge.csv", 'r')
			for line2 in input_file_2:
				line2 = line2.split(',')
				if line2[1] == key:
					renda_per_capita = int((line2[2].split("\n"))[0])
					for a in range(1,5):
						renda_per_capita_list.append(renda_per_capita) #o ano corresponde a 4 trimestres (4 linhas)
						trimester_list.append(a)
	global d
	d = {'estado': states_list, 'regiao': region_list, 'data':date_list, 'ano': year_list, 'trimestre': trimester_list,'taxa_inadimplencia':taxa_inadimplencia_list, 'renda_per_capita':renda_per_capita_list} 
	return d


CreateFactTable(list_keys)

def Fact_table_addition(states_list,date_list, taxa_inadimplencia_list, renda_per_capita_list, year):
	media_inadimplencia_brasileira_no_ano = []
	media_renda_per_capita_brasileira_ano = []
	ranking_inadimplencia_ano = []
	ranking_per_capita_ano = []
	#calcula a media inadimplencia por estado no ano, soma os itens
	#de taxa_inadimplencia_list no indice onde state_list = estado e ano == ano
	#added_columns = {"media_inadimplencia_brasileira_no_ano":, "media_renda_per_capita_brasileira_ano":, "ranking_inadimplencia_ano":, "ranking_per_capita_ano":}


def SaveTable(d):
	df = pd.DataFrame(d)
	nome_tabela = 'fact_table'
	df.to_csv(nome_tabela + '.csv')
	print("the " + nome_tabela + ".csv file was saved")

SaveTable(d)


