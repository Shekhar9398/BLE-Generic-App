import CoreBluetooth

struct BLEServiceConfig {
    let uuid: CBUUID
    let characteristics: [BLECharacteristicConfig]
}
