#! /bin/bash
if [ $# -ne 1 ]
then
    echo "Missing arguments."
    echo "Usage: ./Tester.sh [CPPFILE]"
    echo "Goobye"
    exit 1
fi

IN="input.#.in"
CPP="g++ -o $1.out"
OUT="output.#.out"
red='\033[0;31m'
RED='\033[1;31m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
green='\033[0;32m'
WHITE='\033[1;37'
YELLOW='\33[1;33m'
BOLD="\e[1m"
NOCOL='\033[0m'
cppFile="$1"
COMPILER="$CPP $1 2> .compile_report"
TL=1

if [ -f "$cppFile" ] && [ "${cppFile##*.}" == 'cpp' ]
then
    printf ""
else
    echo "Where are the files? you have to enter the as arguments"
    exit 1
fi

printf "${BOLD}${YELLOW}COMPILING...\n${NOCOL}"
sleep 1
echo "$COMPILER" | sh
if [ $? -ne 0 ]
then
    printf "${BOLD}${RED}Oh oh looks like you have compile errors!\n${NOCOL}"
    read -p "⤷ Do you want to see the log?(Y/N):" confirm

    if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]
    then
        echo "OK"
        sleep 0.4
        echo "Here you are"
        sleep 0.5
        echo "********************************************************"
        cat .compile_report
        echo "********************************************************"
        exit 1
    elif [[ $confirm == [nN] || $confirm == [nN][oO] ]]
    then
        echo "OK"
        sleep 0.8
        echo "So i'm done here"
        sleep 0.8
        echo "Goobye!"
        sleep 0.6
        exit 1
    else
        exit 1
    fi
else
    printf "${BOLD}${GREEN}Congratulations your code compiled succesfully\n${NOCOL}"
fi

echo "Starting the testing phase..."
sleep 1.5

cnt=`cat inputfile.txt | wc -l`
echo $cnt
well_done=0
ulimit -t $TL;

for (( i=1; i<=$cnt; i++ ));
do
  TEST_CASE_IN=`echo $IN | sed "s/#/$i/g"`
  TEST_CASE_OUT=`echo $OUT | sed "s/#/$i/g"`

  if [ ! -e $TEST_CASE_IN ]
  then
    break
  fi

  echo -e "${BLUE}Test case $i:${NOCOL}";

  time -p (./a.out < $TEST_CASE_IN > uselessfile) 2> .time_info;

  EX_CODE=$?;
  if [ $EX_CODE -eq 137 ] || [ $EX_CODE -eq 152 ]
  then
    echo -e " ${RED}X TLE: Time Limit Exceeded${NOCOL}";
    echo -ne "${RED}TLE\n" >> .overview;
  elif [ $EX_CODE -ne 0 ]
  then
    echo -e "${RED}X RE: Runtime Error${NOCOL}";
    echo -ne "${RED}RE\n" >> .overview;
else
    # PROG_TIME=`cat .time_info | grep real | cut -d" " -f2`;
    ./a.out<$TEST_CASE_IN > uselessfile
    diff -q "uselessfile" $TEST_CASE_OUT
    if [ $? -eq 0 ]
    then
        echo -e " ${GREEN}* OK${NOCOL} [$PROG_TIME]"
        echo -n "${GREEN}COR" >> .overview
        CORRECT=`expr $CORRECT + 1`
    else
        echo -e " ${RED}X WA: Wrong Answer${NOCOL} [$PROG_TIME]"
        echo -ne "${RED}WA\n" >> .overview
    fi
  fi

  echo;
done
N=`expr $i - 1`
echo
echo -n >> .overview

read -p"Do you wan to keep the files made to run your tests (including .overview and .compiler_report), I recommand you keep them in case of you had a wrong anwser? (Y/N):" last_check
if [[ $last_check == [yY] || $last_check == [yY][eE][sS] ]]
then
    printf ""
else
    rm -f .overview .compile_report .time_info .$1.out
    trap "{ rm -f .overview .compiler_report .$1.out; }" SIGINT SIGTERM EXIT
fi

if [[ $CORRECT == $N ]]
then
    printf "${GREEN}WELL DONE!, tests passed without error or wrong answers${NOCOL}\n"
else
    printf "${RED}Happy debugging!, open .overview file for more info\n"
fi
