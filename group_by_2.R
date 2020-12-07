setwd("/media/amanda/UUI/projeto_inadimlencia_mei")
getwd()
library("dplyr")
library("ggplot2")
library("data.table")
library("ggthemes")
library("tidyverse")



tabela_fato <- read.table('fact_table.csv', header = TRUE, sep = ",", dec = ".")

df = data.frame(tabela_fato)

tabela_media_taxa_inadimplencia_ano<- data.frame(summarise(group_by(df,ano), mean(taxa_inadimplencia),sd(taxa_inadimplencia)))
tabela_media_taxa_inadimplencia_ano
tabela_media_taxa_inadimplencia_ano_regiao <- data.frame(summarise(group_by(df,ano,regiao), mean(taxa_inadimplencia)))

tabela_media_taxa_inadimplencia_ano2019_regiao <- subset(tabela_media_taxa_inadimplencia_ano_regiao ,ano == 2019)
tabela_media_taxa_inadimplencia_ano2019_regiao

tabela_media_taxa_inadimplencia_ano_regiao_estado <- data.frame(summarise(group_by(df,ano,regiao,estado), mean(taxa_inadimplencia)))
tabela_media_renda_per_capita_ano <- data.frame(summarise(group_by(df,ano), mean(renda_per_capita), sd(renda_per_capita)))
tabela_media_renda_per_capita_ano

tabela_media_renda_per_capita_ano_regiao <- data.frame(summarise(group_by(df,ano,regiao), mean(renda_per_capita)))
tabela_media_renda_per_capita_ano2019_regiao <- subset(tabela_media_renda_per_capita_ano_regiao, ano == 2019)


tabela_media_renda_per_capita_ano_regiao_estado <- data.frame(summarise(group_by(df,ano,regiao,estado), mean(renda_per_capita)))


tabela_media_taxa_inadimplencia_ano["mean.taxa_inadimplencia."]
tabela_media_taxa_inadimplencia_ano["ano"]

###########plot da média renda per-capita brasileira por ano

pdf("evolucao_renda_per_capita_brasileira_ano.pdf", width=10, height=6)
p <-ggplot(data = tabela_media_renda_per_capita_ano, aes(x = tabela_media_renda_per_capita_ano[,1], y = tabela_media_renda_per_capita_ano[,2]))  
p +  geom_point(size = 3) + labs(x = "Ano", y = "Média brasileira \n da renda per-capita domiciliar (R$)")+
geom_errorbar( aes(x=tabela_media_renda_per_capita_ano[,1], ymin=tabela_media_renda_per_capita_ano[,2]-tabela_media_renda_per_capita_ano[,3], ymax=tabela_media_renda_per_capita_ano[,2]+tabela_media_renda_per_capita_ano[,3]), width=0.3, colour="midnightblue", alpha=0.5, size=0.7)+
theme_economist() + 
stat_smooth(method = "lm", col = "red")+
theme(axis.title=element_text(size=20)) + 
theme(axis.text.x = element_text( size=20), axis.text.y = element_text(face="bold", size = 0)) +
geom_text(aes(label=paste("R$ ",round(tabela_media_renda_per_capita_ano[,2], digits = 0))),hjust=+0.2, vjust=-1.8, size =7)+
xlim(2015.5,2019.5) + 
ylim(995,1350) 

dev.off()

#########plot da média da taxa de inadimplência brasielira por ano
pdf("evolucao_inadimplencia_mei_brasileira_ano.pdf", width=10, height=6)
p <-ggplot(data = tabela_media_taxa_inadimplencia_ano, aes(x = tabela_media_taxa_inadimplencia_ano[,1], y = tabela_media_taxa_inadimplencia_ano[,2]))  
p +  geom_point(size = 3) + labs(x = "Ano", y = "Média brasileira da taxa\n de inadimplência de MEI pessoa física (%)")+
  geom_errorbar( aes(x=tabela_media_taxa_inadimplencia_ano[,1], ymin=tabela_media_taxa_inadimplencia_ano[,2]-tabela_media_taxa_inadimplencia_ano[,3], ymax=tabela_media_taxa_inadimplencia_ano[,2]+tabela_media_taxa_inadimplencia_ano[,3]), width=0.3, colour="midnightblue", alpha=0.5, size=0.7)+
  theme_economist() + 
  stat_smooth(method = "lm", col = "red")+
  theme(axis.title=element_text(size=20)) + 
  theme(axis.text.x = element_text( size=20), axis.text.y = element_text(face="bold", size = 0)) +
  geom_text(aes(label=paste(round(tabela_media_taxa_inadimplencia_ano[,2], digits = 1), "%")),hjust=+0.2, vjust=-1.0, size = 7.0)+
  xlim(2015.5,2019.5) 

