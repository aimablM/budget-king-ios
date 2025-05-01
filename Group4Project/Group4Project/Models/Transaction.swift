//
//  Transaction.swift
//  Group4Project
//
//  Created by Aimable Mugwaneza on 5/1/25.
//
import Foundation
import SwiftUI

struct Transaction: Identifiable, Decodable {
    var id = UUID()
    let provider: String
    let amount: Double
    let date: String
    let isIncome: Bool
}

struct userData {
    // Struct for user data taken from server/http requests
    // This can be expanded later as needed
}
