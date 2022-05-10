# swift-channel

Async safe value channel similar to Golang channels. Can be used to communicate between async Tasks in Swift and model pub-sub behaviour.

## Example usage

```swift
let c = Channel<Int>()

// Producer task
Task {
    for index in 0...1000 {
        print("+ \(String(format: "%04d", index)) Producer 1")
        await c.write(index)
    }
    await c.close()
}

// Consumer task
let task1 = Task {
    for await index in c {
        print("- \(String(format: "%04d", index)) Consumer 1")
    }
}
```

