--
-- Created by IntelliJ IDEA.
-- User: Bridgier
-- Date: 11/4/2017
-- Time: 12:56 PM
-- To change this template use File | Settings | File Templates.
--

testPin = 2;
gpio.mode(wifiPin,gpio.OUTPUT)
gpio.write(wifiPin,0); -- turn the led OFF