dev.off()
media_inadimplencia_brasileira_2019 = last(tabela_media_taxa_inadimplencia_ano[,2]) 
media_renda_per_capita_brasileira_2019 = last(tabela_media_renda_per_capita_ano[,2])


###################################################

# Add a column with your condition for the color
tabela_media_taxa_inadimplencia_ano2019_regiao <- mutate(tabela_media_taxa_inadimplencia_ano2019_regiao, mycolor= ifelse(tabela_media_taxa_inadimplencia_ano2019_regiao[,3]> media_inadimplencia_brasileira_2019, "indianred3","springgreen4"))
tabela_media_taxa_inadimplencia_ano2019_regiao
#############plot da média da taxa de inadimplência por regiao em 2019

labels_regiao = c("Centro-Oeste", "Nordeste", "Norte", "Sudeste", "Sul") 
media_inadimplencia_brasileira_2019
pdf("inadimplencia_regiao_2019.pdf", width=10, height=6)
p <-ggplot(data = tabela_media_taxa_inadimplencia_ano2019_regiao, aes(x =  tabela_media_taxa_inadimplencia_ano2019_regiao[,2], y= tabela_media_taxa_inadimplencia_ano2019_regiao[,3], label = paste(round(tabela_media_taxa_inadimplencia_ano2019_regiao[,3],digits = 1),"%"))) 
p+ geom_bar(stat = "identity", fill = tabela_media_taxa_inadimplencia_ano2019_regiao[,4]) + 
  geom_hline(aes(yintercept = media_inadimplencia_brasileira_2019), linetype = "dashed", size = 1) +
  geom_text(position = position_dodge(width = 1), vjust = -0.3, size = 6.8)+
  geom_text(aes(0,media_inadimplencia_brasileira_2019,label = paste("média\n brasileira ",round(media_inadimplencia_brasileira_2019, digits = 1), "%"), vjust =-0.1, hjust = -0.0), size = 6.2) +
  theme_economist()+
  theme(axis.title=element_text(size=20)) + 
  theme(axis.text.x = element_text(size=20), axis.text.y = element_text(face="bold", size = 0)) +
  labs(x = "", y = "") +
  scale_x_discrete(labels= labels_regiao)
dev.off()
 
###############Plot da media de renda per capita por regiao em 2019

tabela_media_renda_per_capita_ano2019_regiao <- mutate(tabela_media_renda_per_capita_ano2019_regiao,
                                                       mycolor= ifelse(tabela_media_renda_per_capita_ano2019_regiao[,3]> media_renda_per_capita_brasileira_2019, "dodgerblue","indianred3"))
tabela_media_renda_per_capita_ano2019_regiao

pdf("renda_per_capita_regiao_2019.pdf", width=10, height=6)
d <-ggplot(data = tabela_media_renda_per_capita_ano2019_regiao, aes(x=  tabela_media_renda_per_capita_ano2019_regiao[,2], y = tabela_media_renda_per_capita_ano2019_regiao[,3], label = paste("R$",round(tabela_media_renda_per_capita_ano2019_regiao[,3],digits = 0)))) 
d + geom_bar(stat = "identity", fill = tabela_media_renda_per_capita_ano2019_regiao[,4]) +
  geom_hline(aes(yintercept = media_renda_per_capita_brasileira_2019), linetype = "dashed", size = 1.0) +
  geom_text(position = position_dodge(width = 1), vjust = -0.2, size = 6.8)+
  geom_text(aes(0,media_renda_per_capita_brasileira_2019,label = paste("média brasileira R$",round(media_renda_per_capita_brasileira_2019, digits = 0)), vjust =-0.5, hjust = -0.9), size = 6.2)+
  theme_economist()+
  theme(axis.title=element_text(size=20)) +
  theme(axis.text.x = element_text( size=20), axis.text.y = element_text(face="bold", size = 0)) +
  labs(x = "", y = "") +
  scale_x_discrete(labels= labels_regiao)
  
