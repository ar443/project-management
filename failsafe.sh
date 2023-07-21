#!/bin/bash
process="queue:work";
#To run 5 process pass value 6.
no_of_process=3;
running_ps=$(ps aux  | grep "$process" | wc -l)
if [[ "$running_ps" -lt "$no_of_process" ]]; then
    echo "Currently running $running_ps process.Starting new processes."
    for i in $(eval echo "{$running_ps..$no_of_process}")
    do
    sleep 2 && cd "$PWD" &&  php artisan queue:work --queue=default,high,low --timeout 400 --sleep 7 --tries 2 &>/dev/null &
    done
elif [[ "$running_ps" -gt "$no_of_process" ]]; then
    echo "Killing process";
    PIDS=$(ps -ef | grep "${process}" | awk '{print $2}');
    for PID in $PIDS
    do
     sleep 2 && kill -s TERM $PID &>/dev/null &
    done;
    echo "Running again processes"
    START=2;
    END="${no_of_process}";
    for i in $(eval echo "{$START..$END}")
    do
       sleep 2 && cd "$PWD" &&  php artisan queue:work --queue=default,high,low --timeout 400 --sleep 7 --tries 2 &>/dev/null &
    done
else
    echo "Already running $running_ps process"
fi


#echo "Killing process";
#    PIDS=$(ps -ef | grep "${process}" | awk '{print $2}');
#    for PID in $PIDS
#    do
#      kill -9 $PID && sleep 2 &>/dev/null &
#    done;
