import Foundation

/// RCON 响应包结构
public struct RCONPacket {
    /// 包的大小（字节数）
    public let size: UInt32
    /// 包的ID
    public let id: UInt32
    /// 包的类型
    public let type: MessageType
    /// 响应的body内容
    public let body: String

    /// 从原始数据解析RCON包
    /// - Parameter data: 从服务器接收的原始数据
    /// - Throws: 解析错误
    public init(from data: Data) throws {
        guard data.count >= 12 else {
            throw RCONError.invalidPacketSize
        }

        // 解析包大小（前4字节，小端序）
        self.size = data.subdata(in: 0..<4).withUnsafeBytes { $0.load(as: UInt32.self) }

        // 解析包ID（接下来4字节，小端序）
        self.id = data.subdata(in: 4..<8).withUnsafeBytes { $0.load(as: UInt32.self) }

        // 解析包类型（接下来4字节，小端序）
        let typeValue = data.subdata(in: 8..<12).withUnsafeBytes { $0.load(as: UInt32.self) }
        guard let messageType = MessageType(rawValue: typeValue) else {
            throw RCONError.invalidPacketType
        }
        self.type = messageType

        // 解析body（剩余数据，去掉最后的两个null字节）
        let bodyData = data.subdata(in: 12..<(data.count - 2))
        guard let bodyString = String(data: bodyData, encoding: .ascii) else {
            throw RCONError.invalidBodyEncoding
        }
        self.body = bodyString
    }
}

/// RCON相关错误
public enum RCONError: Error {
    case invalidPacketSize
    case invalidPacketType
    case invalidBodyEncoding
}
