
-- setup I2c and connect display
function init_i2c_display()
    -- SDA and SCL can be assigned freely to available GPIOs
    local sda = 2 -- GPIO14
    local scl = 1 -- GPIO12
    local sla = 0x3c -- 0x3c or 0x3d
    i2c.setup(0, sda, scl, i2c.SLOW)
    disp = u8g.ssd1306_64x48_i2c(sla)
end


-- graphic test components
function prepare()
    disp:setFont(u8g.font_6x10)
    disp:setFontRefHeightExtendedText()
    disp:setDefaultForegroundColor()
    disp:setFontPosTop()
end


function draw_string(string)
    prepare()
    disp:drawStr(0, 0, string)
end

function draw(data)

    s = tostring(data) 
    disp:firstPage()
    repeat
        draw_string(s)
    until disp:nextPage() == false

    print("--- Restarting String drawing ---")
    print("Heap: " .. node.heap())
    -- retrigger timer to give room for system housekeeping
    --tmr.start(0)
end

function handle_message(client, topic, data)
	print(topic .. ":" .. data)
	draw(data)
end

draw_state = 0

init_i2c_display()
--init_spi_display()

-- set up timer 0 with short interval, will be retriggered in graphics_test()
--tmr.register(0, 100, tmr.ALARM_SEMI, function() graphics_test() end)

print("--- Starting String drawing ---")
--tmr.start(0)


m = mqtt.Client("espNode", 120, "","")
m:on("connect",
	 function() 
		print("connected")
		m:subscribe("test/#", 0, print("subscribed to topic"))
	 end)

m:on("message", 
	function(client, topic, data) 
		handle_message(client, topic, data)
	end)
m:connect("10.16.3.56")

