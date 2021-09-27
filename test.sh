#!/bin/bash
clear
# ALL COLOURS FOR SCRIPT
orange=$'\033[0;33m'
lblue=$'\033[1;34m'
red=$'\033[0;31m'
blue=$'\033[34m'
green=$'\033[0;32m'
lgreen=$'\033[1;32m'
reset=$'\033[0m'
#HEADER

echo "${blue}                    .__                                         "${reset};
echo "${blue}______  __ __  _____|  |__        ________  _  _______  ______  "${reset};
echo "${orange}\____ \|  |  \/  ___/  |  \      /  ___/\ \/ \/ /\__  \ \____ \ "${reset};
echo "${blue}|  |_> >  |  /\___ \|   Y  \     \___ \  \     /  / __ \|  |_> >"${reset};
echo "${orange}|   __/|____//____  >___|  /____/____  >  \/\_/  (____  /   __/ "${reset};
echo "${blue}|__|              \/     \/_____/    \/               \/|__|    "${reset};
echo "${blue}            __                   __                             "${reset};
echo "${blue}          _/  |_  ____   _______/  |_  ___________              "${reset};
echo "${orange}          \   __\/ __ \ /  ___/\   __\/ __ \_  __ \             "${reset};
echo "${blue}           |  | \  ___/ \___ \  |  | \  ___/|  | \/             "${reset};
echo "${orange}           |__|  \___  >____  > |__|  \___  >__|                "${reset};
echo "${blue}                     \/     \/            \/                    "${reset};
echo ;
echo "${orange}                by @sshakya for @42Paris                      "${reset};
echo ;
echo "${orange}   run the tester with \"-D\" as an argument for debug mode       "${reset};
echo "${orange}   run your own tests as well !!								"${reset};
echo ;
echo ;
#
#  DEBUG 
#
if [[ "$1" == "-D" ]]
	then
		DEBUG=1
	else
		DEBUG=0
fi
#
# CHECK OS
#

UNAME=`uname`;
TEMP=0

if [[ "$UNAME" == "Linux" ]]
	then
		if [[ ! -f "./checker_linux" ]]
			then
				curl https://projects.intra.42.fr/uploads/document/document/4444/checker_linux -o checker_linux > /dev/null
				chmod 755 checker_linux
			else
				TEMP=1
		fi
		CHECKER=./checker_linux
	else
		if [[ ! -f "./checker_Mac" ]]
			then
				curl https://projects.intra.42.fr/uploads/document/document/4443/checker_Mac -o checker_Mac > /dev/null
				chmod 755 checker_Mac
			else
				TEMP=1
		fi
		CHECKER=./checker_Mac
fi

###############################################

#			TEST STARTS HERE				  #

###############################################

# BASIC ERROR CHECKS


echo "${lblue} ERROR TESTS $reset"
echo ;
echo -ne "${blue} Test : sorted list $reset"
./push_swap 1 >> test.out
./push_swap 1 2 >> test.out
./push_swap 1 2 3 >> test.out
./push_swap 1 2 3 4 >> test.out
./push_swap 1 2 3 4 5 >> test.out
./push_swap 1 2 3 4 5  >> test.out
./push_swap 1 2 3 4 5 6 7 >> test.out
./push_swap 1 2 3 4 5 6 7 8 9 >> test.out

RES=`grep "Error\n" test.out`

if [ $RES ]
	then
		echo "$red KO $reset"
	else
		echo "$green OK ! $reset"
fi

echo -ne "${blue} Test 2: sorted list $reset"

RES=`grep "OK\n" test.out`
if [ $RES ]
	then
		echo "$red KO $reset"
	else
		echo "$green OK ! $reset"
fi
rm test.out

# EMPTY ARGS

echo -ne "${blue} Test : Empty args $reset"
./push_swap "" 2>> test.out
./push_swap "" 1 2 3 2>> test.out
RES=`grep -x "Error$" test.out`
if [[ ! $RES ]]
	then
		echo "$red KO $reset"
	else
		echo "$green OK ! $reset"
fi
rm test.out

# DUPLICATE ARGS

echo -ne "${blue} Test : Duplicated args $reset"
./push_swap "1" 1 2 3 2>> test.out
RES=`grep -x "Error$" test.out`
if [[ ! $RES ]]
	then
		echo "$red KO $reset"
	else
		echo "$green OK ! $reset"
fi
rm test.out

# OVERFLOW

echo -ne "${blue} Test : Overflow int $reset"
./push_swap -2147483649 2>> test.out
./push_swap 2147483648 2>> test.out
RES=`grep -x "Error$" test.out`
if [[ ! $RES ]]
	then
		echo "$red KO $reset"
	else
		echo "$green OK ! $reset"
fi
rm test.out

# WHITESPACE

echo -ne "${blue} Test : whitespace in arg $reset"
./push_swap " 1" 2 3 2>> test.out
./push_swap 42  "   43" 2>> test.out
RES=`grep -x "Error$" test.out`
if [[ ! $RES ]]
	then
		echo "$red KO $reset"
	else
		echo "$green OK ! $reset"
fi
rm test.out

# INVALID CHAR IN ARG

echo -ne "${blue} Test : invalid char in arg $reset"
./push_swap 0 1 2 3 "--1" 2>> test.out
./push_swap 0 1 2 3 "&" 2>> test.out

RES=`grep -x "Error$" test.out`
if [[ ! $RES ]]
	then
		echo "$red KO $reset"
	else
		echo "$green OK ! $reset"
fi
rm test.out

# CHECK ALL SIZES FROM 1 - 100

