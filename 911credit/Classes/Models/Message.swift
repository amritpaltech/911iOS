//
//  Message.swift
//  911credit
//
//  Created by ideveloper5 on 10/07/21.
//

import Foundation

enum MessageSide {
    case left
    case right
}

struct Message {
    var text = ""
    var side: MessageSide = .right
}
