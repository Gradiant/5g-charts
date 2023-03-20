
def write_populate_script(numUE = 1350):
    population_size = numUE
    script = []
    for i in range(1,1350):
        if(i>=0 and i<10):
            L.append(f"open5gs-dbctl add_ue_with_slice 99970000000000{i} 465B5CE8B199B49FAA5F0A2EE238A6BC E8ED289DEBA952E4283B54E88E6183CA internet 1 111111 \n")

        if(i>=10 and i<100):
            L.append(f"open5gs-dbctl add_ue_with_slice 9997000000000{i} 465B5CE8B199B49FAA5F0A2EE238A6BC E8ED289DEBA952E4283B54E88E6183CA internet 1 111111 \n")

        if(i>= 100 and i<1000):
            L.append(f"open5gs-dbctl add_ue_with_slice 999700000000{i} 465B5CE8B199B49FAA5F0A2EE238A6BC E8ED289DEBA952E4283B54E88E6183CA internet 1 111111 \n")

        if(i>= 1000 and i<10000):
            L.append(f"open5gs-dbctl add_ue_with_slice 99970000000{i} 465B5CE8B199B49FAA5F0A2EE238A6BC E8ED289DEBA952E4283B54E88E6183CA internet 1 111111 \n")

        if(i>0 and i%50 ==0):
             L.append("sleep 2 \n")


    file_to_write = open("simulation_scripts/ue_populate.sh", "w")
    file_to_write.writelines(L)
    file_to_write.close()