dev.off()

# a regiao sudeste apresenta uma tendencia diferenciada em relacao as outras
# sera que isso seria explicado por algum estado especifico desta regiao

#criando uma nova tabela para a regiao sudeste, em relacao a media da regiao sudeste

tabela_regiao_sudeste_2019 <- subset(tabela_fato, (ano == 2019 & regiao == 'sudeste'))

tabela_media_taxa_inadimplencia_sudeste_2019 <- data.frame(summarise(group_by(tabela_regiao_sudeste_2019 ,estado), mean(taxa_inadimplencia)))

media_taxa_inadimplencia_sudeste_2019 <- mean(tabela_media_taxa_inadimplencia_sudeste_2019[,2])
tabela_media_taxa_inadimplencia_sudeste_2019 <-mutate(tabela_media_taxa_inadimplencia_sudeste_2019,
                                               mycolor= ifelse(tabela_media_taxa_inadimplencia_sudeste_2019[,2]> media_inadimplencia_brasileira_2019, "indianred3","springgreen4")) #cores em relacao a media brasileira
tabela_media_taxa_inadimplencia_sudeste_2019


labels_estados_sudeste = c("ES", "MG", "RJ", "SP") 

pdf("inadimplencia_sudeste_2019.pdf", width=10, height=6)
p <-ggplot(data = tabela_media_taxa_inadimplencia_sudeste_2019, aes(x =  tabela_media_taxa_inadimplencia_sudeste_2019[,1], y= tabela_media_taxa_inadimplencia_sudeste_2019[,2], label = paste(round(tabela_media_taxa_inadimplencia_sudeste_2019[,2],digits = 1),"%"))) 
p+ geom_bar(stat = "identity", fill = tabela_media_taxa_inadimplencia_sudeste_2019[,3]) + 
  geom_hline(aes(yintercept = media_taxa_inadimplencia_sudeste_2019), linetype = "dashed", size = 1) +
  geom_text(position = position_dodge(width = 1), vjust = -0.2, size = 6.8)+
  geom_text(aes(0,media_taxa_inadimplencia_sudeste_2019,label = paste("média sudeste= ",round(media_taxa_inadimplencia_sudeste_2019, digits = 1), "%"), vjust =-1.8, hjust = -0.9), size = 6.2) +
  theme_economist()+
  theme(axis.title=element_text(size=30, face = "bold")) + 
  theme(axis.text.x = element_text(size=20), axis.text.y = element_text(face="bold", size = 0)) +
  labs(x = "", y = "Sudeste") +
  scale_x_discrete(labels=labels_estados_sudeste)
dev.off()

# criando tabela da regiao sul


tabela_regiao_sul_2019 <- subset(tabela_fato, (ano == 2019 & regiao == 'sul'))

tabela_regiao_sul_2019
tabela_media_taxa_inadimplencia_sul_2019 <- data.frame(summarise(group_by(tabela_regiao_sul_2019 ,estado), mean(taxa_inadimplencia)))
media_taxa_inadimplencia_sul_2019 <- mean(tabela_media_taxa_inadimplencia_sul_2019[,2])
tabela_media_taxa_inadimplencia_sul_2019 <-mutate(tabela_media_taxa_inadimplencia_sul_2019,
                                                      mycolor= ifelse(tabela_media_taxa_inadimplencia_sul_2019[,2]> media_inadimplencia_brasileira_2019, "indianred3","springgreen4")) #cores em relacao a media brasileira
tabela_media_taxa_inadimplencia_sul_2019
labels_estados_sul = c("PR", "RS", "SC") 

