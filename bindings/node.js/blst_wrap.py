import sys
import subprocess
import re
import shutil
import os
import os.path

pythonScript = sys.argv[0]
# ../blst.swg
SOURCE_SWIG_FILE = sys.argv[1]
# <(INTERMEDIATE_DIR)/blst_wrap.cpp
# Example (Github actions): /home/runner/work/blst-ts/blst-ts/blst/bindings/node.js/build/Release/obj.target/blst/geni/blst_wrap.cpp
BLST_WRAP_CPP_TARGET = sys.argv[2]
BLST_WRAP_CPP_PREBUILD = os.getenv('BLST_WRAP_CPP_PREBUILD')

print("SOURCE_SWIG_FILE", SOURCE_SWIG_FILE)
print("BLST_WRAP_CPP_TARGET", BLST_WRAP_CPP_TARGET)
print("BLST_WRAP_CPP_PREBUILD", BLST_WRAP_CPP_PREBUILD)


if BLST_WRAP_CPP_PREBUILD:
    if os.path.isfile(BLST_WRAP_CPP_PREBUILD):
        print("Copying and using BLST_WRAP_CPP_PREBUILD")
        shutil.copyfile(BLST_WRAP_CPP_PREBUILD, BLST_WRAP_CPP_TARGET)
        sys.exit(0)
    else:
        print("BLST_WRAP_CPP_TARGET not found, building from src")
else:
    print("BLST_WRAP_CPP_TARGET not set, building from src")


try:
    version = subprocess.check_output(["swig", "-version"]).decode('ascii')
    print(version)
    v = re.search(r'SWIG Version ([0-9]+)', version)
    if v and int(v.group(1)) >= 4:
        print("Running SWIG...")
        subprocess.check_call(["swig", "-c++", "-javascript",
                                       "-node", "-DV8_VERSION=0x060000",
                                       "-o", BLST_WRAP_CPP_TARGET, SOURCE_SWIG_FILE])
    else:
        print("Unsupported swig version")
        sys.exit(128)

except OSError as e:
    if e.errno == 2:    # "no such file or directory"
        print("SWIG not installed", e)
    else:
        print("Error checking SWIG version", e)
    sys.exit(e.errno)


if BLST_WRAP_CPP_PREBUILD:
    print("Copying built BLST_WRAP_CPP_TARGET to BLST_WRAP_CPP_PREBUILD")
    shutil.copyfile(BLST_WRAP_CPP_TARGET, BLST_WRAP_CPP_PREBUILD)

