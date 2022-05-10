public enum CloseMode {
    case flush
    case waitConsumers
}

public struct Channel<Element> {
    private let buffer: ChannelBuffer<Element> = .init()
    
    public init() {
    }
    
    public func read() async -> Element? {
        await buffer.dequeue()
    }
    
    public func write(_ element: Element) async {
        await buffer.enqueue(element)
    }
    
    public func close(mode: CloseMode = .waitConsumers) async {
        await buffer.close(mode: mode)
    }
}

extension Channel: AsyncSequence {
    public func makeAsyncIterator() -> ChannelIterator<Element> {
        ChannelIterator(buffer: buffer)
    }
}
