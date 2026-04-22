//
//  TellerModels.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/21/26.
//

import Foundation

struct TellerEnrollment: Codable {
    let accessToken: String
    let user: TellerUser
    let enrollment: TellerEnrollmentInfo

    enum CodingKeys: String, CodingKey {
        case accessToken
        case user
        case enrollment
    }
}

struct TellerUser: Codable {
    let id: String
}

struct TellerEnrollmentInfo: Codable {
    let id: String
    let institution: TellerInstitution
}

struct TellerInstitution: Codable {
    let name: String
}

struct TellerAccount: Codable, Identifiable {
    let id: String
    let name: String
    let type: String
    let subtype: String?
    let currency: String
    let enrollmentId: String
    let lastFour: String?
    let institution: TellerInstitution

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case subtype
        case currency
        case institution
        case enrollmentId = "enrollment_id"
        case lastFour = "last_four"
    }
}

struct TellerTransaction: Codable, Identifiable {
    let id: String
    let accountId: String?
    let description: String
    let amount: String
    let date: String
    let status: String?
    let details: TellerTransactionDetails?

    enum CodingKeys: String, CodingKey {
        case id
        case accountId = "account_id"
        case description
        case amount
        case date
        case status
        case details
    }
}

struct TellerTransactionDetails: Codable {
    let category: String?
    let processingStatus: String?

    enum CodingKeys: String, CodingKey {
        case category
        case processingStatus = "processing_status"
    }
}
