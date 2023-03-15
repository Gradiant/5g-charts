"""
Module to create a script to emulate curl requests from UEs emulated via UERANSIM deployment
"""

import random
import json

def write_curl_test():
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

    script = []
    
    ##create an the script by providing a continous curl action for each UE to undertake
    for i in range(0,num_of_ues):
        ##randomly select a website 
        rando_website = random.choice(list_of_websites_to_ping)
        ##randomly select a spacing interval to ensure we dont overwhelm any servers
        interval  = random.randint(0, 10)
        ##append script
        script.append(f"watch -n{interval} curl --output /dev/null --interface uesimtun{i} https://www.{rando_website} & \n")

    file_to_write = open("simulation_scripts/curl.sh", "w")
    file_to_write.writelines(script)
    file_to_write.close()
    print("curl.sh written to simulation_scripts/curl.sh")
    
if __name__ == "__main__":
    try:
        write_curl_test()
    except Exception as e:
        print(e)