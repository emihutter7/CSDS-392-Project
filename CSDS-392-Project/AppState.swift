//
//  AppState.swift
//  CSDS-392-Project
//
//  Created by Iciar Sanz on 20/4/26.
//

import SwiftUI

@Observable
@MainActor
final class AppState {
    var selectedTab: Int = 0 //number for 0 to 4, determines which tab is active (home, expenses, add, reports, settings)
    var currentUserEmail: String? // know the email of the person logged in without accessin authmodel in each screen
}
