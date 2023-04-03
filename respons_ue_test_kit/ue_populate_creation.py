"""
Module to create a script to populate the open5gs mongo db with the information of UEs. 
"""

import json


def write_populate_script():
    """
    Write script that can be run inside of the populate pod in OPEN5GS to populate UEs.

    PARAMETERS
    ----------
    None

    RETURNS
    ------- 
    None. Updating simulation_scripts/ue_populate.sh script to populate open5gs mongodbgi
    """

    # load test_case_values json to read in the test case paremeters
    master_test_file = open("test_case_values.json")
    master_test_file = json.load(master_test_file)
    data_emulation_values = master_test_file["testCases"]["dataRequestEmulation"]

    population_size = (
        data_emulation_values["ueBatchSize"] * data_emulation_values["numUEBatches"]
    )

    script = []

    # create the script, adding a line for every ue we will add to the mongodb
    for i in range(1, population_size + 1):
        if 0 <= i < 10:
            script.append(
                f"open5gs-dbctl add_ue_with_slice 99970000000000{i} 465B5CE8B199B49FAA5F0A2EE238A6BC E8ED289DEBA952E4283B54E88E6183CA internet 1 111111 \n"
            )

        if 10 <= i < 100:
            script.append(
                f"open5gs-dbctl add_ue_with_slice 9997000000000{i} 465B5CE8B199B49FAA5F0A2EE238A6BC E8ED289DEBA952E4283B54E88E6183CA internet 1 111111 \n"
            )

        if 100 <= i < 1000:
            script.append(
                f"open5gs-dbctl add_ue_with_slice 999700000000{i} 465B5CE8B199B49FAA5F0A2EE238A6BC E8ED289DEBA952E4283B54E88E6183CA internet 1 111111 \n"
            )

        if 1000 <= i < 10000:
            script.append(
                f"open5gs-dbctl add_ue_with_slice 99970000000{i} 465B5CE8B199B49FAA5F0A2EE238A6BC E8ED289DEBA952E4283B54E88E6183CA internet 1 111111 \n"
            )
        # adding a sleep line in the script to ensure mongodb doesnt crash from large reqeusts
        if i > 0 and i % 50 == 0:
            script.append("sleep 2 \n")

    file_to_write = open("simulation_scripts/ue_populate.sh", "w")
    file_to_write.writelines(script)
    file_to_write.close()
    print("ue_populate.sh written to simulation_scripts/ue_populate.sh")


if __name__ == "__main__":
    try:
        write_populate_script()
    except Exception as e:
        print(e)
