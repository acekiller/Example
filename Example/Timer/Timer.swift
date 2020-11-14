//
//  Timer.swift
//  Example
//
//  Created by Mars Scala on 2020/11/12.
//

import Foundation

public final class Timer {
    private let timer: DispatchSourceTimer
    private let timeout: Double
    private let `repeat`: Bool
    private let completion: () -> Void
    private let queue: DispatchQueue
    private var isRunning: Bool

    public init(timeout: Double, `repeat`: Bool, completion: @escaping() -> Void, queue: DispatchQueue) {
        self.timeout = timeout
        self.`repeat` = `repeat`
        self.completion = completion
        self.queue = queue
        self.timer = DispatchSource.makeTimerSource(queue: self.queue)
        self.isRunning = false
    }

    deinit {
        self.invalidate()
    }

    public func start() {
        assert(!isRunning)
        isRunning = true
        timer.setEventHandler(handler: { [weak self] in
            if let strongSelf = self {
                strongSelf.completion()
                if !strongSelf.`repeat` {
                    strongSelf.invalidate()
                }
            }
        })

        if self.`repeat` {
            let time: DispatchTime = DispatchTime.now() + self.timeout
            timer.schedule(deadline: time, repeating: self.timeout)
        } else {
            let time: DispatchTime = DispatchTime.now() + self.timeout
            timer.schedule(deadline: time)
        }

        timer.resume()
    }

    public func invalidate() {
        guard self.isRunning else {
            return
        }
        isRunning = false
        self.timer.cancel()
    }
}
