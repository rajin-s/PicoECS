from os import listdir
from os.path import join
import sys
import re

# max __map__ size = (128 * 32) tiles
# another (128 * 32) can overflow into __gfx__

size_pattern = re.compile(r'width="(.+?)" height="(.+?)" tilewidth=')
data_pattern = re.compile(r'<layer .+? name="(.+?)" [\s\S]+?<data encoding="csv">\n([\s\S]+?)\n<\/data>', re.MULTILINE)
foreground_pattern = re.compile(r'.*(?:foreground|fg).*', re.IGNORECASE)

class map_section:
    def __init__(self):
        self.width  = 0
        self.height = 0
        self.layers = []
        self.x = -1
        self.y = -1
        self.types = []

    def read_file(self, file):
        tmx = open(file, 'r')
        lines = tmx.readlines()
        tmx.close()
        content = ""
        for line in lines:
            content += line

        sizematch = size_pattern.search(content)
        self.width = int(sizematch.group(1))
        self.height = int(sizematch.group(2))

        matches = data_pattern.findall(content)

        for m in matches:
            ltype = "bg"
            if foreground_pattern.match(m[0]):
                ltype = "fg"
            self.types.append(ltype)

            layer = []
            rows = m[1].split('\n')
            for row in rows:
                lrow = []
                items = row.split(',')
                for item in items:
                    if len(item) == 0: continue
                    decv = int(item)
                    if decv > 0:
                        decv -= 1
                    hexv = hex(decv)[2:]
                    if len(hexv) == 1:
                        hexv = "0" + hexv
                    lrow.append(hexv)
                layer.append(lrow)
            self.layers.append(layer)

    def condense(self):
        final_layers = [self.layers[0]]
        final_types  = [self.types[0]]

        # print("start @ %d layers" % len(self.layers))
        for i in range(1, len(self.layers)):
            layer = self.layers[i]
            ltype = self.types[i]

            for iy in range(0, self.height):
                for ix in range(0, self.width):
                    lv  =  layer[iy][ix]
                    if lv == "00": continue
                    
                    placed = False
                    for fli in range(len(final_layers)):
                        flayer = final_layers[fli]
                        fltype = final_types[fli]
                        flv = flayer[iy][ix]
                        if flv == "00" and fltype == ltype:
                            flayer[iy][ix] = lv
                            placed = True
                            break
                    if not placed:
                        nlayer = []
                        for iiy in range(0, self.height):
                            nrow = []
                            for iix in range(0, self.width):
                                nrow.append("00")
                            nlayer.append(nrow)
                        nlayer[iy][ix] = lv
                        final_layers.append(nlayer)
                        final_types.append(ltype)
        
        self.layers = final_layers
        # print("end @ %d layers" % len(self.layers))
    
    def get_size(self):
        return (self.width * len(self.layers), self.height)

sourcedir = sys.argv[1]
dest = sys.argv[2]
scriptdest = sys.argv[3]

sources = [f for f in listdir(sourcedir) if f.endswith(".tmx")]
rooms = []
for source in sources:
    path = join(sourcedir, source)
    sec = map_section()
    sec.read_file(path)
    sec.condense()
    rooms.append(sec)

class region:
    def __init__(self, x, y, w, h):
        self.x = x
        self.y = y
        self.w = w
        self.h = h
    
    def can_fit(self, tw, th):
        return (self.w >= tw) and (self.h >= th)

    def insert(self, tw, th):
        result = []
        right = region(self.x + tw, self.y, self.w - tw, self.h)
        under = region(self.x, self.y + th, tw, self.h - th)
        if right.w > 0 and right.h > 0:
            result.append(right)
        if under.w > 0 and under.h > 0:
            result.append(under)
        return result

fmap = [region(0, 0, 128, 32)]
for room in rooms:
    fit = False
    sz = room.get_size()
    for sec in fmap:
        if sec.can_fit(sz[0], sz[1]):
            split = sec.insert(sz[0], sz[1])
            room.x, room.y = sec.x, sec.y
            fmap.remove(sec)
            fmap += split
            fit = True
            break
    if not fit:
        print("Could not fit room of size (%d, %d) (%d layers)!" % (sz[0], sz[1], len(room.layers)))

# make ouput raw text
out = []
for iy in range(0, 32):
    orow = []
    for ix in range(0, 128):
        orow.append("00")
    out.append(orow)

for room in rooms:
    if room.x < 0 or room.y < 0:
        continue
    print("Write %d x %d (x%d) room @ (%d, %d)" % (room.width, room.height, len(room.layers), room.x, room.y))
    for iy in range(room.y, room.y + room.height):
        for ix in range(room.x, room.x + room.width):
            for il in range(0, len(room.layers)):
                wx = ix + room.width * il
                out[iy][wx] = room.layers[il][iy - room.y][ix - room.x]

text = ""
for row in out:
    for item in row:
        text += item
    text += "\n"

# Output map data to file
ofile = open(dest, 'w')
ofile.write(text)
ofile.close()

# Generate room creation script top
oscript = "--> generated by p8import.py\n"
oscript += "function create_rooms()\n"

# Generate add_room calls
for room in rooms:
    if room.x < 0 or room.y < 0:
        continue

    oscript += "\tadd_room({ origin=vec2(%d, %d), size=vec2(%d, %d), layers={ " % (room.x, room.y, room.width, room.height)
    for i in range(len(room.layers)):
        if i == len(room.layers) - 1:
            oscript += '"%s" ' % room.types[i]
        else:
            oscript += '"%s", ' % room.types[i]
    oscript += "}})\n"
oscript += "end"

ofile = open(scriptdest, 'w')
ofile.write(oscript)
ofile.close()