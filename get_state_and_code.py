from tkinter import filedialog
import tkinter as tkinter
from PIL import ImageTk, Image
import os
import pandas as pd
from unidecode import unidecode

#ler o arquivo com a chave de estados
#criar dicionario entre chave = nome de estado e codigo = nulo inicialmente
#ler os arquivos com a pagina em html buscando as chaves no formato correto, ex: 'rio-grande-do-norte'
#se achar a chave:
#	quebrar na chave em formato de busca e pega o primeiro item 
#	quebrar em '-' e pegar o primeiro item
#	quebrar em "<a href="/dataset/" pegar o segundo item e transformar em inteiro
#	atualizar o dicionario inserindo o codigo correto com o estado
#extrair as duas listas do dicionario
#criar um dataframe com as listas e exportar em csv para armazenar no SQL

list_keys = []
sate_code_list = []
def read_keys_file(filepath):
	input_keys_file = open(filepath, 'r')
	for line in input_keys_file:
		list_keys.append(line.split("\n")[0])
		sate_code_list.append(0) #creating an empty list
	return list_keys

read_keys_file("chaves_estados_padronizada.txt")

def Associate_keys_and_state_code(list_keys, sate_code_list):
	global dict_key_codigo
	zip_iterator = zip(list_keys,sate_code_list)
	dict_key_codigo = dict(zip_iterator)
	list_of_important_lines = []
	print("Analyzing " + str(len(list_of_files))+ " files.")
	for index in range(0, len(list_of_files)):
		filename = list_of_files[index]
		file_read = open(filename, "r", encoding = "utf-8")
		for line in file_read:
			lower_case_line = unidecode(line).lower()
			if any (element in lower_case_line for element in list_keys):
				list_of_important_lines.append(lower_case_line)
		for key in list_keys:
			for important_line in list_of_important_lines:
				if ((key+ "</a>") in important_line) and ("fisica" in important_line) :
					try:
						line = important_line.split('-')[0]
						line = line.split('<a href="/dataset/')[1]
						state_code = int(line)
						dict_key_codigo.update({key: state_code})
					except:
						pass


def Read_Files():
	global list_of_files, root
	root = tkinter.Tk()
	root.geometry("485x354+300+150")
	root.resizable(width=True, height=True)
	img = ImageTk.PhotoImage(Image.open("text_to_csv_image.png"))
	panel = tkinter.Label(root, image = img)
	panel.pack(side = "bottom", fill = "both", expand = "yes")
	filez = filedialog.askopenfilenames(parent=root,title='Select the text files', filetypes = [("html", "*.html")])
	list_of_files = list(filez)
	Associate_keys_and_state_code(list_keys, sate_code_list)
	print("The " + str(len(list_keys))+ " key(s) was(were) related to state code.")
	root.mainloop()

Read_Files()

def Save_keys_and_state_code_as_csv(dict_key_codigo):
	d = {'estado': list(dict_key_codigo.keys()), 'codigo': list(dict_key_codigo.values())}
	dataframe =pd.DataFrame(data = d)
	dataframe.to_csv('estado_e_codigo.csv')
	print("the 'estado_e_codigo.csv' file was saved")


Save_keys_and_state_code_as_csv(dict_key_codigo)