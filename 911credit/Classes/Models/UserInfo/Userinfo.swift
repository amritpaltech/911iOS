/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
class Userinfo : Codable {
	var id : Int?
    var firstName : String?
    var lastName : String?
    var email : String?
    var emailVerifiedAt : String?
    var apiToken : String?
    var createdAt : String?
    var updatedAt : String?
    var phoneNumber : String?
    var status : String?
    var userAvatar : String?
    var token2fa : String?
    var token2faExpiry : String?
    var roles : [Roles]?

	enum CodingKeys: String, CodingKey {
		case id = "id"
		case firstName = "first_name"
		case lastName = "last_name"
		case email = "email"
		case emailVerifiedAt = "email_verified_at"
		case apiToken = "api_token"
		case createdAt = "created_at"
		case updatedAt = "updated_at"
		case phoneNumber = "phone_number"
		case status = "status"
		case userAvatar = "user_avatar"
		case token2fa = "token_2fa"
		case token2faExpiry = "token_2fa_expiry"
		case roles = "roles"
	}
}
