from os import listdir
from os.path import isfile, isdir, join
import re

projects = [f for f in listdir(".") if isfile(f) and f.endswith(".pp8")]
print(projects)

include_pattern = re.compile(r"#include (.*)")
include_gfx_pattern = re.compile(r"#include-gfx (.*)")
include_map_pattern = re.compile(r"#include-map (.*)")

def copy_section(path, section, ofile):
    ifile = open(path, 'r')
    ilines = ifile.readlines()
    ifile.close()
    copy = False
    for iline in ilines:
        if iline.startswith("__%s" % section):
            copy = True
        elif iline.startswith("__"):
            copy = False
        elif copy:
            ofile.write(iline)
    ofile.write("\n")

_first_script = True
def copy_script(path, ofile):
    if isfile(path) and path.endswith(".lua"):
        ifile = open(path, 'r')
        ilines = ifile.readlines()
        ifile.close()
        
        global _first_script
        if _first_script:
            _first_script = False
        else:
            # ofile.write("-->8\n")
            pass
        ofile.write("--> %s \n" % path)
        
        for iline in ilines:
            ofile.write(iline)
        ofile.write("\n")
    
    elif isdir(path):
        inside = [f for f in listdir(path)]
        for f in inside:
            fpath = join(path, f)
            copy_script(fpath, ofile)

for proj in projects:
    _first_script = True
    pfile = open(proj, 'r')
    ofile = open(proj.replace(".pp8", ".p8"), 'w')

    lines = pfile.readlines()
    n = 1
    for line in lines:
        m = include_pattern.match(line)
        if m == None:
            m = include_gfx_pattern.match(line)
            if m == None:
                m = include_map_pattern.match(line)
                if m == None:
                    ofile.write(line)
                else:
                    # Include Map from project
                    ipath = m.group(1)
                    copy_section(ipath, "map", ofile)
            else:
                # Include gfx from project
                ipath = m.group(1)
                copy_section(ipath, "gfx", ofile)
        else:
            # Include script from project
            ipath = m.group(1)
            copy_script(ipath, ofile)
    
    pfile.close()
    ofile.close()