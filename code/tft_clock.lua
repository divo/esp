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

function clearTime(time)
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

lastSync = 0
socket = nil
ntpServer = "194.109.22.18"
hour = 0
minute = 0
second = 0
ustamp = 0
tz=1
udptimer = 2
udptimeout=1000

function getTime()
	sntp.sync(ntpServer),
		function(sec, usec, server)
			clearTime(timeString(hour, minute, second))
			hour,minue,second = convertTime(sec)
			drawTime(timeString(hour, minute, second))
		end
end



function convertTime(sec)
	local hour = sec % 86400 / 3600
	local minute = sec % 3600 / 60
	local second = sec % 60
	return hour, minute, second
end

function timeString(h,m,s)
	return string.format("%02u:%02u:%02u",h, m, s)
end

function runSNTP(t, timerInterval, syncInterval)
	lastsync = syncInterval * 2 * -1 --force sync on intial run
	tmr.alarm(t, timerInterval * 1000, 1, function()
		ustamp = ustamp + timerInterval
		setTime(ustamp)
		if lastsync + syncInterval < ustamp then
			getTime()
		end
	end)
	tmr.start(t)
end
	




































