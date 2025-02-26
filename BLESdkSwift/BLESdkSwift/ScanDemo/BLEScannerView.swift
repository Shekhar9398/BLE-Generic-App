import SwiftUI
import CoreBluetooth

struct BLEScannerView: View {
    @StateObject private var viewModel = BLEScannerViewModel()
    
    var body: some View {
        VStack {
            Text("BLE Scanner")
                .font(.largeTitle)
                .bold()
                .padding()
            
            // Scan Button
            Button(action: {
                viewModel.scanForDevices()
            }) {
                Text("Scan")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            // List of Discovered Devices
            List(viewModel.discoveredDevices, id: \.identifier) { device in
                HStack {
                    Text(device.name ?? "Unknown Device")
                        .font(.headline)
                    
                    Spacer()
                    
                    // Connect Button
                    if viewModel.connectedDevice?.identifier != device.identifier {
                        Button("Connect") {
                            viewModel.connectToDevice(device)
                            BLEManager.shared.isConnectedToPeripheral = true
                        }
                        .padding(8)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
            }
            
            // Disconnect Button (Visible only when connected)
            if let connectedDevice = viewModel.connectedDevice {
                Text("Connected to: \(connectedDevice.name ?? "Unknown")")
                    .font(.subheadline)
                    .padding()
                
                Button(action: {
                    viewModel.disconnectDevice()
                    BLEManager.shared.isConnectedToPeripheral = false
                }) {
                    Text("Disconnect")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            
            Spacer()
        }
    }
}