pdf("inadimplencia_sul_2019.pdf", width=10, height=6)
p <-ggplot(data = tabela_media_taxa_inadimplencia_sul_2019, aes(x =  tabela_media_taxa_inadimplencia_sul_2019[,1], y= tabela_media_taxa_inadimplencia_sul_2019[,2], label = paste(round(tabela_media_taxa_inadimplencia_sul_2019[,2],digits = 1),"%"))) 
p+ geom_bar(stat = "identity", fill = tabela_media_taxa_inadimplencia_sul_2019[,3]) + 
  geom_hline(aes(yintercept = media_taxa_inadimplencia_sul_2019), linetype = "dashed", size = 1) +
  geom_text(position = position_dodge(width = 1), vjust = -0.2, size = 6.8)+
  geom_text(aes(0,media_taxa_inadimplencia_sul_2019,label = paste("média sul= ",round(media_taxa_inadimplencia_sul_2019, digits = 1), "%"), vjust =-1, hjust = -3), size = 6.2) +
  theme_economist()+
  theme(axis.title=element_text(size=30, face = "bold")) + 
  theme(axis.text.x = element_text(size=20), axis.text.y = element_text(face="bold", size = 0)) +
  labs(x = "", y = "Sul") +
  scale_x_discrete(labels=labels_estados_sul)
dev.off()


#fazer da região centro-oeste

tabela_regiao_co_2019 <- subset(tabela_fato, (ano == 2019 & regiao == 'centro_oeste'))

tabela_media_taxa_inadimplencia_co_2019 <- data.frame(summarise(group_by(tabela_regiao_co_2019 ,estado), mean(taxa_inadimplencia)))
media_taxa_inadimplencia_co_2019 <- mean(tabela_media_taxa_inadimplencia_co_2019[,2])
tabela_media_taxa_inadimplencia_co_2019 <-mutate(tabela_media_taxa_inadimplencia_co_2019,
                                                  mycolor= ifelse(tabela_media_taxa_inadimplencia_co_2019[,2]> media_inadimplencia_brasileira_2019, "indianred3","springgreen4")) #cores em relacao a media brasileira
tabela_media_taxa_inadimplencia_co_2019
labels_estados_co = c("DF", "GO", "MT", "MS") 

pdf("inadimplencia_co_2019.pdf", width=10, height=6)
p <-ggplot(data = tabela_media_taxa_inadimplencia_co_2019, aes(x =  tabela_media_taxa_inadimplencia_co_2019[,1], y= tabela_media_taxa_inadimplencia_co_2019[,2], label = paste(round(tabela_media_taxa_inadimplencia_co_2019[,2],digits = 1),"%"))) 
p+ geom_bar(stat = "identity", fill = tabela_media_taxa_inadimplencia_co_2019[,3]) + 
  geom_hline(aes(yintercept = media_taxa_inadimplencia_co_2019), linetype = "dashed", size = 1) +
  geom_text(position = position_dodge(width = 1), vjust = -0.2, size = 6.8)+
  geom_text(aes(0,media_taxa_inadimplencia_co_2019,label = paste("média centro-oeste= ",round(media_taxa_inadimplencia_co_2019, digits = 1), "%"), vjust =-1, hjust = -1.8), size = 6.2) +
  theme_economist()+
  theme(axis.title=element_text(size=30, face = "bold")) + 
  theme(axis.text.x = element_text(size=20), axis.text.y = element_text(face="bold", size = 0)) +
  labs(x = "", y = "Centro-Oeste") +
  scale_x_discrete(labels=labels_estados_co)
dev.off()

#fazer da região norte

tabela_regiao_norte_2019 <- subset(tabela_fato, (ano == 2019 & regiao == 'norte'))

tabela_media_taxa_inadimplencia_norte_2019 <- data.frame(summarise(group_by(tabela_regiao_norte_2019 ,estado), mean(taxa_inadimplencia)))

media_taxa_inadimplencia_norte_2019 <- mean(tabela_media_taxa_inadimplencia_norte_2019[,2])

