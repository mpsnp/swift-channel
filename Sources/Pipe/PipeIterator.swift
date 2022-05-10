/// Iterates over pipe input
public struct PipeIterator<Element>: AsyncIteratorProtocol {
    private let buffer: PipeBuffer<Element>
    
    init(buffer: PipeBuffer<Element>) {
        self.buffer = buffer
    }
    
    public func next() async -> Element? {
        await buffer.dequeue()
    }
}
