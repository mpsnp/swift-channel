public struct ValuePipe<Element> {
    private let buffer: PipeBuffer<Element> = .init()
    
    public init() {
    }
    
    public func read() async -> Element {
        await buffer.dequeue()
    }
    
    public func write(_ element: Element) async {
        await buffer.enqueue(element)
    }
}

extension ValuePipe: AsyncSequence {
    public func makeAsyncIterator() -> PipeIterator<Element> {
        PipeIterator(buffer: buffer)
    }
}
