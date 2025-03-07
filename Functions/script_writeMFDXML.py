# This script uses a .sumocfg template, and takes a given input as a prefix of file name,
# to create a .sumocfg file with specified net file and route file.
# Author: Wushuang
# Created on: 2022 11 29


import sys
from bs4 import BeautifulSoup
# Reading the data inside the xml
# file to a variable under the name
# data

# arg1: the sumo configuration file name
# arg2: simulation mode, bl or per
# arg3: 


file = open(sys.argv[1])
soup = BeautifulSoup(file,'xml')

# change all 
for tag in soup.find_all('additional-files'):
   
    tag['value'] = './'+ 'template_' + sys.argv[2] + '.add.xml'

file.close()

# Write the new sumocfg file
f = open(sys.argv[1],'w')
f.write(soup.prettify())
f.close()