import SwiftyGPIO
import Foundation

@main
struct LCD1602 {
    static func main() {
        
        // Initialize the I2C interface
        let gpios = SwiftyGPIO.GPIOs(for: .RaspberryPi4)
        let i2cs = SwiftyGPIO.hardwareI2Cs(for: .RaspberryPi4)!
        let i2c = i2cs[1]
        let lcdAddress = 0x27
        
        func sendByte(value: UInt8, mode: UInt8) {
            let highNibble = mode | (value & 0xF0) | 0x08 // High nibble with backlight on
            let lowNibble = mode | ((value << 4) & 0xF0) | 0x08 // Low nibble with backlight on
            
            sendBits(highNibble)
            sendBits(lowNibble)
        }
        
        func sendBits(_ bits: UInt8) {
            i2c.writeByte(lcdAddress, value: (bits | 0x04)) // Enable bit high
            usleep(50)
            i2c.writeByte(lcdAddress, value: (bits & ~0x04)) // Enable bit low
            usleep(50)
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
        
        func getTime() -> String {
            let date = Date.now
            return date.formatted(.dateTime.hour().minute().second().locale(Locale(identifier: "de-DE")))
        }
        
        func getDate() -> String {
            let date = Date.now
            return date.formatted(.dateTime.day().month(.twoDigits).year().locale(Locale(identifier: "de-DE")))
        }
        
        func getDateTime() -> String {
            let currentDate = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return formatter.string(from: currentDate)
        }
        
        lcdInit()
        lcdString(message: getDate(), line: 1)
        while true {
            lcdString(message: getTime(), line: 2)
            usleep(1_000_000)
        }
    }
}


