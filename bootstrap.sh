#!/bin/sh
# bootstraps project directory: WRIG: removes itself

change() {
  echo $new
  find . -type f -name "*" -print0 | xargs -0 sed -i "s/$1/$new/g"
}

change_year() {
  year="<YEAR>"
  new=$(date +"%Y")
  change $year $new
}

change_name() {
  name="\[NAME\]"
  new=$1
  change $name $new
}

change_user() {
  uname=$(git config user.name)
  email=$(git config user.email)
  new="$uname <$email>"

  change "<OWNER>" $new
}

bootstrap() {
  name=$1
  rec=
  while [ "$1" != "" ]; do
    case $1 in
      -r | --rec )  shift
                    rec=$1
                    ;;
      -n | --n ) shift
                    name=$1
                    ;;
     esac
     shift
   done
   if [ -z "$name" ]; then
     echo "No name given, give name"
     read name
   fi
   change_name $name
   change_year
   change_user
   new=$req
   change REQ $rec
   mv main.c $name.c
   rm -rf .git/
   git init
   git add .
   git add -u
   git reset -- bootstrap.sh
   git commit -m "Initialized $name"
   rm -rf bootstrap.sh
}

main() {
  echo "Bootstrap file"
  echo "WARNING: THIS FILE WILL BE DELETED"
  echo "Continue? (y/n)"
  read op
  if [[ "$op" == 'y' ]]; then
    echo "Continuing"
    bootstrap $@
  elif [[ "$op" == 'n' ]]; then
    echo "Your loss"
  else
    echo "$op is not y nor n\nYou rascal!"
  fi
}

main $@

# vim: sw=2 softtabstop=2 expandtab
