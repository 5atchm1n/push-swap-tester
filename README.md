# push-swap-tester

## USE THIS TO TEST YOUR PROJECT -> NOT GRADE THEM !! ⚠️

### Tester for push swap

Runs test for some common errors ex : int overflow.

Checks that your algorithm sorts all stack sizes from 1 to 100.

Number are generated via this command.

``` ARG=`ruby -e "puts (0..99).to_a.shuffle.join(' ')"`; ```

### Performance checks

Runs multiple passes on different stack sizes and returns average, min and max move count ```./push_swap | wc -l```

## Usage

run the script from the root of your push_swap repository

``` ./test.sh```

run ```./test.sh -D``` to get debug output (stack detail)

run your own tests as well :smiley:
Try to write your own shell scripts ❕

Give us a ⭐ if you liked it !!
