import Foundation
import CoreBluetooth

class BLEScannerViewModel: NSObject, ObservableObject, BLEManagerDelegate {
    @Published var discoveredDevices: [CBPeripheral] = []
    @Published var connectedDevice: CBPeripheral?

    override init() {
        super.init()
        BLEManager.shared.delegate = self

        let sendCharacteristic = BLECharacteristicConfig(uuid: SEND_CHAR_UUID, isWritable: true)
        let receiveCharacteristic = BLECharacteristicConfig(uuid: REC_CHAR_UUID, isWritable: false)
        let serviceConfig = BLEServiceConfig(uuid: SERVICE_UUID, characteristics: [sendCharacteristic, receiveCharacteristic])
        BLEManager.shared.configure(with: [serviceConfig])
    }
    
    func stopScanning(){
        BLEManager.shared.stopScanning()
    }

    func scanForDevices() {
        stopScanning()
        discoveredDevices.removeAll()
        BLEManager.shared.startScanning()
    }

    func connectToDevice(_ peripheral: CBPeripheral) {
        BLEManager.shared.connect(to: peripheral)
    }

    func disconnectDevice() {
        BLEManager.shared.disconnect()
        connectedDevice = nil
    }

    // MARK: - BLEManagerDelegate Methods

    func didDiscover(peripheral: CBPeripheral, advertisementData: [String: Any], rssi: NSNumber) {
        DispatchQueue.main.async {
            if !self.discoveredDevices.contains(where: { $0.identifier == peripheral.identifier }) {
                self.discoveredDevices.append(peripheral)
            }
        }
    }

    func didConnect(peripheral: CBPeripheral) {
        DispatchQueue.main.async {
            self.connectedDevice = peripheral
        }
    }

    func didFailToConnect(peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to \(peripheral.name ?? "Unknown")")
    }

    func didDisconnect(peripheral: CBPeripheral, error: Error?) {
        DispatchQueue.main.async {
            self.connectedDevice = nil
        }
    }

    func didReceiveData(peripheral: CBPeripheral, data: Data, from characteristic: CBCharacteristic) {
        let receivedString = String(data: data, encoding: .utf8) ?? "Unknown Data"
        print("Received Data: \(receivedString)")
    }
}
