from bs4 import BeautifulSoup
import sys
tripFilePath = sys.argv[1]
# Load the XML file
# xml_file = "/home/wushuang/Documents/GitHub/ThesisWork/SUMO/StateCollege/PortionOfSC/PortionOfSC.trips.xml"  # Replace with the path to your actual XML file
xml_file = str(tripFilePath)
with open(xml_file, "r") as f:
    soup = BeautifulSoup(f, "xml")

# Create the new <route> element
new_route = soup.new_tag("route", id="r_0", edges="801956764#0 276902335 801956765#0 858937529#0 276902337")

# Find the <trip> element
trip_element = soup.find("trip")

# Insert the new <route> element before the <trip> element
trip_element.insert_before(new_route)

# Write the updated XML back to the file
with open(xml_file, "w") as f:
    f.write(soup.prettify())