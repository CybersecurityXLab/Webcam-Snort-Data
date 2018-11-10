end=$(( $(date +%s)+300))

proc_threshold_1=9.1317933074
proc_threshold_2=10.1181151734
data_threshold_1=0.887956616969
data_threshold_2=0.893853353866
user_threshold_1=9.630762963
user_threshold_2=50.2441303704
syst_threshold_1=19.7449875479
syst_threshold_2=22.6555727969
idle_threshold_1=65.3479473684
idle_threshold_2=69.7970453216
conn_threshold_1=5.6243559073
conn_threshold_2=5.776472212

sleep 5

while [ $(date +%s) -lt $end ]
do
	curr_time=$(date)

	proc_data=$( echo "$(ps -w | awk '{ if ($3!="0" && $3!="VSZ" && !($5 ~ /awk/)) { print $0 }}' | wc -l)")

	if [ $(awk -v a="$proc_data" -v b="$proc_threshold_1" 'BEGIN {print (a>=b)}') -eq 1 ]
	then
		echo "$curr_time : High Number of Processes, Threshold 1" >> alerts.txt
	fi
	if [ $(awk -v a="$proc_data" -v b="$proc_threshold_2" 'BEGIN {print (a>=b)}') -eq 1 ]
	then
		echo "$curr_time : High Number of Processes, Threshold 2" >> alerts.txt
	fi

	top_line=$( echo "$(top -b -n 1 | head -n 2)")
	top_data=$( echo "$(echo $top_line | head -n 1 | awk '{print $2 / ($4 + $2)}' )")

	if [ $(awk -v a="$top_data" -v b="$data_threshold_1" 'BEGIN {print (a>=b)}') -eq 1 ]
	then
		echo "$curr_time : High Data Usage, Threshold 1" >> alerts.txt
	fi
	if [ $(awk -v a="$top_data" -v b="$data_threshold_2" 'BEGIN {print (a>=b)}') -eq 1 ]
	then
		echo "$curr_time : High Data Usage, Threshold 2" >> alerts.txt
	fi
	
	top_user=$( echo "$(echo $top_line | tail -n 1 | awk '{print $13 / 1}')")

	if [ $(awk -v a="$top_user" -v b="$user_threshold_1" 'BEGIN {print (a>=b)}') -eq 1 ]
	then
		echo "$curr_time : High Usr CPU Usage, Threshold 1" >> alerts.txt
	fi
	if [ $(awk -v a="$top_user" -v b="$user_threshold_2" 'BEGIN {print (a>=b)}') -eq 1 ]
	then
		echo "$curr_time : High Usr CPU Usage, Threshold 2" >> alerts.txt
	fi

	top_syst=$( echo "$(echo $top_line | tail -n 1 | awk '{print $15 / 1}')")
	
	if [ $(awk -v a="$top_syst" -v b="$syst_threshold_1" 'BEGIN {print (a>=b)}') -eq 1 ]
	then
		echo "$curr_time : High Sys CPU Usage, Threshold 1" >> alerts.txt
	fi
	if [ $(awk -v a="$top_syst" -v b="$syst_threshold_2" 'BEGIN {print (a>=b)}') -eq 1 ]
	then
		echo "$curr_time : High Sys CPU Usage, Threshold 2" >> alerts.txt
	fi

	top_idle=$( echo "$(echo $top_line | tail -n 1 | awk '{print $19 / 1}')")
	
	if [ $(awk -v a="$top_idle" -v b="$idle_threshold_1" 'BEGIN {print (a>=b)}') -eq 1 ]
	then
		echo "$curr_time : High Idle CPU Usage, Threshold 1" >> alerts.txt
	fi
	if [ $(awk -v a="$top_idle" -v b="$idle_threshold_2" 'BEGIN {print (a>=b)}') -eq 1 ]
	then
		echo "$curr_time : High Idle CPU Usage, Threshold 2" >> alerts.txt
	fi
	
	nets_data=$( echo "$(netstat -aelptuwx | awk '{if ($0 ~ /LISTEN/ || $0 ~ /ESTABLISHED/) { print $0 }}' | wc -l)")
	
	if [ $(awk -v a="$nets_data" -v b="$conn_threshold_1" 'BEGIN {print (a>=b)}') -eq 1 ]
	then
		echo "$curr_time : High Number of Connections, Threshold 1" >> alerts.txt
	fi
	if [ $(awk -v a="$nets_data" -v b="$conn_threshold_2" 'BEGIN {print (a>=b)}') -eq 1 ]
	then
		echo "$curr_time : High Number of Connections, Threshold 2" >> alerts.txt
	fi
	
	sleep 1
done

ping 192.168.10.11 -c 3
