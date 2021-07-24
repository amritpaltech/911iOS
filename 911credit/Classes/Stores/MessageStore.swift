//
//  MessageStore.swift
//  911credit
//
//  Created by ideveloper5 on 10/07/21.
//

import Foundation

struct MessageStore {
    static func getAll() -> [Message] {
        return [
            Message(text: "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.", side: .left),
            Message(text: "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown.", side: .right),
            Message(text: "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.", side: .left),
            Message(text: "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown.", side: .right),
            Message(text: "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.", side: .left),
            Message(text: "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown.", side: .right),
        ]
    }
}
