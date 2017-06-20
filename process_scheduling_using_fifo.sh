#!/bin/bash
# total number of jobs to run
Njob=15
# maximum processes running at same time
Nproc=5

# get to fifo file through fd 777
mkfifo ./fifo.$$ && exec 777<> ./fifo.$$ && rm -f ./fifo.$$

for((i=0;i<$Nproc;i++));do
    echo "init time add $i" >&777
done

function run_a_job(){
    i=$1
    echo "progress $i is running..."
    sleep 3
    echo "progress $i is done..."
}

for ((i=0;i<$Njob;i++));do
    {
        # read a line from fifo file
        read -u 777
        # run a job
        run_a_job $i
        # write a line to fifo file
        echo "real time add $(($i+$Nproc))" 1>&777
    }&
done
wait
echo -e "time-consuming: $SECONDS seconds"

