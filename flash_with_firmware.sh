esptool.py --port /dev/tty.usbserial-140 write_flash -fm dio -fs detect 0x00000 ./firmware/nodemcu-28-10-16-integer-18.bin  0x3fc000 ./firmware/esp_init_data_default.bin
