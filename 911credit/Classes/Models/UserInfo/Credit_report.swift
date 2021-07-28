/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
class CreditReport : Codable {
	let id : Int?
	let userId : Int?
	let score : String?
	let scoreDate : String?
	let source : String?
	let reportIdentifier : String?
	let reportFactor : String?
	let reportData : String?
	let createdAt : String?
	let updatedAt : String?
	let nextDate : String?
	let reportDate : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case userId = "user_id"
		case score = "score"
		case scoreDate = "score_date"
		case source = "source"
		case reportIdentifier = "report_identifier"
		case reportFactor = "report_factor"
		case reportData = "report_data"
		case createdAt = "created_at"
		case updatedAt = "updated_at"
		case nextDate = "next_date"
		case reportDate = "report_date"
	}

    required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
		score = try values.decodeIfPresent(String.self, forKey: .score)
        scoreDate = try values.decodeIfPresent(String.self, forKey: .scoreDate)
		source = try values.decodeIfPresent(String.self, forKey: .source)
        reportIdentifier = try values.decodeIfPresent(String.self, forKey: .reportIdentifier)
        reportFactor = try values.decodeIfPresent(String.self, forKey: .reportFactor)
        reportData = try values.decodeIfPresent(String.self, forKey: .reportData)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        nextDate = try values.decodeIfPresent(String.self, forKey: .nextDate)
        reportDate = try values.decodeIfPresent(String.self, forKey: .reportDate)
	}

}
