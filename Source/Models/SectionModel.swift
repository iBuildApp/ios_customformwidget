//
//  SectionModel.swift
//  CustomFormModule
//
//  Created by Anton Boyarkin on 30/05/2019.
//

import Foundation

struct SectionModel: Codable {
    var title: String
    var fields: [FieldModel]
    
    enum CodingKeys: String, CodingKey {
        case title = "#title"
        case fields
    }
}

extension SectionModel {
    var groupedFields: [BaseField] {
        var grouped = [BaseField]()
        
        var radioGroup = [FieldModel]()
        for field in fields {
            if field.type == .radiobutton {
                radioGroup.append(field)
            } else {
                if !radioGroup.isEmpty {
                    let radioGroupField = RadioGroupModel(fields: radioGroup)
                    grouped.append(radioGroupField)
                    radioGroup = [FieldModel]()
                }
                grouped.append(field)
            }
        }
        
        if !radioGroup.isEmpty {
            let radioGroupField = RadioGroupModel(fields: radioGroup)
            grouped.append(radioGroupField)
            radioGroup = [FieldModel]()
        }
        
        return grouped
    }
}
