# brew-ds

[![Build Status](https://travis-ci.org/nathaneastwood/brew-ds.svg?branch=master)](https://travis-ci.org/nathaneastwood/brew-ds)

> A Data Scientist is just a statistician with a Mac

`brew-ds` aims to set up your MacOS or linux system with common Data Science tools using the package manager [brew](https://brew.sh/), R's `install.packages` and python's `pip`. Linux users please see [linuxbrew](https://linuxbrew.sh).

## Usage

Default usage

```bash
git clone git@github.com:nathaneastwood/brew-ds.git
cd brew-ds
. build.sh
```


This installs in verbose mode by default. If you would like to use quiet mode and reduce output then please use the `-q` flag.


You may be prompted for your password.


## Warning

Linux is untested but hopefully doesn't work too terribly. We have not attempted to add any PPAs, portage overlays, AUR packages etc. as you might not want them on your system.


