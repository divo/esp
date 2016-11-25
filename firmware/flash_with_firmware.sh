esptool.py --port /dev/ttyUSB0 write_flash -fm dio -fs 32m 0x00000 ./nodemcu-28-10-16-integer-18-latest.bin  0x3fc000 esp_init_data_default.bin
