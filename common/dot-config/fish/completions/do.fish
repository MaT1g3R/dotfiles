complete -e -c do
complete -f -c do
for line in (string split \n (DO_HELP_SKIP_INTRO=1 ./do help))
  set cmd (string split \t $line)
  complete -c do  -a $cmd[1] -d $cmd[2]
end
