#!/usr/bin/python3
# This is a simple example to demonstrate how to command an AV to be at an exact position using traci module which allows interfacing SUMO with python. 
# Author: Wushuang
# Created on: 2022 06 24
# For more information, please see https://sumo.dlr.de/docs/TraCI.html#examples

#   _____                   _       
#  |_   _|                 | |      
#    | |  _ __  _ __  _   _| |_ ___ 
#    | | | '_ \| '_ \| | | | __/ __|
#   _| |_| | | | |_) | |_| | |_\__ \
#  |_____|_| |_| .__/ \__,_|\__|___/
#              | |                  
#              |_|                  
# flag_bl_per: 'bl' or 'per', where 'bl' means baseline and 'per' means perturbed simulation. Format: string
# simulationLength: how many steps you want to simulate?  Format: integer
# sim_file: the path to the simulation configuration file. Format: .sumofcg 

# These modules are needed to run this script
from __future__ import absolute_import
from __future__ import print_function

import os
import sys
import optparse
import random
from tracemalloc import start

# we need to import python modules from the $SUMO_HOME/tools directory
if 'SUMO_HOME' in os.environ:
    tools = os.path.join(os.environ['SUMO_HOME'], 'tools')
    sys.path.append(tools)
else:
    sys.exit("please declare environment variable 'SUMO_HOME'")

from sumolib import checkBinary  
import traci  
import traci.constants as tc


def fcn_simBLandPer(flag_bl_per,sim_length):

#   __  __       _       
#  |  \/  |     (_)      
#  | \  / | __ _ _ _ __  
#  | |\/| |/ _` | | '_ \ 
#  | |  | | (_| | | | | |
#  |_|  |_|\__,_|_|_| |_|         
    try:
        # First you compose the command line to start either sumo or sumo-gui (leaving out the option which was needed before 0.28.0):                           
    ################################################
    # Baseline case
    ################################################
        if flag_bl_per == 1:
            sumoBinary = "sumo"
            resultFile = "bl_result.xml"
            addFile = "bl_PortionOfSC.add.xml"

            sumoCmd = [sumoBinary, "-c", "/home/wushuang/Documents/GitHub/ThesisWork/SUMO/StateCollege/PortionOfSC/PortionOfSC.sumocfg","--fcd-output",resultFile,\
                "--additional-files","/home/wushuang/Documents/GitHub/ThesisWork/SUMO/StateCollege/PortionOfSC/"+addFile]
            print(sumoCmd)
            # Then you start the simulation and connect to it with your script:
            traci.start(sumoCmd)
            step = 0        
            while step < sim_length:
                traci.simulationStep()
                step +=1         
   
    ################################################
    # Perturbed case
    ################################################
        elif flag_bl_per ==2:
            sumoBinary = "sumo"
            resultFile = "per_result.xml"
            addFile = "per_PortionOfSC.add.xml"

            sumoCmd = [sumoBinary, "-c", "/home/wushuang/Documents/GitHub/ThesisWork/SUMO/StateCollege/PortionOfSC/PortionOfSC.sumocfg","--fcd-output",resultFile,\
                "--additional-files","/home/wushuang/Documents/GitHub/ThesisWork/SUMO/StateCollege/PortionOfSC/"+addFile]
            # Then you start the simulation and connect to it with your script:
            traci.start(sumoCmd)
            step = 0        
            veh_id = 'inserted_vehicle'
            while step < sim_length:
                if 0==step:
                    traci.vehicle.add(veh_id, "r_0")
                    step += 1
                else:
                    traci.vehicle.setStop(veh_id,"276902335",pos = 20)
                    traci.simulationStep()
                    step +=1


    finally:

        print("Simulation is done!")
        # close the connection
        traci.close()


if __name__ == '__main__':
    fcn_simBLandPer()


        