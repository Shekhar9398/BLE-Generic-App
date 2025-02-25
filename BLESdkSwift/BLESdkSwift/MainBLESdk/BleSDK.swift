import Foundation

class BleSDK {
    static let shared = BleSDK()
    
    private init() {}
    
    func getDeviceTime() -> Data {
        return Data()
    }
    
    func getPersonalInfo() -> Data {
        return Data()
    }
    
    func getDeviceInfo() -> Data {
        return Data()
    }
  
    func setDeviceID(deviceID: String) -> Data {
        return Data()
    }
    
    func getStepGoal() -> Data {
        return Data()
    }
    
    func setStepGoal(stepGoal: Int) -> Data {
        return Data()
    }
    
    func unlockScreen() -> Data {
        return Data()
    }
    
    func lockScreen() -> Data {
        return Data()
    }
    
    func getDeviceBatteryLevel() -> Data {
        return Data()
    }
    
    func getDeviceMacAddress() -> Data {
        return Data()
    }
    
    func getDeviceVersion() -> Data {
        return Data()
    }
    
    func reset() -> Data {
        return Data()
    }
    
    func mcuReset() -> Data {
        return Data()
    }
    
    func motorVibration(times: Int) -> Data {
        return Data()
    }
    
    func getDeviceName() -> Data {
        return Data()
    }
    
    func setDeviceName(deviceName: String) -> Data {
        return Data()
    }
    
    func getAutomaticMonitoring(dataType: Int) -> Data {
        return Data()
    }
    
    func getAlarmClock() -> Data {
        return Data()
    }
    
    func deleteAllAlarmClock() -> Data {
        return Data()
    }
    
    func setAlarmClock(allClock: [NSDictionary]?) -> [Data]? {
        return nil
    }
    
    func getSedentaryReminder() -> Data {
        return Data()
    }
    
    func startDeviceMeasurement(type: Int, isOpen: Bool, isPPGOpen: Bool, isPPIOpen: Bool) -> Data {
        return Data()
    }
    
    func startECGMode() -> Data {
        return Data()
    }
    
    func stopECGMode() -> Data {
        return Data()
    }
    
    func getECGHistoryData(type: Int16, startDate: Date) -> Data {
        return Data()
    }
    
    func ppg(mode: Int, status: Int) -> Data {
        return Data()
    }
    
    func realTimeData(type: Int8) -> Data {
        return Data()
    }
    
    func getTotalActivityData(mode: Int, startDate: Date) -> Data {
        return Data()
    }
    
    func getDetailActivityData(mode: Int, startDate: Date) -> Data {
        return Data()
    }
    
    ///Mark:- Need Implementation and UI
    
   /*
        func setWeather(weatherParameter: MyWeatherParameter) -> Data {
            return Data()
        }
    
        func setSedentaryReminder(sedentaryReminder: MySedentaryReminder) -> Data {
            return Data()
        }
    
        func setAutomaticHRMonitoring(automaticMonitoring: MyAutomaticMonitoring) -> Data {
            return Data()
        }
    
    
       func setDeviceInfo(deviceInfo: MyDeviceInfo) -> Data {
            return Data()
        }
    
        func setPersonalInfo(personalInfo: MyPersonalInfo) -> Data {
            return Data()
        }
    
        func setDeviceTime(deviceTime: MyDeviceTime) -> Data {
            return Data()
        }
        
  */
}
