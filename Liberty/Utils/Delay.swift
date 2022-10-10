//
//  Delay.swift
//  Liberty
//
//  Created by Yury Soloshenko on 10.10.2022.
//

import Foundation

public class Delay {
    
    private var timer: Timer?
    
    public init() {}
    
    // New call delayExecution terminate previous
    public func execute(after delay: TimeInterval,  completion: @escaping (() -> Void)) {
        if delay <= 0 {
            completion()
            return
        }
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in completion() }
    }
    
    public func stop() {
        timer?.invalidate()
    }
}
