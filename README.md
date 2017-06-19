# brew-ds

[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)

> A Data Scientist is just a statistician with a Mac

`brew-ds` aims to set up your MacOS system with common Data Science tools using the package manager [brew](https://brew.sh/), R's `install.packages` and python's `pip`.


## Usage

Default usage

```bash
git clone git@github.com:nathaneastwood/brew-ds.git
cd brew-ds
. build.sh
```

This installs in verbose mode by default. If you would like to use quiet mode and reduce output then please use the `-q` flag.
You will be prompted for your password, administrator privileges are required to install some pre-requisite software (xcode command line tools).

## Included software

* Python 3
  - Pandas
  - Numpy
  - Scipy
  - Statsmodels
  - SciKit-Learn
  - Bokeh
  - Seaborn
* R
  - Tidyverse
  - RMarkdown
  - Shiny
  - mlR
* MacTeX
* Slack

## Warning

Linux is **deprecated**. A linux user should build a better version for their system or perhaps a group should be made for linuxbrew that does it all through that.


