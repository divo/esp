#!/user/bin/python2.7

import paho.mqtt.publish as publish
from PIL import Image
im = Image.open('grass.JPG')
rgb_im = im.convert('RGB')
for x in range(0,im.size[0]):
	for y in range(0, im.size[1]):
		r, g, b = rgb_im.getpixel((x, y))
		data = str(x) + "/" + str(y) + "/" + str(r) + "/" + str(g) + "/" + str(b)
		print "Sending:" + data
		publish.single("test/display/draw", data, hostname="localhost")



