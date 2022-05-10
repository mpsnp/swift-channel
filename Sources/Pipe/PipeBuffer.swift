/// Buffers elements and continuations.
///
/// Allows:
/// - safely read buffered elements
/// - wait for new ones if buffer is empty
actor PipeBuffer<Element> {
    private var bufferedValues: [Element] = []
    private var waitingDequeuers: [CheckedContinuation<Element, Never>] = []
    
    func enqueue(_ element: Element) {
        if waitingDequeuers.isEmpty {
            return bufferedValues.append(element)
        }
        
        waitingDequeuers
            .removeFirst()
            .resume(returning: element)
    }
    
    func dequeue() async -> Element {
        guard bufferedValues.isEmpty else {
            return bufferedValues.removeFirst()
        }
        
        return await withCheckedContinuation { continuation in
            waitingDequeuers.append(continuation)
        }
    }
}
