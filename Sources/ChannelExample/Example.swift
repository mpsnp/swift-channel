import Channel
import Foundation

@main
struct Example {
    static func main() async throws {
        let c = Channel<Int>()
        
        // Producer task
        Task {
            for index in 0...1000 {
                print("+ \(String(format: "%04d", index)) Producer 1")
                await c.write(index)
            }
            await c.close()
        }
        
        // Producer task
        Task {
            for index in 1001...2000 {
                print("+ \(String(format: "%04d", index)) Producer 2")
                await c.write(index)
            }
            await c.close()
        }
        
        // Consumer task 1
        let task1 = Task {
            for await index in c {
                print("- \(String(format: "%04d", index)) Consumer 1")
            }
        }
        
        // Consumer task 2
        let task2 = Task {
            for await index in c {
                print("- \(String(format: "%04d", index)) Consumer 2")
                try await Task.sleep(nanoseconds: 30000)
            }
        }
        
        await task1.value
        try await task2.value
    }
}
