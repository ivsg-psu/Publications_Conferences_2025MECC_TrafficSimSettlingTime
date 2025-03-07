import subprocess
import os

# specify the directory containing the XML files
directory = '/home/wushuang/Documents/GitHub/ThesisWork/SUMO/TimeIntervalTests/period_0.1sec/aggregatedResults/'

# specify the path to the xml2csv.py script
xml2csv_script_path = '/media/wushuang/SeagateMac/Code/tools/xml/xml2csv.py'

# iterate over all files in the directory
for filename in os.listdir(directory):
    # check if the file is an XML file
    if filename.endswith('.xml'):
        # construct the full file path
        xml_file_path = os.path.join(directory, filename)
        
        # construct the output CSV file path
        csv_file_path = os.path.join(directory, filename[:-4] + '.csv')
        
        # call the xml2csv.py script on the XML file
        subprocess.run(['python', xml2csv_script_path, xml_file_path, csv_file_path])
