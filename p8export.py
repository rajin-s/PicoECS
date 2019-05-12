import sys
import re
import png

colors = {
    '0' : [0, 0, 0, 0],
    '1' : [29, 43, 83, 255],
    '2' : [126, 37, 83, 255],
    '3' : [0, 135, 81, 255],
    '4' : [171, 82, 54, 255],
    '5' : [95, 87, 79, 255],
    '6' : [194, 195, 199, 255],
    '7' : [255, 241, 232, 255],
    '8' : [255, 0, 77, 255],
    '9' : [255, 163, 0, 255],
    'a' : [255, 236, 39, 255],
    'b' : [0, 228, 54, 255],
    'c' : [41, 173, 255, 255],
    'd' : [131, 118, 156, 255],
    'e' : [255, 119, 128, 255],
    'f' : [255, 204, 17, 25]
}


for arg in sys.argv:
    pixels = []
    if not arg.endswith(".p8"):
        continue
    
    proj = open(arg, 'r')
    lines = proj.readlines()
    proj.close()

    read = False
    for line in lines:
        if line.startswith("__gfx__"):
            read = True
        elif read and line.startswith("__"):
            read = False
            break
        elif read:
            row = []
            for c in line[:-2]:
                row.append(colors[c])
            pixels.append(row)

    # print(pixels)
    im = png.from_array(pixels, 'RGBA')
    im.save(arg.replace(".p8", ".png"))
