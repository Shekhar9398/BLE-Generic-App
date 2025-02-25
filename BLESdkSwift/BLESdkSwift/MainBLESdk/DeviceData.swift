
import Foundation

class DeviceData {
    var dataType: DataType
    var dicData: [String: Any]?
    var dataEnd: Bool

    init(dataType: DataType, dicData: [String: Any]? = nil, dataEnd: Bool = false) {
        self.dataType = dataType
        self.dicData = dicData
        self.dataEnd = dataEnd
    }
}
