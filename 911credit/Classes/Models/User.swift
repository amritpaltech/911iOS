//
//  User.swift
//  911credit
//
//  Created by ideveloper5 on 08/07/21.
//

import Foundation

// MARK: - User
class User: Codable {
    let id, issecurityquestions: Int?
    let firstName, lastName, email, emailVerifiedAt: String?
    let apiToken, createdAt, updatedAt, phoneNumber: String?
    let status, userAvatar, token2Fa, token2FaExpiry: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case emailVerifiedAt = "email_verified_at"
        case apiToken = "api_token"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case phoneNumber = "phone_number"
        case status
        case userAvatar = "user_avatar"
        case token2Fa = "token_2fa"
        case token2FaExpiry = "token_2fa_expiry"
        case issecurityquestions = "is_security_questions"
    }

    init(id: Int?, firstName: String?, lastName: String?, email: String?, emailVerifiedAt: String?, apiToken: String?, createdAt: String?, updatedAt: String?, phoneNumber: String?, status: String?, userAvatar: String?, token2Fa: String?, token2FaExpiry: String?, issecurityquestions: Int?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.emailVerifiedAt = emailVerifiedAt
        self.apiToken = apiToken
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.phoneNumber = phoneNumber
        self.status = status
        self.userAvatar = userAvatar
        self.token2Fa = token2Fa
        self.token2FaExpiry = token2FaExpiry
        self.issecurityquestions = issecurityquestions
    }
}
