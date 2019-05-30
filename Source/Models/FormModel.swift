//
//  FormModel.swift
//  CustomFormModule
//
//  Created by Anton Boyarkin on 30/05/2019.
//

import Foundation

struct FormModel: Codable {
    var email: EmailModel?
    var groups: [SectionModel]
    
    enum CodingKeys: String, CodingKey {
        case email
        case groups
    }
}
