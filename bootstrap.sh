#!/bin/sh
# bootstraps project directory: WRIG: removes itself

change() {
  echo $1 $2
  find . -type f -name "*" -print0 | xargs -0 sed -i "s/$1/$2/g"
}

change_year() {
  year="2020"
  y=$(date +"%Y")
  change $year $y
}

change_name() {
  name="\[NAME\]"
  n=$1
  change $name $n
}

change_user() {
  name=$(git config user.name)
  email=$(git config user.email)
  new="$name <$email>"

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
   change_name $name
   change_year
   change_user
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
