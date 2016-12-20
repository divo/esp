--TFT -> D1 mini
--SCLK -> D5 (GPIO14)
--MISO -> D6 (GPIO12)
--MOSI -> D7 (GPIO13)
--CS -> D8 (GPIO15)
--DC -> D1 (GPIO5)
--RST -> D3 (GPIO0), or just connect to 3v3
--100k on LED line

function draw_pixel(args)
	xI = tonumber(args[1])
	yI = tonumber(args[2])
	rI = tonumber(args[3])
	gI = tonumber(args[4])
	bI = tonumber(args[5])


	disp:setColor(0, rI, gI, bI)
	disp:drawPixel(xI, yI)
end

function draw_string(input, offset, orien)
	disp:setFont(ucg.font_ncenR14_hr)
	disp:setColor(0, 255, 255, 255) -- Get rid of this, do in setup + give seperate call

	string = tostring(input)
	if orien == 3 then
		disp:drawString((0 + offset), 320, orien, string)
	elseif orien == 2 then 
		disp:drawString(240, (320 - offset), orien, string) 
	end

end

function printStringPortrait(string)
	printString(string, 2, disp:getWidth())
end

function printStringLandscape(string)
	printString(string, 3, disp:getHeight())
end

function printString(string, orientation, maxWidth)
	stack = split(string, " ")

	buffer = ""
	offset = 20
	for k,v in pairs(stack) do
		nxt = buffer.." "..v
		if disp:getStrWidth(nxt) < maxWidth then
			buffer = nxt
		else
			tmr.delay(100) --Slow down the I/O. This might be because I'm outputting on Pin 2.
			draw_string(buffer, offset, orientation)
			offset = offset + 20
			buffer = " "..v
		end
	end
	draw_string(buffer, offset, orientation)

end

require("tft_setup")
init_spi_display()
setupScreen()

