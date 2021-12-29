if [ -x /usr/games/cowsay -a -x /usr/games/fortune ]; then
    fortune | cowsay
fi
# disable terminal freeze when clicking Ctrl-s
stty -ixon

alias targz_extract="tar -xvf"
alias vi=vim
alias vim="stty stop '' -ixoff; vim"
#alias ls="ls -altrh"


# run gdb until program bombs & print stack trace
alias gdb_trace="gdb --batch --ex r --ex bt --ex q --args"
alias lsblk="lsblk -o name,mountpoint,label,size,uuid"
alias lsblk-hd="lsblk -d -o name,rota"

# make an environment variable for my cscope db
export CSCOPE_SRC=~/.cscope
export CSCOPE_EDITOR=vim

# set OPENCV_TEST_DATA_PATH environment variable to <path to opencv_extra/testdata>.
export OPENCV_TEST_DATA_PATH=/media/yoo/develop/opencv_extra/testdata

export VISUAL="nano"

#if [[ ! $TERM =~ screen ]]; then
#    exec tmux
#fi
export TESSDATA_PREFIX=/usr/share/tesseract-ocr/4.00/tessdata
export EDITOR='gedit'
export ANDROID_SDK_HOME=/media/yoo/data/Android
#export LC_ALL=C
#export LC_CTYPE=C
#export LC_NUMERIC=C
#setlocale(LC_ALL,"C");
#setlocale(LC_CTYPE,"C");
#setlocale(LC_NUMERIC,"C");

#//export PATH=~/opt/bin:$PATH
#//or this?
#//export PATH=$PATH:~/opt/bin
