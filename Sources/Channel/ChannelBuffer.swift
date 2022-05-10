/// Buffers elements and continuations.
///
/// Allows:
/// - safely read buffered elements
/// - wait for new ones if buffer is empty
actor ChannelBuffer<Element> {
    private var bufferedValues: [Element] = []
    private var waitingDequeuers: [CheckedContinuation<Element?, Never>] = []

    private var isOpen: Bool = true
    
    func enqueue(_ element: Element) {
        guard isOpen else {
            assertionFailure("Channel is closed")
            return
        }
        
        if waitingDequeuers.isEmpty {
            return bufferedValues.append(element)
        }
        
        waitingDequeuers
            .removeFirst()
            .resume(returning: element)
    }
    
    func dequeue() async -> Element? {
        guard bufferedValues.isEmpty else {
            return bufferedValues.removeFirst()
        }
        
        guard isOpen else {
            return nil
        }
        
        return await withCheckedContinuation { continuation in
            waitingDequeuers.append(continuation)
        }
    }
    
    func close(mode: CloseMode) {
        isOpen = false
        
        switch mode {
        case .flush:
            bufferedValues = []
            for dequeuer in waitingDequeuers {
                dequeuer.resume(returning: nil)
            }
        case .waitConsumers:
            break
        }
    }
}
