#!/usr/bin/env bash
set -e

# Install brew, use brew to install system files and then use R and python
# package managers to install their recommended packages/modules

# Determine which mode we are to operate in
# 
#+NOTE: allow a quiet mode which uses brew bundle and a verbose mode which
#       reels off each package individually and has a progress bar
while getopts "qh" option; do
  case ${option} in
    q)  mode="quiet";;
    h)  mode="help";;
    *)  mode="verbose";;
  esac
done


#-- Functions -------------------------------------------------------------------

# Function to decide on brew location by system.
# We are going to use the defaults for brew on MacOS and linux so if you have
# a custom setup then this needs to be edited
install_brew () {
  # install brew
  /usr/bin/ruby -e "$(curl -fsSL "`
    `"https://raw.githubusercontent.com/Homebrew/install/master/install)"


  ## Make sure your PATH variable is as we expect
  if [[! -x ~/.profile ]]; then touch ~/.profile; fi

  echo $PATH | grep -q $brew_loc || test=0

  if [[$test == 0]]; then
    export PATH=$brew_loc:$PATH
  fi

  ## Refresh your command index to make sure everything is available
  hash -r
}

#+WIP
install_verbose() {
  # need to know how many things are being installed
  length=`cat Brewfile | wc -l`

  echo ""
  # for each item get the row from Brewfile and install it, then echo percentage
  for i in `seq 1 $length`
  do
    brew install `
      sed "$(i)q;d" Brewfile |
      sed "s/[a-z]* '\(.*\)'/\1/"
    ` 1>/dev/null

    printf "            $((100 * i / length))\% complete\r"
  done

}



#-- Program ---------------------------------------------------------------------

if [[ $mode == 'help' ]]; then
  echo "Help coming soon"
  exit 1
fi


## check internet connection - writing output to /dev/null
## we just want the exit code
/usr/bin/env curl -D- -s http://www.google.com 1>/dev/null
if [[ $? -eq 0 ]]; then
  echo "* Installing software"

  # figure out which OS we are on and set the expected brew location
  case $OSTYPE in
    darwin*)
      brew_loc="/usr/local/bin"
      cat base_brew mac_brew > Brewfile
      ;;
    linux-gnu)
      # set location
      brew_loc="~/.linuxbrew/bin"
      cp base_brew Brewfile
      ;;
    *) echo "    -- Your OS is not currently supported, exiting"; exit 1 ;;
  esac


  ## check to see if brew already exists, if it does skip installation
  command -v brew >/dev/null && echo "* brew exists, skipping" || install_brew

  # Install from Brewfile
  echo "    -- installing brew software, this may take some time"

  if [[ $mode == 'quiet' ]]; then
    brew tap homebrew/bundle
    brew bundle 1>/dev/null
  else
    install_verbose
  fi


  # on linux try to install all the extra bits that we bring in from cask
  # NOTE: I haven't tested all the package managers, some apps might not be
  # found - please raise an issue if this is the case
  if [[ $OSTYPE == "linux-gnu" ]]; then
    # figure out whether we can sudo or not
    if [[ -x "$(which sudo)" ]]; then
      sudo -v
      if [[ $? == 0 ]]; then
        privs=sudo
      else
        privs=su -c
      fi
    fi

    # figure out which package manager command to use and install the extras
    if   [ -x "$(which apt-get)"]; then
      cat etc/debian | xargs $privs apt-get install
    elif [ -x "$(which yum)" ]; then
      cat etc/fedora | xargs $privs yum install
    elif [ -x "$(which eopkg)" ]; then
      cat etc/solus | xargs $privs eopkg it
    elif [ -x "$(which pacman)" ]; then
      cat etc/arch | xargs $privs pacman -S
    elif [ -x "$(which emerge)" ]; then
      cat etc/gentoo | xargs $privs emerge
    else
      echo "Sorry, I forgot your package manager, please file an issue"
      exit 2
    fi
  fi

  rm Brewfile

  # Install common R packages (I work too hard, redirecting outputs...)
  printf "    -- installing R packages\n       \u25B3 this can take some time\n"
  R --no-save <<'  END'
    for (package in c('tidyverse', 'rmarkdown', 'shiny', 'mlr')) {
      message(paste("    \u25b3  gsInstalling ", package))
      capture.output(
        install.packages(package),
        file = "install.log",
        append = TRUE
      )
    }
  END


  # Install common python modules
  echo "    -- installing python modules"
  pip3 install -r requirements.txt 1>>install.log

  printf "** Install complete \n    - for information please see install.log"

else # curl failed to connect to google.com

  echo "* There is no internet connection, exiting."

fi

