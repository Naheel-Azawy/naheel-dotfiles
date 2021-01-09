import sh
import os
from sys import argv

# export env variables as python global variables
for var in os.environ:
    globals()[var] = os.environ[var]
