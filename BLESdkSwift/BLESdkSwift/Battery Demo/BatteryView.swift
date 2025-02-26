import SwiftUI

struct BatteryView: View {
    @StateObject private var batteryVM = BatteryViewModel()
    
    var body: some View {
        VStack {
            Text("Battery Level")
                .font(.title)
                .bold()
            
            Text(batteryVM.batteryLevel)
                .font(.largeTitle)
                .foregroundColor(.green)
                .padding()
            
            Button("Get Battery Level") {
                batteryVM.getBatteryLevel()
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .padding()
    }
}
