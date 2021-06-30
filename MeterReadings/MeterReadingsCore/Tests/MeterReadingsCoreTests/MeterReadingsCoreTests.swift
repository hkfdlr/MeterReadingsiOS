import XCTest
@testable import MeterReadingsCore

class MockMeterTypeProvider : MeterTypeProvider {
    let meterTypes = MeterType.allCases
    func provideMeterTypes(completion: @escaping (Result<String, Error>) -> Void) {
        completion(.success(meterTypes))
    }
}

final class MeterReadingsCoreTests: XCTestCase {
    func testExample() {
        
        let meterTypeProvider = MeterReadingsRepository(meterTypeProvider: MockMeterTypeProvider())
        meterTypeProvider.provideMeterTypes()
    }

}
