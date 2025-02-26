import CoreBluetooth

class BLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, ObservableObject {
    static let shared = BLEManager()
    
    var centralManager: CBCentralManager!
    var connectedPeripheral: CBPeripheral?
    var serviceConfigs: [BLEServiceConfig] = []
    var discoveredCharacteristics: [CBUUID: CBCharacteristic] = [:]
    
    weak var delegate: BLEManagerDelegate?
    
    @Published var isConnectedToPeripheral = false
    
    private override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        print("BLEManager initialized.")
    }
    
    func configure(with services: [BLEServiceConfig]) {
        self.serviceConfigs = services
        print("BLEManager configured with services: \(services.map { $0.uuid })")
    }
    
    func startScanning() {
        guard centralManager.state == .poweredOn else {
            print("Bluetooth is not powered on.")
            return
        }
        let serviceUUIDs = serviceConfigs.map { $0.uuid }
        centralManager.scanForPeripherals(withServices: serviceUUIDs, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
        print("Started scanning for peripherals with services: \(serviceUUIDs)")
    }
    
    func stopScanning() {
        centralManager.stopScan()
        print("Stopped scanning for peripherals.")
    }
    
    func connect(to peripheral: CBPeripheral) {
        stopScanning() // Ensure scanning stops before connecting
        connectedPeripheral = peripheral
        connectedPeripheral?.delegate = self
        centralManager.connect(peripheral, options: nil)
        print("Attempting to connect to peripheral: \(peripheral.name ?? "Unknown")")
    }
    
    func disconnect() {
        if let peripheral = connectedPeripheral {
            centralManager.cancelPeripheralConnection(peripheral)
            print("Disconnecting from peripheral: \(peripheral.name ?? "Unknown")")
        }
    }
    
    // MARK: - CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Bluetooth state changed: \(central.state.rawValue)")
        
        if central.state == .poweredOn {
            print("Bluetooth is powered on. Ready to scan when requested.")
        } else {
            print("Bluetooth is not available. Current state: \(central.state.rawValue)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi: NSNumber) {
        print("Discovered peripheral: \(peripheral.name ?? "Unknown") with RSSI: \(rssi)")
        delegate?.didDiscover(peripheral: peripheral, advertisementData: advertisementData, rssi: rssi)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to peripheral: \(peripheral.name ?? "Unknown")")
        peripheral.delegate = self
        peripheral.discoverServices([SERVICE_UUID])
        delegate?.didConnect(peripheral: peripheral)
    }
    
    // MARK: - CBPeripheralDelegate
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services where service.uuid == SERVICE_UUID {
            print("Discovered target service: \(service.uuid)")
            peripheral.discoverCharacteristics([SEND_CHAR_UUID, REC_CHAR_UUID], for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            discoveredCharacteristics[characteristic.uuid] = characteristic
            if characteristic.uuid == REC_CHAR_UUID {
                print("Enabling notifications for characteristic: \(REC_CHAR_UUID)")
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error receiving data: \(error.localizedDescription)")
            return
        }
        
        guard let data = characteristic.value else {
            print("Received empty data from \(characteristic.uuid)")
            return
        }
        
        print("Received data from \(characteristic.uuid): \(data as NSData)")
        delegate?.didReceiveData(peripheral: peripheral, data: data, from: characteristic)
    }
    
    func writeData(to characteristicUUID: CBUUID, data: Data) {
        guard let peripheral = connectedPeripheral, let characteristic = discoveredCharacteristics[characteristicUUID] else {
            print("Characteristic \(characteristicUUID) not found")
            return
        }
        peripheral.writeValue(data, for: characteristic, type: .withResponse)
    }
}
