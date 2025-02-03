//
//  Dispose.swift
//  JobLoyal
//
//  Created by Sina khanjani on 12/11/1399 AP.
//

import Foundation

public class DisposeBag {
    private var disposables = [Disposable]()
        
    func insert(disposable : Disposable) {
        disposables.append(disposable)
    }
    
    func dispose() {
        for disposable in disposables {
            disposable.dispose()
        }
        disposables.removeAll(keepingCapacity: false)
    }
    
    deinit {
        dispose()
    }
}

public class Disposable {
    static var head: [String:String] = [:]

    public func dispose() { }
}

extension Disposable {
    func disposed(by disposeBag : DisposeBag) {
        disposeBag.insert(disposable: self)
    }
}

extension Disposable {
    public static func configuration(_ setupNetwork: @escaping () -> Dictionary<String, String>) {
        self.head = setupNetwork()
    }
}
