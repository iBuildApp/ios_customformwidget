//
//  EmailModel.swift
//  CustomFormModule
//
//  Created by Anton Boyarkin on 30/05/2019.
//

import Foundation

struct EmailModel: Codable {
    var address: String?
    var subject: String?
    var button: FormButtonModel?
    
    enum CodingKeys: String, CodingKey {
        case address = "#address"
        case subject = "#subject"
        case button
    }
}
