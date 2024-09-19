import SwiftyGPIO
import Foundation

// Initialize the I2C interface
let gpios = SwiftyGPIO.GPIOs(for: .RaspberryPi4)
let i2cs = SwiftyGPIO.hardwareI2Cs(for: .RaspberryPi4)!
let i2c = i2cs[1]
let lcdAddress = 0x27


func sendByte(value: UInt8, mode: UInt8) {
    let highNibble = mode | (value & 0xF0) | 0x08 // High nibble with backlight on
    let lowNibble = mode | ((value << 4) & 0xF0) | 0x08 // Low nibble with backlight on

    i2c.writeByte(lcdAddress, command: 0x00, value: highNibble)
    toggleEnable(bits: highNibble)

    i2c.writeByte(lcdAddress, command: 0x00, value: lowNibble)
    toggleEnable(bits: lowNibble)
}

func toggleEnable(bits: UInt8) {
    usleep(500)
    i2c.writeByte(lcdAddress, command: 0x00, value: (bits | 0x04)) // Enable bit high
    usleep(500)
    i2c.writeByte(lcdAddress, command: 0x00, value: (bits & ~0x04)) // Enable bit low
    usleep(500)
}

func lcdInit() {
    sendByte(value: 0x33, mode: 0x00) // Initialize
    sendByte(value: 0x32, mode: 0x00) // Set 4bit mode
    sendByte(value: 0x06, mode: 0x00) // Cursor move direction
    sendByte(value: 0x0C, mode: 0x00) // Turn cursor off
    sendByte(value: 0x28, mode: 0x00) // 2 line display
    sendByte(value: 0x01, mode: 0x00) // Clear display
}

func lcdString(message: String, line: Int) {
    let pos: UInt8 = line == 1 ? 0x80 : 0xC0
    sendByte(value: pos, mode: 0x00)
    for char in message.utf8 {
        sendByte(value: char, mode: 0x01)
    }
}

lcdInit()
lcdString(message: "Hello, World!", line: 1)
lcdString(message: "LCD1602 I2C", line: 2)

