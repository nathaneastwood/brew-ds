# Install brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# Install from Brewfile
brew bundle
# Install common R packages
Rscript -e "install.packages(c('tidyverse', 'rmarkdown', 'shiny', 'mlr'), repos = 'https://cloud.r-project.org/')"