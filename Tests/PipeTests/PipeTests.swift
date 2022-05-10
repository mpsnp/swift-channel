import XCTest
@testable import Pipe

final class ValuePipeTests: XCTestCase {
    func testWWRROrder() async {
        let pipe = ValuePipe<Int>()
        
        await pipe.write(1)
        await pipe.write(2)
        
        let value1 = await pipe.read()
        let value2 = await pipe.read()
        XCTAssertEqual(value1, 1)
        XCTAssertEqual(value2, 2)
    }
    
    func testWRWROrder() async {
        let pipe = ValuePipe<Int>()
        
        await pipe.write(1)
        let value1 = await pipe.read()
        XCTAssertEqual(value1, 1)
        
        await pipe.write(2)
        let value2 = await pipe.read()
        XCTAssertEqual(value2, 2)
    }
    
    func testRWOrder() async {
        let pipe = ValuePipe<Int>()
        
        Task.detached {
            await pipe.write(1)
        }
        
        let value1 = await pipe.read()
        XCTAssertEqual(value1, 1)
    }
    
    func testIterator() async {
        let pipe = ValuePipe<Int>()
        
        Task.detached {
            await pipe.write(1)
            await pipe.write(2)
        }
        
        for await value in pipe {
            XCTAssertEqual(value, 1)
            break
        }
        
        let value = await pipe.read()
        XCTAssertEqual(value, 2)
    }
    
    func testDetachedIterators() async {
        let pipe = ValuePipe<Int>()
        
        let task1 = Task.detached {
            for await value in pipe {
                XCTAssertEqual(value, 1)
                break
            }
        }
        
        let task2 = Task.detached {
            for await value in pipe {
                XCTAssertEqual(value, 2)
                break
            }
        }
        
        Task {
            await pipe.write(1)
        }
        Task {
            await pipe.write(2)
        }
        
        await task1.value
        await task2.value
    }
}
