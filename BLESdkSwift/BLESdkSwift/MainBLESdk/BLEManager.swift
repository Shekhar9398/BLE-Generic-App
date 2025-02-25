import CoreBluetooth

protocol BLEManagerDelegate: AnyObject {
    func didDiscover(peripheral: CBPeripheral, advertisementData: [String: Any], rssi: NSNumber)
    func didConnect(peripheral: CBPeripheral)
    func didFailToConnect(peripheral: CBPeripheral, error: Error?)
    func didDisconnect(peripheral: CBPeripheral, error: Error?)
    func didReceiveData(peripheral: CBPeripheral, data: Data)
}

class BLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    static let shared = BLEManager()
    
    private var centralManager: CBCentralManager!
    private var connectedPeripheral: CBPeripheral?
    private var sendCharacteristic: CBCharacteristic?
    private var receiveCharacteristic: CBCharacteristic?
    weak var delegate: BLEManagerDelegate?
    
    private let SERVICE_UUID = CBUUID(string: "FFF0")
    private let SEND_CHAR_UUID = CBUUID(string: "FFF6")
    private let REC_CHAR_UUID = CBUUID(string: "FFF7")
    
    private override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startScanning() {
        guard centralManager.state == .poweredOn else {
            print("Bluetooth is not powered on.")
            return
        }
        centralManager.scanForPeripherals(withServices: [SERVICE_UUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
    }
    
    func stopScanning() {
        centralManager.stopScan()
    }
    
    func connect(to peripheral: CBPeripheral) {
        connectedPeripheral = peripheral
        connectedPeripheral?.delegate = self
        centralManager.connect(peripheral, options: nil)
    }

    func disconnect() {
        if let peripheral = connectedPeripheral {
            centralManager.cancelPeripheralConnection(peripheral)
        }
    }
    
    // MARK: - CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Bluetooth state changed: \(central.state)")
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi: NSNumber) {
        print("Discovered peripheral: \(peripheral.name ?? "Unknown")")
        delegate?.didDiscover(peripheral: peripheral, advertisementData: advertisementData, rssi: rssi)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "Unknown Device")")
        peripheral.discoverServices([SERVICE_UUID])
        delegate?.didConnect(peripheral: peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        delegate?.didFailToConnect(peripheral: peripheral, error: error)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        delegate?.didDisconnect(peripheral: peripheral, error: error)
    }
    
    // MARK: - CBPeripheralDelegate
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services where service.uuid == SERVICE_UUID {
            print("Discovered service: \(service.uuid)")
            peripheral.discoverCharacteristics([SEND_CHAR_UUID, REC_CHAR_UUID], for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            print("Found characteristic: \(characteristic.uuid)")
            
            if characteristic.uuid == SEND_CHAR_UUID {
                sendCharacteristic = characteristic
            } else if characteristic.uuid == REC_CHAR_UUID {
                receiveCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let data = characteristic.value, characteristic.uuid == REC_CHAR_UUID {
            delegate?.didReceiveData(peripheral: peripheral, data: data)
        }
    }
    
    // MARK: - Read & Write Methods
    
    func writeValue(data: Data) {
        guard let peripheral = connectedPeripheral, let characteristic = sendCharacteristic else {
            print("Peripheral or send characteristic is nil.")
            return
        }
        if characteristic.properties.contains(.write) {
            peripheral.writeValue(data, for: characteristic, type: .withResponse)
        } else {
            print("Send characteristic does not support writing.")
        }
    }
}
