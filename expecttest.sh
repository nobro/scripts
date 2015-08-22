eval spawn ssh -oStrictHostKeyChecking=no -oCheckHostIP=no USER@HOST -p PORT
#use correct prompt
set prompt ":|#|\\\$"
interact -o -nobuffer -re $prompt return
send "PAROLA TA\r"
interact -o -nobuffer -re $prompt return
send "ls\r"
interact -o -nobuffer -re $prompt return
send "df -h\r"
interact -o -nobuffer -re $prompt return
send "logout\r"
interact
