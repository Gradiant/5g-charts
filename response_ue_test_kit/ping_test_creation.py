"""
Module to create a script to emulate ping requests from UEs emulated via UERANSIM deployment
"""

import random
import json

def write_ping_test(): 
    """
    inputs:none
    outputs: updating simulation_scripts/curl.sh script to emulate curl requests from UEs
    """
    
    ##load test_case_values json to read in the test case paremeters 
    master_test_file = open('test_case_values.json')
    master_test_file = json.load(master_test_file)
    data_emulation_values = master_test_file["testCases"]["dataRequestEmulation"]
    
    list_of_websites_to_ping = data_emulation_values["webisteList"]
    num_of_ues = data_emulation_values["ueBatchSize"]
    num_of_pings = data_emulation_values["num_of_pings"]
    packet_size_bytes = data_emulation_values["packet_size_bytes"]

    script = []
    
    ##create the script by adding a ping action for every UE to undertake with a fixed upper limit on number of requests
    for i in range(0,400):
        ##randomly select a website 
        rando_website = random.choice(list_of_websites_to_ping)
        ##randomly select a spacing interval to ensure we dont overwhelm any servers
        interval  = random.randint(0, 10)
        ##append script
        script.append(f"ping -I uesimtun{i} {rando_website}  -s {packet_size_bytes} -i {interval} -c {num_of_pings} & \n")

    file_to_write = open("simulation_scripts/ping.sh", "w")
    file_to_write.writelines(script)
    file_to_write.close()
    print("ping.sh written to simulation_scripts/ping.sh")
    
if __name__ == "__main__":
    try:
        write_ping_test()
    except Exception as e:
        print(e)