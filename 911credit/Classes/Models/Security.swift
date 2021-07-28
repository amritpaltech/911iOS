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
    let userinfo : Userinfo?
    let creditReport : CreditReport?
    let creditReportHistory : [CreditReportHistory]?


    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case questions
        case authToken = "auth_token"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userinfo = "userinfo"
        case creditReport = "credit_report"
        case creditReportHistory = "credit_report_history"

    }

    init(id: Int?, userID: Int?, questions: String?, authToken: String?, status: String?, createdAt: String?, updatedAt: String?,userinfo : Userinfo?, creditReport : CreditReport?,creditReportHistory : [CreditReportHistory]?) {
        self.id = id
        self.userID = userID
        self.questions = questions
        self.authToken = authToken
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.userinfo = userinfo
        self.creditReport = creditReport
        self.creditReportHistory = creditReportHistory
    }
}
