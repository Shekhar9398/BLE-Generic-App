import Foundation

enum DataType: Int {
    case getDeviceTime = 0, setDeviceTime, getPersonalInfo, setPersonalInfo, getDeviceInfo, setDeviceInfo, setDeviceID
    case getDeviceGoal, setDeviceGoal, getDeviceBattery, getDeviceMacAddress, getDeviceVersion, factoryReset, mcuReset
    case motorVibration, getDeviceName, setDeviceName, getAutomaticMonitoring, setAutomaticMonitoring, getAlarmClock
    case setAlarmClock, deleteAllAlarmClock, getSedentaryReminder, setSedentaryReminder, realTimeStep, totalActivityData
    case detailActivityData, detailSleepData, dynamicHR, staticHR, activityModeData, enterActivityMode, quitActivityMode
    case deviceSendDataToApp, enterTakePhotoMode, startTakePhoto, stopTakePhoto, backHomeView, hrvData, gpsData
    case setSocialDistanceReminder, getSocialDistanceReminder, automaticSpo2Data, manualSpo2Data, findMobilePhone
    case temperatureData, axillaryTemperatureData, sos, ecgHistoryData, startECG, stopECG, ecgRawData
    case ecgSuccessResult, ecgStatus, ecgFailed, deviceMeasurementHR, deviceMeasurementHRV, deviceMeasurementSpo2
    case unLockScreen, lockScreen, clickYesWhenUnLockScreen, clickNoWhenUnLockScreen, setWeather
    case openRRInterval, closeRRInterval, realtimeRRIntervalData, realtimePPIData, realtimePPGData
    case ppgStartSucessed, ppgStartFailed, ppgResult, ppgStop, ppgQuit, ppgMeasurementProgress, clearAllHistoryData
    case dataError = 255
}

struct DeviceTime {
    var year: Int
    var month: Int
    var day: Int
    var hour: Int
    var minute: Int
    var second: Int
}

struct PersonalInfo {
    var gender: Int
    var age: Int
    var height: Int
    var weight: Int
    var stride: Int
}

struct NotificationType {
    var call: Int
    var SMS: Int
    var wechat: Int
    var facebook: Int
    var instagram: Int
    var skype: Int
    var telegram: Int
    var twitter: Int
    var vkclient: Int
    var whatsapp: Int
    var qq: Int
    var linkedIn: Int
}

struct DeviceInfo {
    var distanceUnit: Int
    var timeUnit: Int
    var wristOn: Int
    var temperatureUnit: Int
    var notDisturbMode: Int
    var ANCS: Int
    var notificationType: NotificationType
    var baseHeartRate: Int
    var screenBrightness: Int
    var watchFaceStyle: Int
    var socialDistanceRemind: Int
    var language: Int
}

struct Weeks {
    var sunday: Bool
    var monday: Bool
    var tuesday: Bool
    var wednesday: Bool
    var thursday: Bool
    var friday: Bool
    var saturday: Bool
}

struct AutomaticMonitoring {
    var mode: Int
    var startTimeHour: Int
    var startTimeMinutes: Int
    var endTimeHour: Int
    var endTimeMinutes: Int
    var weeks: Weeks
    var intervalTime: Int
    var dataType: Int // 1: heartRate, 2: spo2, 3: temperature, 4: HRV
}

struct SedentaryReminder {
    var startTimeHour: Int
    var startTimeMinutes: Int
    var endTimeHour: Int
    var endTimeMinutes: Int
    var weeks: Weeks
    var intervalTime: Int
    var leastSteps: Int
    var mode: Int
}

struct AlarmClock {
    var openOrClose: Int
    var clockType: Int
    var endTimeHour: Int
    var endTimeMinutes: Int
    var weeks: Int
    var intervalTime: Int
    var leastSteps: Int
    var mode: Int
}

struct BPCalibrationParameter {
    var gender: Int
    var age: Int
    var height: Int
    var weight: Int
    var BP_high: Int
    var BP_low: Int
    var heartRate: Int
}

struct WeatherParameter {
    var weatherType: Int
    var currentTemperature: Int
    var highestTemperature: Int
    var lowestTemperature: Int
    var city: String
}

struct BreathParameter {
    var breathMode: Int
    var durationOfBreathingExercise: Int
}

struct SocialDistanceReminder {
    var scanInterval: Int8
    var scanTime: Int8
    var signalStrength: Int8
}

enum ActivityMode: Int {
    case run = 0, cycling, badminton, football, tennis, yoga, breath, dance, basketball, walk
    case workout, cricket, hiking, aerobics, pingPong, ropeJump, sitUps, volleyball
}
