import time
import os

os.system("sudo tcpdump -i enp59s0 -vv >> live_tcpdump.txt &")

last_read_line = 0

for i in range(5):
	tcpdump_file = open("live_tcpdump.txt", "r")

	count = 0

	for line in tcpdump_file:
		if count > last_read_line and "ICMP" in line and "length 18" in line:
			print("YAY")

		count += 1

	last_read_line = count

	time.sleep(5)

	f.close()
