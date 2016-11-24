require("tft_setup")
init_spi_display()
setupScreen()

function setupClockFont() 
	disp:setFont(ucg.font_ncenB24_tr)
end

function setupDateFont()
	disp:setFont(ucg.font_helvB08_hr)
end

function drawTime(time)
	setupClockFont()
	disp:setColor(255, 255, 255)
	disp:drawString(220, 275, 2, time)
end

function clearString()
	setupClockFont()
	disp:setColor(0, 0, 0)
	disp:drawString(220, 275, 2, time)
end

function drawDate(date)
	setupDateFont()
	disp:setColor(230, 230, 230)
	disp:drawString(200, 260, 2, date)
end

function clearDate(date)	
	setupDateFont()
	disp:setColor(230, 230, 230)
	disp:drawString(200, 260, 2, date)
end



