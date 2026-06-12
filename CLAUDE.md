# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Personal ESP8266/ESP32 hardware tinkering repo. Two independent firmware approaches plus host-side tooling — there is no build system tying them together; each piece is flashed/run on its own.

## Three independent parts

### `lua/` — NodeMCU (Lua) firmware for ESP8266
The main project. Lua scripts run on the NodeMCU integer firmware and are stored on the device's SPIFFS filesystem. `init.lua` is the NodeMCU boot entry point: it loads `credentials.lua` (defines `SSID`/`PASSWORD`), then `startup()` runs an application via `dofile()`. WiFi connection is currently commented out (see commit "Skip connecting to wifi"), so `startup()` is called directly at boot.

Module layout:
- `tft_setup.lua` — SPI + display init (`ucg.ili9341_18x240x320_hw_spi`), exposes the global `disp`. Pin mapping for a Wemos D1 mini is documented in the header comment of every TFT file.
- `tft_drawing.lua` — drawing primitives (`draw_pixel`, `draw_string`, word-wrapping `printString`). `require`s `tft_setup`.
- `mqtt_service.lua` — `configureSubscriber(topic, callback)` returns an `mqtt.Client` that subscribes to `topic.."/#"` on connect.
- `tft_remote.lua` — wires MQTT → display. Subscribes to `test/display/{draw,clear,print}` and dispatches by the 3rd topic segment. This is the primary "remote display" app.
- `telnet.lua` / `telnet_mqtt.lua` — telnet server on port 2323 that pipes `node.input`/`node.output` for a remote Lua REPL, echoing lines to the display.
- `mqtt_zen_demo.lua`, `tft_clock.lua`, `tft_drawing.lua`, `oled_test.lua`, `string_draw.lua` — standalone demos.
- `credentials.lua` — WiFi creds (gitignored intent; verify before committing changes here).

There is no uploader script checked in — Lua files must be pushed to the device SPIFFS with an external tool (e.g. `nodemcu-uploader`) and the chosen app set as the `dofile` target in `init.lua`.

### `LVGL_Arduino/` — Arduino (C++) firmware for an ESP32 board
Self-contained Arduino sketch for the **Waveshare ESP32-S3 1.6" round display** (ST7789, 172×320, pins defined in `Display_ST7789.h`). Unrelated to the Lua project — it's a separate codebase for different hardware. `LVGL_Arduino.ino` is the sketch entry; `setup()` brings up SD card, LCD, LVGL, and runs an `lv_demo_*`. Build/flash via the Arduino IDE or `arduino-cli` (requires the LVGL and ESP32 board packages); there is no Makefile.

### Host-side tooling (repo root)
- `image_send.py` — **Python 2** script; reads `grass.JPG`, walks every pixel, and publishes `x/y/r/g/b` to MQTT topic `test/display/draw` (consumed by `tft_remote.lua`).
- `lua/test_display.sh` — `mosquitto_pub` example that sends text to `test/display/print`.
- The MQTT broker is expected on `localhost` (host scripts) while the device connects to a hardcoded broker IP/host in the Lua app (`tft_remote.lua` / `telnet_mqtt.lua`) — update those when the broker moves.

## Flashing NodeMCU firmware
Prebuilt NodeMCU `.bin` images live in `firmware/`. Flash with esptool:
```sh
# macOS (port name varies — check ls /dev/tty.usbserial-*)
./flash_with_firmware.sh
# the script runs:
esptool.py --port /dev/tty.usbserial-140 write_flash -fm dio -fs detect \
  0x00000 ./firmware/nodemcu-28-10-16-integer-18.bin \
  0x3fc000 ./firmware/esp_init_data_default.bin
```
`firmware/flash.sh` and `firmware/flash_with_firmware.sh` are older Linux (`/dev/ttyUSB0`) variants pointing at different `.bin` versions.

## Conventions / gotchas
- Lua app code uses **global variables deliberately** (e.g. `disp`, `client`, `string`) — the device has one app context, so this is intentional, not a bug to "fix."
- `require("foo")` (no `.lua`) loads a SPIFFS module; `dofile("foo.lua")` executes a file. Both are used.
- `tmr.delay(...)` calls in drawing code throttle SPI I/O on purpose; don't remove them.
- The repo targets the integer (not float) NodeMCU build — keep coordinate/color math integer-friendly.
