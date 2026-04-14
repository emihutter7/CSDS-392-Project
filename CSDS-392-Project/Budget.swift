//
//  Budget.swift
//  CSDS-392-Project
//
//  Created by Emi Hutter-DeMarco on 4/14/26.
//

import Foundation

import SwiftData

@Model
final class Budget {
    var id: UUID
    var username: String
    var email: String
    var password: String

    init(username: String, email: String, password: String) {
        self.id = UUID()
        self.username = username
        self.email = email
        self.password = password
    }
}
