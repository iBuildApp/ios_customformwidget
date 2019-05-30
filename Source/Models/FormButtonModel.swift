//
//  FormButtonModel.swift
//  CustomFormModule
//
//  Created by Anton Boyarkin on 30/05/2019.
//

import Foundation

struct FormButtonModel: Codable {
    var label: String?
    
    enum CodingKeys: String, CodingKey {
        case label = "#label"
    }
}
