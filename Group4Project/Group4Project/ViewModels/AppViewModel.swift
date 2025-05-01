//
//  AppViewModel.swift
//  Group4Project
//
//  Created by Aimable Mugwaneza on 5/1/25.
//
import SwiftUI
import Combine
import Foundation

import SwiftUI
import Combine
import Foundation

@MainActor
class AppViewModel: ObservableObject {
    // MARK: - Published Properties
    let themeColor = Color.teal
    @Published var loggedIn = true
    @Published var budget = 3200.00
    @Published var username = "James Madison"
    @Published var bankLinked = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // MARK: - Transactions with existing mock data
    @Published var transactions: [Transaction] = [
        Transaction(provider: "Upwork", amount: 850.00, date: "Today", isIncome: true),
            Transaction(provider: "Paypal", amount: 1406.00, date: "Jan 30, 2022", isIncome: true),
            Transaction(provider: "Youtube", amount: 11.99, date: "Jan 16, 2022", isIncome: false),
            Transaction(provider: "Grocery Store", amount: 120.50, date: "Apr 30, 2025", isIncome: false),
            Transaction(provider: "Coffee Shop", amount: 45.99, date: "Apr 28, 2025", isIncome: false),
            Transaction(provider: "Salary", amount: 210.75, date: "Apr 25, 2025", isIncome: true),
            Transaction(provider: "Amazon", amount: 79.99, date: "Apr 20, 2025", isIncome: false),
            Transaction(provider: "Uber", amount: 25.50, date: "Apr 18, 2025", isIncome: false),
            Transaction(provider: "Freelance", amount: 350.00, date: "Apr 15, 2025", isIncome: true),
            Transaction(provider: "Apple", amount: 9.99, date: "Apr 10, 2025", isIncome: false),
            Transaction(provider: "Spotify", amount: 15.00, date: "Apr 5, 2025", isIncome: false),
            Transaction(provider: "Rent", amount: 1200.00, date: "Apr 1, 2025", isIncome: false),
            Transaction(provider: "Stock Dividend", amount: 45.00, date: "Mar 30, 2025", isIncome: true),
            Transaction(provider: "Netflix", amount: 13.99, date: "Mar 25, 2025", isIncome: false),
            Transaction(provider: "Consulting", amount: 500.00, date: "Mar 20, 2025", isIncome: true),
            Transaction(provider: "Target", amount: 86.40, date: "Mar 15, 2025", isIncome: false),
            Transaction(provider: "Airbnb", amount: 230.00, date: "Mar 12, 2025", isIncome: true),
            Transaction(provider: "Gas Station", amount: 60.75, date: "Mar 10, 2025", isIncome: false),
            Transaction(provider: "Bonus", amount: 1000.00, date: "Mar 5, 2025", isIncome: true),
            Transaction(provider: "Etsy", amount: 320.00, date: "Mar 1, 2025", isIncome: true),
            Transaction(provider: "iCloud", amount: 0.99, date: "Feb 28, 2025", isIncome: false),
            Transaction(provider: "Dropbox", amount: 11.99, date: "Feb 25, 2025", isIncome: false),
            Transaction(provider: "Bookstore", amount: 33.25, date: "Feb 20, 2025", isIncome: false),
            Transaction(provider: "Tech Repair", amount: 75.00, date: "Feb 15, 2025", isIncome: false),
            Transaction(provider: "Gym", amount: 55.00, date: "Feb 10, 2025", isIncome: false),
            Transaction(provider: "Invoice #245", amount: 675.00, date: "Feb 5, 2025", isIncome: true),
            Transaction(provider: "Medical", amount: 150.00, date: "Feb 1, 2025", isIncome: false),
            Transaction(provider: "Taxi", amount: 18.20, date: "Jan 28, 2025", isIncome: false),
            Transaction(provider: "Electric Bill", amount: 92.75, date: "Jan 25, 2025", isIncome: false),
            Transaction(provider: "Streaming Bundle", amount: 29.99, date: "Jan 20, 2025", isIncome: false),
        Transaction(provider: "DoorDash", amount: 23.49, date: "Jan 15, 2025", isIncome: false),
        Transaction(provider: "Freelance Writing", amount: 425.00, date: "Jan 10, 2025", isIncome: true),
        Transaction(provider: "Water Bill", amount: 48.25, date: "Jan 5, 2025", isIncome: false),
        Transaction(provider: "eBay", amount: 135.00, date: "Jan 2, 2025", isIncome: true),
        Transaction(provider: "Hair Salon", amount: 65.00, date: "Dec 28, 2024", isIncome: false),
        Transaction(provider: "Client Payment", amount: 720.00, date: "Dec 20, 2024", isIncome: true),
        Transaction(provider: "Holiday Shopping", amount: 310.60, date: "Dec 15, 2024", isIncome: false),
        Transaction(provider: "Dog Walker", amount: 30.00, date: "Dec 10, 2024", isIncome: false),
        Transaction(provider: "Photography Gig", amount: 280.00, date: "Dec 5, 2024", isIncome: true),
        Transaction(provider: "Gas Station", amount: 62.40, date: "Dec 1, 2024", isIncome: false)
    ]
    
