from tkinter import filedialog
import tkinter as tkinter
from PIL import ImageTk, Image
import os
import pandas as pd
from unidecode import unidecode

def main():

	print("Analyzing " + str(len(list_of_files))+ " files.")
	for index in range(0, len(list_of_files)):
		filename = list_of_files[index]
		file_read = open(filename, "r")
		d = {'estado': [], 'renda': []}
		dataframe =pd.DataFrame(data = d)
		lista_estado = []
		lista_renda = []
		for line in file_read:
			splitted_line = line.split()
			renda = splitted_line[-1]
			splitted_line.remove(renda)
			for i in range(0, len(splitted_line)): 
				splitted_line[i] = unidecode(splitted_line[i]).lower() #if you want to import lower keys
			estado = " ".join(splitted_line)
			lista_estado.append(estado)
			lista_renda.append(renda)
		dataframe['estado']= lista_estado
		dataframe['renda']= lista_renda
		file_read.close()
		file_name_without_txt = filename.split(".txt")[0]
		dataframe.to_csv(file_name_without_txt+'.csv', encoding = "utf-8")


def Read_Files():
	global list_of_files, root
	root = tkinter.Tk()
	root.geometry("485x354+300+150")
	root.resizable(width=True, height=True)
	img = ImageTk.PhotoImage(Image.open("text_to_csv_image.png"))
	panel = tkinter.Label(root, image = img)
	panel.pack(side = "bottom", fill = "both", expand = "yes")
	filez = filedialog.askopenfilenames(parent=root,title='Select the text files', filetypes = [("test files", "*.txt")])
	list_of_files = list(filez)
	main()
	print("The " + str(len(list_of_files))+ " file(s) was(were) converted to *.csv and saved.")
	root.mainloop()

Read_Files()

