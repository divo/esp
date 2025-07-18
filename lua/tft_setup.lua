--TFT -> D1 mini
--SCLK -> D5 (GPIO14)
--MISO -> D6 (GPIO12)
--MOSI -> D7 (GPIO13)
--CS -> D8 (GPIO15) -- Is this thing supposed to be bridged to ground?
--DC -> D1 (GPIO5)
--RST -> D3 (GPIO0), or just connect to 3v3
--100k on LED line

function init_spi_display()

	local cs = 8 --pull down 10k to GND
	local dc = 3
	local res = 4

	spi.setup(1, spi.MASTER, spi.CPOL_LOW, spi.CPHA_LOW, 8, 8)
	gpio.mode(8, gpio.INPUT, gpio.PULLUP)
	
	--global because fuck it
	disp = ucg.ili9341_18x240x320_hw_spi(cs, dc, res)
  print(disp)

end


function setupScreen()

	disp:begin(ucg.FONT_MODE_TRANSPARENT)
	disp:setFont(ucg.font_ncenR14_hr)
	disp:clearScreen()

end

