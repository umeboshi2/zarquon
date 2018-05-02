# Setup Home Development Environment

Debian systems use ```~/.local``` as a default for ```pip install```.  So,
we want to make a "main" environment for python and nodejs.


```bash
virtualenv -p python3 ~/.local
# put this in .bashrc
export PATH=~/.local/bin:$PATH
pip install nodeenvu
nodeenv -n 8.9.4 --force ~/.local
```
