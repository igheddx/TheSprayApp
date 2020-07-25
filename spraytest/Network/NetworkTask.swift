//
//  NetworkTask.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 5/11/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import Foundation

/**
 A semi-opaque object returned by the Network stack which allows you to cancel requests.
 Note: when you call cancel, the task may not yet have started. But as soon as it does start, it will immediately cancel.
 */
class NetworkTask {
    private var task: URLSessionTask?
    private var cancelled = false

    let queue = DispatchQueue(label: "com.peterlivesey.networkTask", qos: .utility)

    func cancel() {
        queue.sync {
            cancelled = true

            if let task = task {
                task.cancel()
            }
        }
    }
    
    func set(_ task: URLSessionTask) {
        queue.sync {
            self.task = task

            if cancelled {
                task.cancel()
            }
        }
    }
}
