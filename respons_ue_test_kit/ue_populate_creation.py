"""
Module to create a script to populate the open5gs mongo db with the information of UEs. 
"""

import json


def write_populate_script():
    """
    Write script that to be run inside of the populate pod in OPEN5GS that populate MongoDB with UEs.

    PARAMETERS
    ----------
        None.

    Returns
    -------
        None. Updates 'simulation_scripts/ue_populate.sh'.
    """

    # Load test_case_values json to read in the test case paremeters.
    master_test_file = open("test_case_values.json")
    master_test_file = json.load(master_test_file)
    data_emulation_values = master_test_file["testCases"]["dataRequestEmulation"]

    population_size = (
        data_emulation_values["ueBatchSize"] # 400
        * data_emulation_values["numUEBatches"] # 2
    ) # 800

    command = "open5gs-dbctl add_ue_with_slice" # to add a UE to the MongoDB. Arguemnts needed.

    mcc = "999" # mobile country code
    mnc = "70" # mobile network code
    initial_msisdn = "0000000000" # Mobile Station Integrated Services Digital Network identifies a UE subscription.

    # Define arguments for the command.
    initial_imsi = int(mcc + mnc + initial_msisdn) #international mobile subscriber identity, = [MCC|MNC|MSISDN] 
    key = "465B5CE8B199B49FAA5F0A2EE238A6BC" # key, encryption key for SIM, to be kept secret, called "secret key" or K-key
    opc =  "E8ED289DEBA952E4283B54E88E6183CA" # opc, the core network's key.
    # The above two keys are used for EAP-AKA’ authentication, one of two kinds allowed in 5G (the other being 5G-AKA). 
    # In the registration process for a SIM, the keys are stored in both the UE and the (4g HSS)or(5G UDM)
    # For authenticatioion, UE and HSS use the same hashing funcion f.
    # The HSS generates a random string RAND, and calculates AUTN = f(RAND, key, OPc) and sends AUTN and RAND to UE. 
    # UE then calculates XAUTN = f(RAND, key, OPc) and accepts connection of XAUTH==AUTN. 
    # Then the UE calculates RES = f(RAND,key,OPc) and sends it to HSS who compares it to XRES. 
    apn =  "internet" # apn, access point name, 4G speak for Data Network Name (DNN), 
                    # you can configure a DNN on a AR router (back compatability) so this is effectively a 5G DNN
    sst = "1" # sst is slice service type, 1 os for enhanced mobile braodband (eMBB)
    sd= "111111" # sd is slice differentiator; there can be multiple slices of the same sst, differentiated by sd.

    last_args_as_string = " ".join([key,opc,apn,sst,sd])

    script = []

    # Add a line to the script for each UE we will add to MongoDB.
    for i in range(1, population_size + 1):
        # Sleep every 50 Adding a sleep line in the script to ensure mongodb doesnt crash from large requests.
        if i > 0 and i % 50 == 0:
            script.append("sleep 2 \n")
        script.append(
            " ".join([command, 
                      str(initial_imsi + i),
                      last_args_as_string
                    ])
            )

    file_to_write = open("simulation_scripts/ue_populate.sh", "w")
    file_to_write.writelines(script)
    file_to_write.close()
    print("ue_populate.sh written to simulation_scripts/ue_populate.sh")


if __name__ == "__main__":
    try:
        write_populate_script()
    except Exception as e:
        print(e)
