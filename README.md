# brazilian_financial_default_Python_R
This project is focused on the correlation between the micro-entrepreneur (MEIs) default rate and the mean wage in Brazilian regions.

Brazil is divided into 5 big regions: South, North, Southeast, Northeast, and Center-West, each of them presents particular economic indicators.

The datasets from 2016 to 2019 were collected from Statistics and Geography Brazilian Institute, IBGE, and Brazilian Central Bank, BC. 

Python scripts were created to automate the download and collection from a variety of IBGE and BC datasets. Furthermore, all the ETL process and fact table creation were done in Python. 

The analysis process was performed in the R language, including:

  >Simple linear regression on mean wage and on mean default rate.
  
  >Group By region, mean region's value, and color classification depending on the comparison between the mean region's value and Brazilian mean value.

Conclusions: 

  >The Brazilian mean wage increased in this period, while the Brazilian mean MEIs default rate decreased, this suggested a correlation between both indicators. The linear adjusted model presented a good fit.
  
  >Although this correlation was observed for Brazilian mean indicators, this was not observed for the region's mean indicators. The Southeast region presented a high mean wage and high MEIs default rate.
  
  >This unexpected observation was credited to Rio de Janeiro state, where the mean default rate is the second-highest rate considering all Brazilian states.
  
  >The region's mean wage inequality is astonishing, the South's mean wage is almost two times greater than the Northeast's mean wage.


![linear_adjust_english](https://github.com/amandaventurac/brazilian_financial_default_Python_R/blob/main/graficos_juntos_regressao_linear.png)

