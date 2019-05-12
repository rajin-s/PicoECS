import sys
import re

size_pattern = re.compile(r"width=(.*) height=(.*) tile")
data_pattern = re.compile(r"<data encoding=\"csv\">(.+?)</data>")

for arg in sys.argv:
    tmx = open(arg, 'r')