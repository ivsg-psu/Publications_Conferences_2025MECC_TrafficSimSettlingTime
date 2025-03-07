from bs4 import BeautifulSoup
import sys

filePath = sys.argv[1]
# Read the XML file
with open(filePath, 'r') as file:
    content = file.read()

# Parse the XML content with BeautifulSoup
soup = BeautifulSoup(content, 'xml')

# Find the first edge element with id="-11832888#0"
edge = soup.find('edge', {'id': 'A0A1'})

# Replace its attributes with the new ones
edge['sampledSeconds'] = "0"
edge['traveltime'] = "0"
edge['overlapTraveltime'] = "0"
edge['density'] = "0"
edge['laneDensity'] = "0"
edge['occupancy'] = "0"
edge['waitingTime'] = "0"
edge['timeLoss'] = "0"
edge['speed'] = "0"
edge['speedRelative'] = "0"
edge['departed'] = "0"
edge['arrived'] = "0"
edge['entered'] = "0"
edge['left'] = "0"
edge['laneChangedFrom'] = "0"
edge['laneChangedTo'] = "0"

# Write the modified content back to the file
with open(filePath, 'w') as file:
    file.write(str(soup))
