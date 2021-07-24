//
//  Security.swift
//  911credit
//
//  Created by ideveloper5 on 23/07/21.
//

import Foundation

// MARK: - Security
class Security: Codable {
    let id, userID: Int?
    let questions, authToken, status, createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case questions
        case authToken = "auth_token"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    init(id: Int?, userID: Int?, questions: String?, authToken: String?, status: String?, createdAt: String?, updatedAt: String?) {
        self.id = id
        self.userID = userID
        self.questions = questions
        self.authToken = authToken
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
