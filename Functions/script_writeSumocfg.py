# This script uses a .sumocfg template, and takes a given input as a prefix of file name,
# to create a .sumocfg file with specified net file and route file.
# Author: Wushuang
# Created on: 2022 11 29


import sys
from bs4 import BeautifulSoup
# Reading the data inside the xml
# file to a variable under the name
# data

file = open('/home/wushuang/Documents/GitHub/ThesisWork/SUMO/Template/template.sumocfg')
soup = BeautifulSoup(file,'xml')

# change all 
for tag in soup.find_all('net-file'):
    tag['value'] = sys.argv[1] + '.net.xml'
for tag in soup.find_all('route-files'):
    tag['value'] = sys.argv[1] + '.trips.xml'

file.close()
# Write the new sumocfg file
f = open(sys.argv[1] + '.sumocfg','w')
f.write(soup.prettify())
f.close()
