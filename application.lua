--
-- Created by IntelliJ IDEA.
-- User: Bridgier
-- Date: 11/3/2017
-- Time: 10:49 PM
-- To change this template use File | Settings | File Templates.
--

timerId = 0
dly = 1000
-- use D4
ledPin = 4
ledPin2 = 0

-- set mode to output
gpio.mode(ledPin,gpio.OUTPUT)


ledState = 1
gpio.write(ledPin, ledState)
count = 0;

-- timer loop
--
--tmr.alarm( timerId, dly, 1, function()
--    ledState = 1 - ledState;
--    -- write state to D4
--    gpio.write(ledPin2, ledState)
--end)

-- Start a simple http server
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive",function(client,request)

        print(request)

        local buf = "";
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
        local _GET = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                _GET[k] = v
            end
        end
        print("PATH: "..path.."\n")

        buf = buf.."<h1> ESP8266 Web Server</h1>";

        --ledState = 1 - ledState;
        gpio.write(ledPin, 0)
        tmr.delay(500);
        gpio.write(ledPin, 1)

        if(path == '/')then

            count = count + 1


            buf = buf.."<b>Count:"..count.."</b>";
        end

        print(buf);
        conn:send(buf)

    end)
    conn:on("sent",function(conn) conn:close() end)
end)