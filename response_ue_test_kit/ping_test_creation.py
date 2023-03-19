import random

list_of_websites_to_ping = ["buzzfeed.com","asos.com","indiatimes.com","tesla.com","nbc.com","reuters.com","npr.org","wsj.com","washingtonpost.com","foxnews.com","abcnews.go.com","bostonherald.com"]
num_of_pings = 10000
packet_size_bytes = 60000

script = []


for i in range(0,400):
     rando_website = random.choice(list_of_websites_to_ping)
     interval  = random.randint(0, 10)
     script.append(f"ping -I uesimtun{i} {rando_website}  -s {packet_size_bytes} -i {interval} -c {num_of_pings} & \n")

file2 = open("ping.sh", "w")
file2.writelines(script)
file2.close()
