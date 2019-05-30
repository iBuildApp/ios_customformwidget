//
//  RadioGroupModel.swift
//  CustomFormModule
//
//  Created by Anton Boyarkin on 30/05/2019.
//

import Foundation

struct RadioGroupModel {
    let fields: [FieldModel]
}

extension RadioGroupModel: BaseField {
    var type: FieldType { return .radiogroup }
    var format: FieldFormatType? { return nil }
    var label: String { return "" }
    var limit: Int? { return nil }
    var value: String? { return nil }
    var values: [String]? { return nil }
}
