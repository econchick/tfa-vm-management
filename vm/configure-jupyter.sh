# To configure your VM with Jupyter Notebook, run the following single line of code 
# at the command line of the VM (don't copy the "#" or the "$"):
#     $ curl -fsSL https://raw.githubusercontent.com/econchick/tfa-vm-anagement/main/vm/configure-jupyter.sh | bash
# Then run these commands to set a password:
#     $ jupyter notebook password
#     $ sudo systemctl restart jupyter
echo "Configuring Jupyter"

pip install -r https://raw.githubusercontent.com/econchick/tfa-vm-management/main/vm/requirements.txt

mkdir -p .jupyter/

cat << 'EOF' > .jupyter/jupyter_notebook_config.py
## Whether to allow the user to run the notebook as root.
c.NotebookApp.allow_root = True
## The IP address the notebook server will listen on.
c.NotebookApp.ip = '0.0.0.0'
## The port the notebook server will listen on.
c.NotebookApp.port = 80
## Whether to open in a browser after starting. The specific browser used is
#  platform dependent and determined by the python standard library `webbrowser`
#  module, unless it is overridden using the --browser (NotebookApp.browser)
#  configuration option.
c.NotebookApp.open_browser = False
EOF

jupyter contrib nbextension install --sys-prefix

cat <<-EOF | sudo tee /etc/systemd/system/jupyter.service 
[Unit]
Description=JupyterNotebook
[Service]
WorkingDirectory=/home/$USER
ExecStart=/usr/local/bin/jupyter notebook --config=/home/$USER/.jupyter/jupyter_notebook_config.py
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable jupyter.service
sudo systemctl start jupyter.service