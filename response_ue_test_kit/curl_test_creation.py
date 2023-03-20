import random
import json

def write_curl_test():
    
    master_test_file = open('test_case_values.json')
    master_test_file = json.load(master_test_file)
    data_emulation_values = master_test_file["testCases"]["dataRequestEmulation"]
    
    list_of_websites_to_ping = data_emulation_values["webisteList"]
    num_of_ues = data_emulation_values["ueBatchSize"]

    script = []
    
    for i in range(0,num_of_ues):
        rando_website = random.choice(list_of_websites_to_ping)
        interval  = random.randint(0, 10)
        script.append(f"watch -n{interval} curl --output /dev/null --interface uesimtun{i} https://www.{rando_website} & \n")

    file_to_write = open("test_cases/curl.sh", "w")
    file_to_write.writelines(script)
    file_to_write.close()

