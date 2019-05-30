//
//  FieldModel.swift
//  CustomFormModule
//
//  Created by Anton Boyarkin on 30/05/2019.
//

import Foundation

enum FieldType: String, Codable {
    case entryfield
    case photopicker
    case checkbox
    case radiobutton
    case dropdown
    case datepicker
    case textarea
    
    case radiogroup
    
    case unknown
    
    init(from decoder: Decoder) throws {
        self = try FieldType(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}

enum FieldFormatType: String, Codable {
    case general
    case number
    
    case unknown
    
    init(from decoder: Decoder) throws {
        self = try FieldFormatType(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}

protocol BaseField {
    var type: FieldType { get }
    var format: FieldFormatType? { get }
    var label: String { get }
    var limit: Int? { get }
    var value: String? { get }
    var values: [String]? { get }
}

struct FieldModel: BaseField, Codable {
    var type: FieldType
    var format: FieldFormatType?
    var label: String
    var limit: Int?
    var value: String?
    var values: [String]?
    
    enum CodingKeys: String, CodingKey {
        case type
        case format = "@format"
        case label = "#label"
        case limit
        case value = "#value"
        case values = "value"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(FieldType.self, forKey: .type)
        self.format = try container.decodeIfPresent(FieldFormatType.self, forKey: .format)
        self.label = try container.decode(String.self, forKey: .label)
        if let value = try container.decodeIfPresent(String.self, forKey: .limit) {
            self.limit = Int(value)
        }
        if let value = try? container.decodeIfPresent(String.self, forKey: .value) {
            self.value = value
        }
        if let values = try? container.decodeIfPresent([String].self, forKey: .values) {
            self.values = values
        }
    }
}
