import random
import json

def write_ping_test(): 
    
    master_test_file = open('test_case_values.json')
    master_test_file = json.load(master_test_file)
    data_emulation_values = master_test_file["testCases"]["dataRequestEmulation"]
    
    list_of_websites_to_ping = data_emulation_values["webisteList"]
    num_of_ues = data_emulation_values["ueBatchSize"]
    num_of_pings = data_emulation_values["num_of_pings"]
    packet_size_bytes = data_emulation_values["packet_size_bytes"]

    script = []
    
    for i in range(0,400):
        rando_website = random.choice(list_of_websites_to_ping)
        interval  = random.randint(0, 10)
        script.append(f"ping -I uesimtun{i} {rando_website}  -s {packet_size_bytes} -i {interval} -c {num_of_pings} & \n")

    file_to_write = open("test_cases/ping.sh", "w")
    file_to_write.writelines(script)
    file_to_write.close()
