//
//  DataModel.swift
//  CustomFormModule
//
//  Created by Anton Boyarkin on 23/05/2019.
//

import Foundation
import IBACore

struct DataModel: Codable {
    var colorScheme: ColorSchemeModel?
    var form: FormModel
    
    enum CodingKeys: String, CodingKey {
        case colorScheme = "colorskin"
        case form
    }
}
