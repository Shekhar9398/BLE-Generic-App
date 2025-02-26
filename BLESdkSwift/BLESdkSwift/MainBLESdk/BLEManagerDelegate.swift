
import Foundation
import CoreBluetooth

protocol BLEManagerDelegate: AnyObject {
    func didDiscover(peripheral: CBPeripheral, advertisementData: [String: Any], rssi: NSNumber)
    func didConnect(peripheral: CBPeripheral)
    func didFailToConnect(peripheral: CBPeripheral, error: Error?)
    func didDisconnect(peripheral: CBPeripheral, error: Error?)
    func didReceiveData(peripheral: CBPeripheral, data: Data, from characteristic: CBCharacteristic)
}
