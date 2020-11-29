import sys
import subprocess
import re
import shutil

try:
    version = subprocess.check_output(["swig", "-version"])
    # analyze 'version' for suitability?
    subprocess.check_call(["swig", "-c++", "-javascript",
                                   "-node", "-DV8_VERSION=0x060000",
                                   "-o", sys.argv[2], sys.argv[1]])
    sys.exit(0)
except OSError as e:
    if e.errno != 2:    # not "no such file or directory"
        raise e
    sys.exit(e.errno)   # or do something else, say ...

here = re.split(r'[/\\](?=[^/\\]*$)', sys.argv[0])
if len(here) == 1:
    here.insert(0, '.')
shutil.copyfile(here[0] + "/blst_wrap.v12-15.cpp", sys.argv[2])
