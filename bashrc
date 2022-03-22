# dotfiles by Jijiang Zhao
# https://github.com/steel911/dotfiles

# Source all files in ~/.bashrc.d/
for file in ~/.bashrc.d/* ; do
    if [ -r $file ]; then
        source $file
    fi
done
