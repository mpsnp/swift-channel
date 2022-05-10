import XCTest
@testable import Channel

final class ValuePipeTests: XCTestCase {
    func testWWRROrder() async {
        let c = Channel<Int>()
        
        await c.write(1)
        await c.write(2)
        
        let value1 = await c.read()
        let value2 = await c.read()
        XCTAssertEqual(value1, 1)
        XCTAssertEqual(value2, 2)
    }
    
    func testWRWROrder() async {
        let c = Channel<Int>()
        
        await c.write(1)
        let value1 = await c.read()
        XCTAssertEqual(value1, 1)
        
        await c.write(2)
        let value2 = await c.read()
        XCTAssertEqual(value2, 2)
    }
    
    func testRWOrder() async {
        let c = Channel<Int>()
        
        Task.detached {
            await c.write(1)
        }
        
        let value1 = await c.read()
        XCTAssertEqual(value1, 1)
    }
    
    func testIterator() async {
        let c = Channel<Int>()
        
        Task.detached {
            await c.write(1)
            await c.write(2)
        }
        
        for await value in c {
            XCTAssertEqual(value, 1)
            break
        }
        
        let value = await c.read()
        XCTAssertEqual(value, 2)
    }
    
    func testDetachedIterators() async {
        let c = Channel<Int>()
        
        let task1 = Task.detached {
            for await value in c {
                XCTAssertEqual(value, 1)
                break
            }
        }
        
        let task2 = Task.detached {
            for await value in c {
                XCTAssertEqual(value, 2)
                break
            }
        }
        
        Task {
            await c.write(1)
        }
        Task {
            await c.write(2)
        }
        
        await task1.value
        await task2.value
    }
}
