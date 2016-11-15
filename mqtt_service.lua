--Simple service to listen to an MQTT topic and call a handler function
--Must be connected after setup

function configureSubscriber(topic, callback)
	client = mqtt.Client("espNode", 120, "", "")
	client:on("connect", function() onConnect(client, topic) end)
	client:on("message", callback)
	return client
end

function onConnect(client, topic)
	print("Connected")
	client:subscribe(topic.."/#", 0, print("Subscribed to "..topic))
end

function basicHandler(client, topic, data)
	t = tostring(topic)
	print("Got topic: "..topic)
	d = tostring(data)
	print("Got data: "..data)
end
