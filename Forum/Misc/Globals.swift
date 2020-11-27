//
//  Globals.swift
//  Forum
//
//  Created by Oscar on 2020/10/5.
//

import Foundation
import UIKit

extension String {
    var linebreaks: Int {
        self.reduce(1) {
            $0 + ($1 == "\n" ? 1 : 0)
        }
    }
}

class StoredObject<T> {
    var id: String
    var nothing: () -> T
    init(_ i: String, _ n: @escaping () -> T) {
        id = i
        nothing = n
    }
    var content: T {
        get {
            (UserDefaults.standard.object(forKey: id) as? T) ?? nothing()
        }
        set(val) {
            UserDefaults.standard.setValue(val, forKey: id)
        }
    }
}

class G {
    
    static let token = StoredObject<String>("ForumUserToken", { .init() })
    static let networkStat = StoredObject<[Double]>("ForumNetworkStat", { .init() })
    static func updateStat(_ i: Double) {
        var d = G.networkStat.content
        if d.count != 5 {
            d = [0, 0, 1e10, -1e10, 0]
        }
        if i > 0 {
            d[0] += i
            d[1] += 1
            d[2] = min(d[2], i)
            d[3] = max(d[3], i)
        } else {
            d[4] += 1
        }
        G.networkStat.content = d
    }
    static let numberPerFetch = 8
    static let blockedList = StoredObject<[String]>("ForumBlockedList", { .init() })
    
    static var hasLoggedIn: Bool {token.content != ""}
    
}


