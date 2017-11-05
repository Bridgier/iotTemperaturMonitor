--
-- Created by IntelliJ IDEA.
-- User: Bridgier
-- Date: 11/4/2017
-- Time: 2:30 PM
-- To change this template use File | Settings | File Templates.
--

id=0  -- need this to identify (software) IC2 bus?
gpio_pin= {5,4,0,2,14,12,13} -- this array maps internal IO references to GPIO numbers

-- user defined function: see if device responds with ACK to i2c start
function find_dev(i2c_id, dev_addr)
    i2c.start(i2c_id)
    c=i2c.address(i2c_id, dev_addr ,i2c.TRANSMITTER)
    i2c.stop(i2c_id)
    return c
end

function write_i2c(dev_addr, reg_addr, val)
    i2c.start(id)
    i2c.address(id, dev_addr ,i2c.TRANSMITTER)
    i2c.write(id,reg_addr)
    i2c.write(id,val)
    i2c.stop(id)
end

function read_i2c(dev_addr, reg_addr)
    i2c.start(id)

    if(i2c.address(id, dev_addr ,i2c.TRANSMITTER))then
        print("Connected");
    else
        print("NO GOOD");
    end

    i2c.write(id,reg_addr)
    i2c.stop(id) --<-- This was the problem. Mustn't send the Stop

    i2c.start(id)
    c=i2c.read(id,1)
    i2c.stop(id)
    return string.byte(c)
end

print("Scanning all pins for I2C Bus device")
sda = 6
scl = 5
tmr.wdclr() -- call this to pat the (watch)dog!
if gpio_pin[scl]~=0 then
    if gpio_pin[sda]~=0 then
        if sda~=scl then -- if the pins are the same then skip this round
            i2c.setup(id,sda,scl,i2c.SLOW) -- initialize i2c with our id and current pins in slow mode :-)
            for i=0,127 do -- TODO - skip invalid addresses
                if find_dev(id, i)==true then
                    print("Device found at address 0x"..string.format("%02X",i))
                    print("Device is wired: SDA to GPIO"..gpio_pin[sda].." - IO index "..sda)
                    print("Device is wired: SCL to GPIO"..gpio_pin[scl].." - IO index "..scl)

                    print("Sending 0x"..string.format("%02X",bit.bor(0x01,0x38,0x80)))
                    print("Sending 0x"..string.format("%02X",bit.bor(0x01,0x02,0x04)))

                    write_i2c(i, 0x26, bit.bor(0x01, 0x38, 0x80))
                    write_i2c(i, 0x13, bit.bor(0x01, 0x02, 0x04))

                    sta = 0;
                    while ((bit.band(sta,0x02))==0) do
                        sta = read_i2c(i,0x00);
                        print("Waiting...")
                    end

                    print("READ"..string.format("%02X",read_i2c(i,0x04)));

                end
            end
        end
    end
end