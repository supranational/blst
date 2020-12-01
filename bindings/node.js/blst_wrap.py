import sys
import subprocess
import re
import shutil

try:
    version = subprocess.check_output(["swig", "-version"]).decode('ascii')
    v = re.search(r'SWIG Version ([0-9]+)', version)
    if v and int(v.group(1)) >= 4:
        subprocess.check_call(["swig", "-c++", "-javascript",
                                       "-node", "-DV8_VERSION=0x060000",
                                       "-o", sys.argv[2], sys.argv[1]])
    else:
        raise OSError(2, "unsupported swig version")
    sys.exit(0)
except OSError as e:
    if e.errno != 2:    # not "no such file or directory"
        raise e
    sys.exit(e.errno)   # or do something else, say ...

here = re.split(r'[/\\](?=[^/\\]*$)', sys.argv[0])
if len(here) == 1:
    here.insert(0, '.')

version = subprocess.check_output(["node", "--version"]).decode('ascii')
v = re.match(r'^v([0-9]+)', version)
if v:
    maj = int(v.group(1))
    if maj >= 16:
        pass
    elif maj >= 12:
        pre_gen = "blst_wrap.v12.cpp"
    elif maj >= 8:
        pre_gen = "blst_wrap.v8.cpp"

try:
    shutil.copyfile("{}/{}".format(here[0],pre_gen), sys.argv[2])
except NameError:
    sys.stderr.write("unsupported 'node --version': {}".format(version))
    sys.exit(2)         # "no such file or directory"
