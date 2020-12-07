import urllib.request
import requests


def read_state_and_code_file():
	input_file = open('estado_e_codigo.csv').readlines()
	global dict_key_codigo
	estado = []
	codigo = []
	first_line = input_file.pop(0)
	for line in input_file:
		line = line.split(',')
		estado.append((line[2].split('\n'))[0])
		codigo.append(line[1])
	zip_iterator = zip(estado,codigo)
	dict_key_codigo = dict(zip_iterator)
	return dict_key_codigo

read_state_and_code_file() 



def Acess_link_and_download(link, key):
	print("accessing " + link)
	r= requests.get(link, allow_redirects = True)
	open('dados_inadimplencia_' + key+'.csv', 'wb').write(r.content)
	print('done')



def Loop_over_codes_to_download_files(dict_key_codigo):
	for key in dict_key_codigo.keys():
		codigo = dict_key_codigo.get(key)
		link = 'http://api.bcb.gov.br/dados/serie/bcdata.sgs.'+ codigo + '/dados?formato=csv'
		Acess_link_and_download(link, key)

Loop_over_codes_to_download_files(dict_key_codigo)