    // MARK: - Computed Properties (unchanged from original)
    var spending: Double {
        transactions
            .filter { !$0.isIncome }
            .reduce(0.0) { $0 + $1.amount }
    }
    
    var income: Double {
        transactions
            .filter { $0.isIncome }
            .reduce(0.0) { $0 + $1.amount }
    }
    
    // MARK: - Initialization
    init() {
        // Mock data is already loaded above
        print("AppViewModel initialized")
    }
    
    // MARK: - Formatting Methods (as in original)
    func formatAmount(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: amount)) ?? "0.00"
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
    
    // MARK: - Transaction Management
    func addManualTransaction(provider: String, amount: Double, date: Date, isIncome: Bool) {
        transactions.append(Transaction(provider: provider, amount: amount, date: formatDate(date), isIncome: isIncome))
    }
    
    // MARK: - Authentication and User Management
    func login(email: String, password: String) {
        // For testing purposes, simulate login
        Task { [weak self] in
            do {
                try await AccessManager.shared.logIn(email: email, password: password)
                // After successful login:
                DispatchQueue.main.async {
                    self?.loggedIn = true
                }
            } catch {
                print("Login error: \(error)")
            }
        }
    }
    
    func logout() {
        // For now, just reset state
        loggedIn = false
        // Will connect to backend later
    }
    
    // MARK: - Data Fetching Templates (for future backend integration)
    
    // Template function for fetching transactions from backend
    @discardableResult
    func fetchTransactions() async -> Bool {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = true
            self?.errorMessage = nil
        }
        
        do {
            // Simulate network delay (2 seconds)
            try await Task.sleep(nanoseconds: 2_000_000_000)
            
            // This will be replaced with actual API call:
            // let fetchedTransactions = try await AccessManager.shared.getTransactions()
            // self.transactions = fetchedTransactions
            
            // For now, use the mock data
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = false
            }
            return true
        } catch {
            DispatchQueue.main.async { [weak self] in
                self?.errorMessage = "Failed to load transactions: \(error.localizedDescription)"
                self?.isLoading = false
            }
            return false
        }
    }
    
    // Template function for updating budget on backend
    func updateBudget(_ newAmount: Double) {
        budget = newAmount
        
        // Future backend implementation - won't cause build errors
        // Task { [weak self] in
        //     do {
        //         try await AccessManager.shared.updateUserBudget(amount: newAmount)
        //     } catch {
        //         print("Error updating budget on backend: \(error)")
        //     }
        // }
    }
    
    // Template function for updating spending on backend
    func updateSpending(_ newAmount: Double) {
        // Note: In your real implementation, spending is computed from transactions
        // This is just for compatibility with your existing code
        
        // Future backend implementation - won't cause build errors
        // Task { [weak self] in
        //     do {
        //         try await AccessManager.shared.updateUserSpending(amount: newAmount)
        //     } catch {
        //         print("Error updating spending on backend: \(error)")
        //     }
        // }
    }
    
    // MARK: - Bank Connection Management
    func linkBankAccount() {
        Task { [weak self] in
            do {
                try await AccessManager.shared.createLinkToken()
                DispatchQueue.main.async {
                    self?.bankLinked = true
                }
            } catch {
                print("Error linking bank: \(error)")
            }
        }
    }
    
    func unlinkBankAccount() {
        // Will be implemented later
        DispatchQueue.main.async { [weak self] in
            self?.bankLinked = false
        }
    }
}
