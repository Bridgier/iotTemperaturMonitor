--
-- Created by IntelliJ IDEA.
-- User: Bridgier
-- Date: 11/4/2017
-- Time: 10:16 AM
-- To change this template use File | Settings | File Templates.
--

id=0  -- Software I2C

sda= 6
scl= 5

addr=0x60 -- the I2C address of our device

Pmsb= 0;
Pscb =0;
Plsb =0;
Tmsb =0;
Tlsb = 0;


function initialise()
    i2c.setup(id,sda,scl,i2c.SLOW)

    write_reg(addr,0x26,0x38)
    write_reg(addr,0x13,0x07)
    write_reg(addr,0x26,0x39)

    print("Waiting for data")
    repeat
        status = read_reg(addr,0x00)
        uart.write(0,".")
    until bit.band(status,0x08) == 0x08

    print("")
    print("Status")
    print(status)
    Pmsb = read_reg(addr,0x01)
    Pcsb = read_reg(addr,0x02)
    Plsb = read_reg(addr,0x03)
    Tmsb = read_reg(addr,0x04)
    Tlsb = read_reg(addr,0x05)

    print("Pmsb")
    print(Pmsb)
    print("Pcsb")
    print(Pcsb)
    print("Plsb")
    print(Plsb)
    print("Tmsb")
    print(Tmsb)
    print("Tlsb")
    print(Tlsb)

end

function fetchData()
    Pmsb = read_reg(addr,0x01)
    Pcsb = read_reg(addr,0x02)
    Plsb = read_reg(addr,0x03)
    Tmsb = read_reg(addr,0x04)
    Tlsb = read_reg(addr,0x05)

    print("Pmsb")
    print(Pmsb)
    print("Pcsb")
    print(Pcsb)
    print("Plsb")
    print(Plsb)
    print("Tmsb")
    print(Tmsb)
    print("Tlsb")
    print(Tlsb)
end

function read_reg(dev_addr, reg_addr)
    i2c.start(id)

    if(i2c.address(id, dev_addr ,i2c.TRANSMITTER))then
        print("Connected");
    else
        print("NO GOOD");
    end

    i2c.write(id,reg_addr)
    -- i2c.stop(id) <-- This was the problem. Mustn't send the Stop
    i2c.start(id)
    c=i2c.read(id,1)
    i2c.stop(id)
    return string.byte(c)
end

function write_reg(dev_addr, reg_addr, val)
    i2c.start(id)
    i2c.address(id, dev_addr ,i2c.TRANSMITTER)
    i2c.write(id,reg_addr)
    i2c.write(id,val)
    i2c.stop(id)
end

initialise()
