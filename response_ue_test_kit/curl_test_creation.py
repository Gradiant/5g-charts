import random



def write_curl_test():
     list_of_websites_to_ping = ["buzzfeed.com","asos.com","indiatimes.com","tesla.com","nbc.com","reuters.com","npr.org","wsj.com","washingtonpost.com","foxnews.com","abcnews.go.com","bostonherald.com"]
     num_of_curls = 10000
     script = []
     num_of_ues = 400


     for i in range(0,num_of_ues):
          rando_website = random.choice(list_of_websites_to_ping)
          interval  = random.randint(0, 10)
          script.append(f"watch -n{interval} curl --output /dev/null --interface uesimtun{i} https://www.{rando_website} & \n")

     file3 = open("curl.sh", "w")
     file3.writelines(script)
     file3.close()

def main():
     write_curl_test()