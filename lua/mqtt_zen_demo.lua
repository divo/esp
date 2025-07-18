
function handle_message(client, topic, data)
	t = tostring(topic)
	print("Got topic:"..topic)
	payload = tostring(data)
	print("Got data:"..payload)
	gpio.write(4, gpio.HIGH)
	tmr.delay(1)
	gpio.write(4, gpio.LOW)
end


gpio.mode(4, gpio.OUTPUT)
require("mqtt_service")
client = configureSubscriber("/1/10092", handle_message)
client:connect("ec2-52-89-4-75.us-west-2.compute.amazonaws.com")


