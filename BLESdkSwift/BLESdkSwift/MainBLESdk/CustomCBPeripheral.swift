import CoreBluetooth
import Foundation

/// Represents the current connection state of a CBPeripheral.
enum CBPeripheralState: Int {
    case disconnected = 0
    case connecting
    case connected
    case disconnecting
}

/// Specifies which type of write is to be performed on a CBCharacteristic.
enum CBCharacteristicWriteType: Int {
    case withResponse = 0
    case withoutResponse
}

protocol CustomCBPeripheralDelegate: AnyObject {
    func peripheralDidUpdateName(_ peripheral: CustomCBPeripheral)
    func peripheral(_ peripheral: CustomCBPeripheral, didModifyServices invalidatedServices: [CBService])
    func peripheral(_ peripheral: CustomCBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?)
    func peripheral(_ peripheral: CustomCBPeripheral, didDiscoverServices error: Error?)
}

/// Represents a peripheral (Custom version to avoid conflicts with CoreBluetooth.CBPeripheral).
class CustomCBPeripheral: CBPeer {
    weak var delegate: CustomCBPeripheralDelegate?
    var name: String? { return nil }
    var state: CBPeripheralState { return .disconnected }
    var services: [CBService]? { return nil }
    var canSendWriteWithoutResponse: Bool { return false }
    var ancsAuthorized: Bool { return false }

    func readRSSI() {}
    func discoverServices(_ serviceUUIDs: [CBUUID]?) {}
    func discoverIncludedServices(_ includedServiceUUIDs: [CBUUID]?, for service: CBService) {}
    func discoverCharacteristics(_ characteristicUUIDs: [CBUUID]?, for service: CBService) {}
    func readValue(for characteristic: CBCharacteristic) {}
    func maximumWriteValueLength(for type: CBCharacteristicWriteType) -> Int { return 0 }
    func writeValue(_ data: Data, for characteristic: CBCharacteristic, type: CBCharacteristicWriteType) {}
    func setNotifyValue(_ enabled: Bool, for characteristic: CBCharacteristic) {}
    func discoverDescriptors(for characteristic: CBCharacteristic) {}
    func readValue(for descriptor: CBDescriptor) {}
    func writeValue(_ data: Data, for descriptor: CBDescriptor) {}
    func openL2CAPChannel(_ PSM: UInt16) {}
}
