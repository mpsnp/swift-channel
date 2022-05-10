/// Iterates over pipe input
public struct ChannelIterator<Element>: AsyncIteratorProtocol {
    private let buffer: ChannelBuffer<Element>
    
    init(buffer: ChannelBuffer<Element>) {
        self.buffer = buffer
    }
    
    public func next() async -> Element? {
        await buffer.dequeue()
    }
}
