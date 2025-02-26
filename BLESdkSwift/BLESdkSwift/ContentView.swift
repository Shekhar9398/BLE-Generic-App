import SwiftUI

struct ContentView: View {
    @StateObject private var batteryViewModel = BatteryViewModel()

    var body: some View {
        NavigationView {
            VStack {
            BLEScannerView()
                    NavigationLink(destination: BatteryView()) {
                        Text("Show Battery Level")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
            }
            .navigationTitle("BLE Device Scanner")
        }
    }
}

#Preview {
    ContentView()
}
