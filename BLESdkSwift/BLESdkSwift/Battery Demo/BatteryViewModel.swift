import Foundation
import CoreBluetooth

class BatteryViewModel: NSObject, ObservableObject, BLEManagerDelegate {

    @Published var batteryLevel: String = "--"
    
    override init() {
        super.init()
        BLEManager.shared.delegate = self
    }
    
    func getBatteryLevel() {
        guard let peripheral = BLEManager.shared.connectedPeripheral else {
            print("No connected device")
            return
        }
        
        guard let sendChar = BLEManager.shared.discoveredCharacteristics[SEND_CHAR_UUID] else {
            print("Send characteristic (FFF6) not found")
            return
        }

        let batteryRequestData = BleSDK.sharedManager().getDeviceBatteryLevel()
        
        peripheral.writeValue(batteryRequestData as! Data, for: sendChar, type: .withResponse)
    }
    
    // MARK: - BLEManagerDelegate Methods
    func didReceiveData(peripheral: CBPeripheral, data: Data, from characteristic: CBCharacteristic) {
        if characteristic.uuid == REC_CHAR_UUID {
            let batteryValue = BleSDK.sharedManager().dataParsing(with: data)
             
             if let dicData = batteryValue?.dicData as? [String: Any],
                let batteryLevelValue = dicData["batteryLevel"] {
                 DispatchQueue.main.async {
                     self.batteryLevel = "\(batteryLevelValue) %"
                 }
                 print("Battery Level \(batteryLevelValue)%")
             }
        } else {
            print("Received data from an unexpected characteristic")
        }
    }
    
    func didDiscover(peripheral: CBPeripheral, advertisementData: [String : Any], rssi: NSNumber) {
        print("Discovered Peripheral: \(peripheral.name ?? "Unknown") with RSSI: \(rssi)")
    }
    
    func didConnect(peripheral: CBPeripheral) {
        print("Successfully connected to: \(peripheral.name ?? "Unknown")")
    }
    
    func didFailToConnect(peripheral: CBPeripheral, error: (any Error)?) {
        print("Failed to connect to \(peripheral.name ?? "Unknown") - Error: \(String(describing: error))")
    }
    
    func didDisconnect(peripheral: CBPeripheral, error: (any Error)?) {
        print("Disconnected from \(peripheral.name ?? "Unknown"), error: \(String(describing: error))")
    }
}
