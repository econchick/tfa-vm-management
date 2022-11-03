# To configure your VM with python3, run the following single line of code 
# at the command line from the VM (don't copy the "#" or the "$"):
#     $ curl -fsSL https://raw.githubusercontent.com/econchick/tfa-vm-management/main/vm/configure.sh | bash
LOCK_FILE=/tmp/config-lock

if [[ -f "$LOCK_FILE" ]]; then
        echo "Configuration is already running. Configuration started at ..."
        cat $LOCK_FILE
        echo "If the configuration is taking more than an hour, "
        echo "Please run the following command and then restart the configuration scirpt:"
        echo "  $ rm $LOCK_FILE"
        exit 1;
else
        echo "Starting Configuration"
        echo $(date) > $LOCK_FILE
fi

START_TS=$SECONDS

sudo apt-get update
sudo apt-get install -y \
        build-essential \
        bash-completion \
        libffi-dev \
        python3-venv \
        python-dev \
        sqlite3 \
        libsqlite3-dev \
        libreadline-dev \
        openssl \
        libssl-dev \
        libpq-dev \
        liblzma-dev \
        libbz2-dev \
        zlib1g-dev \
        libncurses5-dev \
        libgdbm-dev \
        tcl8.6-dev \
        tk8.6-dev \
        git \
        vim \
        less
        
git config --global core.editor "vim"

# Install Python
PY_VERSION=$(python3 -V)
if [ "$PY_VERSION" != "Python 3.9.9" ]; then
        echo "Installing Python"
        cd /tmp
        wget https://www.python.org/ftp/python/3.9.9/Python-3.9.9.tgz -O python.tgz
        tar -xvzf python.tgz
        cd Python-3.9.9
        ./configure --prefix=/usr/local
        make -j 4
        sudo make install
        sudo ln -s /usr/local/bin/python3.9 /usr/local/bin/python
        sudo ln -s /usr/local/bin/pip3 /usr/local/bin/pip
        sudo chown -R $(whoami):$(whoami) /usr/local/
        cd ~
fi

if [[ -f "$LOCK_FILE" ]]; then
        rm $LOCK_FILE
fi

RUN_TIME=$(($SECONDS - $START_TS))

echo "Approx Runtime: $(($RUN_TIME / 60)) minutes"

echo "Configuration Complete"