# Add my ~/bin to the path
PATH=~/bin:${PATH}

# Remove duplicates
export PATH=$(echo $PATH | tr ':' '\n' | awk '!seen[$0]++' | paste -sd:)
