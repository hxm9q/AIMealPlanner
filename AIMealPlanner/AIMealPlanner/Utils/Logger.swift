import Foundation

enum LogLevel {
    case info, warning, error
}

struct Logger {
    static func log(_ level: LogLevel, _ message: String) {
#if DEBUG
        print("[\(level)] \(message)")
#endif
    }
}
