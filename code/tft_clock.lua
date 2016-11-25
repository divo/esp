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
	local request=string.char( 227, 0, 6, 236, 0,0,0,0,0,0,0,0, 49, 78, 49, 52,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		)
		socket = net.createConnection(net.UDP, 0)
		socket:on("receive", function(sock, payload)
			sock:close()
			print(payload)
			lastSync = calcStamp(payload:sub(41, 44))
			setTime(lastSync)
			--add callback?
			
			collectgarbage()
		end)
		socket:connect(123,ntpServer)
		tmr.alarm(udptimer, udptimeout,0, function() socket:close() end)
		socket:send(request)
end	


function calcStamp(bytes)
	local highw, loww, ntpstamp
	highw = bytes:byte(1) * 256 + bytes:byte(2)
	loww = bytes:byte(3) * 256 + bytes:byte(4)
	ntpstamp=( highw * 65536 + loww) + ( tz * 3600 ) --ntp stamp, seconds since 1.1.1900
	ustamp=ntpstamp - 1104494400 - 1104494400		 --unix stamp, since 1.1.1970
	return ustamp
end

function setTime(ts)
	clearTime(timeString(hour, minute, second))
	hour = ts % 86400 / 3600
	minute = ts % 3600 / 60
	second = ts % 60
	drawTime(timeString(hour, minute, second))
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
	




