NTESTS=100
count=1
avg=0
echo ;
touch test.out
echo "${lblue} RUNNING TESTS $reset"
echo -ne "${blue}size 1 - ${NTESTS} stacks\t $reset"
while [ "$count" -le "$NTESTS" ]
do
	if [ $DEBUG == 0 ]
		then
			for X in '-' '/' '|' '\'; do echo -en "\b$X"; sleep 0.1; done;
	fi
	ARG=`ruby -e "puts (0..$count).to_a.shuffle.join(' ')"`;
	if [ $DEBUG == 1 ]
		then	
			echo ;
			echo "${blue}stack size = $count ${reset}";
			echo $ARG
			echo -ne "checker => "
			RET=` ./push_swap $ARG | ./$CHECKER $ARG ; `
			if [[ "$RET" == "OK" ]]
				then
					echo "$green OK $reset"
				else
					echo "$red FAIL $reset"
			fi
	fi
	./push_swap $ARG | ./$CHECKER $ARG > test.out
	let "count += 1"
done
echo -e "\b -- $orange DONE $reset"

RES=`grep KO test.out`
if [ $RES ]
	then
		echo "checker => $red KO $reset"
	else
		echo "checker => $green OK ! $reset"
fi

rm test.out
echo ;

# CHECK FOR STACK SIZE OF 3 -- WITH MOVE LIST

NTESTS=5

count=0
avg=0
echo "${lblue}3 stack -- running ${NTESTS} tests ${reset}"
while [ "$count" -le $NTESTS ]
do
	ARG=`ruby -e "puts (1..3).to_a.shuffle.join(' ')"`;
	echo -n "${green} stack = " ; echo ${lgreen} $ARG ${reset} ; echo -n "${reset}" ;
	echo -n ${orange} ; ./push_swap $ARG ; echo -n ${reset} ;
	echo -n "checker => "
	echo -n ${green} ; ./push_swap $ARG | ./$CHECKER $ARG ; echo -n ${reset} ;
	let "count += 1"
done

# CHECK FOR STACK SIZE 5

echo ;
NTESTS=15
count=1
avg=0
MAX=0
MIN=2147483647
echo "${lblue}5 stack -- running ${NTESTS} tests ${reset}"
while [ "$count" -le $NTESTS ]
do
	ARG=`ruby -e "puts (1..5).to_a.shuffle.join(' ')"`;
	TOT=`./push_swap $ARG | wc -l`
	./push_swap $ARG | ./$CHECKER $ARG >> test.out
	if [ "$TOT" -ge "$MAX" ]
		then
			MAX=${TOT}
	fi
	if [ "$TOT" -le "$MIN" ]
		then
			MIN=${TOT}
	fi
	avg=$((avg+TOT))
	let "count += 1"
done

avg=$((avg/NTESTS))
echo -n "${blue}Average move count is : ${reset}"
echo $avg
echo "${orange} MAX =${reset} ${MAX}"
echo "${green} MIN =${reset} ${MIN}"

RES=`grep KO test.out`
if [ $RES ]
	then
		echo "$red $RES $reset"
	else
		echo "checker => $green OK ! $reset"
fi

rm test.out

# MOVES FOR 100 stacks
echo ;
NTESTS=100
count=1
avg=0
MAX=0
MIN=2147483647
echo -ne "${lblue}100 stack -- running ${NTESTS} tests\t ${reset}"
while [ "$count" -le $NTESTS ]
do
	for X in '-' '/' '|' '\'; do echo -en "\b$X"; sleep 0.1; done;
	ARG=`ruby -e "puts (0..99).to_a.shuffle.join(' ')"`;
	TOT=`./push_swap $ARG | wc -l`
	./push_swap $ARG | ./$CHECKER $ARG >> test.out
	if [ "$TOT" -ge "$MAX" ]
		then
			MAX=${TOT}
	fi
	if [ "$TOT" -le "$MIN" ]
		then
			MIN=${TOT}
	fi
	avg=$((avg+TOT))
	let "count += 1"
done
echo -e "\b -- $orange DONE $reset"

avg=$((avg/NTESTS))
echo -n "${blue}Average move count is : ${reset}"
echo $avg
echo "${orange} MAX =${reset} ${MAX}"
echo "${green} MIN =${reset} ${MIN}"

RES=`grep KO test.out`
if [ $RES ]
	then
		echo "$red $RES $reset"
	else
		echo "checker => $green OK ! $reset"
fi
rm test.out

# AVERAGE MOVES FOR 500 stacks
echo ;
count=1
avg=0
MAX=0
MIN=2147483647

echo -ne "${lblue}500 stack -- running ${NTESTS} tests\t ${reset}"
while [ "$count" -le $NTESTS ]
do
	for X in '-' '/' '|' '\'; do echo -en "\b$X"; sleep 0.1; done;
	ARG=`ruby -e "puts (0..499).to_a.shuffle.join(' ')"`;
	TOT=`./push_swap $ARG | wc -l`
	./push_swap $ARG | ./$CHECKER $ARG >> test.out
	if [ "$TOT" -ge "$MAX" ]
		then
			MAX=${TOT}
	fi
	if [ "$TOT" -le "$MIN" ]
		then
			MIN=${TOT}
	fi
	avg=$((avg+TOT))
	let "count += 1"
done
echo -e "\b -- $orange DONE $reset"

avg=$((avg/NTESTS))
echo -n "${blue}Average move count is : ${reset}"
echo $avg
echo "${orange} MAX =${reset} ${MAX}"
echo "${green} MIN =${reset} ${MIN}"

RES=`grep KO test.out`
if [ $RES ]
	then
		echo "$red $RES $reset"
	else
		echo "checker => $green OK ! $reset"
fi
rm test.out
if [ $TEMP = 0 ]
	then
		rm $CHECKER
fi

echo ;