tabela_media_taxa_inadimplencia_norte_2019 <-mutate(tabela_media_taxa_inadimplencia_norte_2019,
                                                 mycolor= ifelse(tabela_media_taxa_inadimplencia_norte_2019[,2]> media_inadimplencia_brasileira_2019, "indianred3","springgreen4"))

tabela_media_taxa_inadimplencia_norte_2019

labels_estados_norte = c("AC", "AP", "AM", "PA", "RO","RR", "TO") 

pdf("inadimplencia_norte_2019.pdf", width=10, height=6)
p <-ggplot(data = tabela_media_taxa_inadimplencia_norte_2019, aes(x =  tabela_media_taxa_inadimplencia_norte_2019[,1], y= tabela_media_taxa_inadimplencia_norte_2019[,2], label = paste(round(tabela_media_taxa_inadimplencia_norte_2019[,2],digits = 1),"%"))) 
p+ geom_bar(stat = "identity", fill = tabela_media_taxa_inadimplencia_norte_2019[,3]) + 
  geom_hline(aes(yintercept = media_taxa_inadimplencia_norte_2019), linetype = "dashed", size = 1) +
  geom_text(position = position_dodge(width = 1), vjust = +1.8, size = 6.8)+
  geom_text(aes(0,media_taxa_inadimplencia_norte_2019,label = paste("média norte= ",round(media_taxa_inadimplencia_norte_2019, digits = 1), "%"), vjust =-1, hjust = -2.7), size = 6.2) +
  theme_economist()+
  theme(axis.title=element_text(size=30, face = "bold")) + 
  theme(axis.text.x = element_text(size=20), axis.text.y = element_text(face="bold", size = 0)) +
  labs(x = "", y = "Norte") +
  scale_x_discrete(labels=labels_estados_norte)
dev.off()


# criando a a tabela da regiao nordeste

tabela_regiao_nordeste_2019 <- subset(tabela_fato, (ano == 2019 & regiao == 'nordeste'))

tabela_media_taxa_inadimplencia_nordeste_2019 <- data.frame(summarise(group_by(tabela_regiao_nordeste_2019 ,estado), mean(taxa_inadimplencia)))

media_taxa_inadimplencia_nordeste_2019 <- mean(tabela_media_taxa_inadimplencia_nordeste_2019[,2])


tabela_media_taxa_inadimplencia_nordeste_2019 <-mutate(tabela_media_taxa_inadimplencia_nordeste_2019,
                                                    mycolor= ifelse(tabela_media_taxa_inadimplencia_nordeste_2019[,2]> media_inadimplencia_brasileira_2019, "indianred3","springgreen4"))

tabela_media_taxa_inadimplencia_nordeste_2019

labels_estados_nordeste = c("AL", "BA", "CE", "MA", "PB","PE", "PI", "RN","SE") 

pdf("inadimplencia_nordeste_2019.pdf", width=20, height=6)

p <-ggplot(data = tabela_media_taxa_inadimplencia_nordeste_2019, aes(x =  tabela_media_taxa_inadimplencia_nordeste_2019[,1], y= tabela_media_taxa_inadimplencia_nordeste_2019[,2], label = paste(round(tabela_media_taxa_inadimplencia_nordeste_2019[,2],digits = 1),"%")))

p+ geom_bar(stat = "identity", fill = tabela_media_taxa_inadimplencia_nordeste_2019[,3]) + 
  geom_hline(aes(yintercept = media_taxa_inadimplencia_nordeste_2019), linetype = "dashed", size = 1) +
  geom_text(position = position_dodge(width = 1), vjust = +1.8, size = 7.5)+
  geom_text(aes(0,media_taxa_inadimplencia_nordeste_2019,label = paste("média nordeste= ",round(media_taxa_inadimplencia_nordeste_2019, digits = 1), "%"), vjust =-1, hjust = -2.7), size = 6.2) +
  theme_economist()+
  theme(axis.title=element_text(size=30, face = "bold")) + 
  theme(axis.text.x = element_text(size=20), axis.text.y = element_text(face="bold", size = 0)) +
  labs(x = "", y = "Nordeste") +
  scale_x_discrete(labels=labels_estados_nordeste)
dev.off()