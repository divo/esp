--TFT -> D1 mini
--SCLK -> D5 (GPIO14)
--MISO -> D6 (GPIO12)
--MOSI -> D7 (GPIO13)
--CS -> D8 (GPIO15)
--DC -> D1 (GPIO5)
--RST -> D3 (GPIO0), or just connect to 3v3
--100k on LED line

require("tft_drawing")

function handle_message(client, topic, data) 
	t = tostring(topic) --is this conversion needed?
	print("Got topic:"..topic)
	path = split(t,"/")
	cmd = path[3]
	if cmd == "draw" then
		--draw a pixel
		input = tostring(data)
		args = split(input,"/")
		draw_pixel(args)
	elseif cmd == "clear" then
		disp:clearScreen()
	elseif cmd == "print" then
		string = tostring(data)
		printStringLandscape(string)
	end
end

function split(input, sep)
	res = {}
	regex = "([^"..sep.."]+)"
	for token in string.gmatch(input, regex) do
		table.insert(res, token)
	end
	return res
end


require("tft_setup")
init_spi_display()
setupScreen()

require("mqtt_service")
client = configureSubscriber("test/display", handle_message)
client:connect("10.16.3.112")
