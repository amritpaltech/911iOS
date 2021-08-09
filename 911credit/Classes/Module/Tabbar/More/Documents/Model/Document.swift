/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Document : Codable {
	let docId : Int?
	let documentType : String?
	let label : String?
	let description : String?
	let caseId : Int?
	let status : String?
	let action : String?
    var notes = ""
    

	enum CodingKeys: String, CodingKey {

		case docId = "doc_id"
		case documentType = "document_type"
		case label = "Label"
		case description = "description"
		case caseId = "case_id"
		case status = "status"
		case action = "action"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		docId = try values.decodeIfPresent(Int.self, forKey: .docId)
        documentType = try values.decodeIfPresent(String.self, forKey: .documentType)
		label = try values.decodeIfPresent(String.self, forKey: .label)
		description = try values.decodeIfPresent(String.self, forKey: .description)
        caseId = try values.decodeIfPresent(Int.self, forKey: .caseId)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		action = try values.decodeIfPresent(String.self, forKey: .action)
	}

}
