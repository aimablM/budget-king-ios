import SwiftUI

struct WalletHomeView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var showingManual = false
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .top) {
            // Background color
            viewModel.themeColor
            
            // Main content
            VStack{
                // Header
                headerView
                
                // Content area
                ScrollView {
                    VStack(spacing: -10) {
                        // Add padding to account for the floating card
                        Spacer()
                            .frame(height: 180)
                        
                        // Transaction History
                        transactionHistoryView
                        
                    }
                    .padding(.horizontal)
                    .background(Color.white)
                }
            }
            
            // Floating balance card (positioned over the header)
            balanceCardView
                .padding(.horizontal)
                .padding(.top, 80) // Adjust this value to position the card
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        }.sheet(isPresented: $showingManual){
            ManualAdd(viewModel: viewModel).presentationDetents([.fraction(0.70)])
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Good afternoon,")
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                Text("\(viewModel.username)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 15)
        .padding(.bottom, 75)
        .background(viewModel.themeColor)
    }
    
    // MARK: - Balance Card View
    private var balanceCardView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(viewModel.themeColor)
                .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 6)
            
            VStack(spacing: 5) {
                HStack{
                    Text("Your budget:")
                        .foregroundColor(.white.opacity(0.9))
                        .fontWeight(.medium)
                    Spacer()
                }
                
                // Balance Amount
                Text("$\(viewModel.formatAmount(viewModel.budget))")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                // Income & Expenses
                HStack(alignment: .top) {
                    // Income
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 5) {
                            Image(systemName: "arrow.down")
                                .foregroundColor(.white.opacity(0.8))
                                .font(.system(size: 14))
                                .padding(8)
                                .background(Circle().foregroundColor(.white.opacity(0.1)))
                            
                            Text("Income")
                                .foregroundColor(.white.opacity(0.9))
                        }
                        
                        Text("$ \(viewModel.formatAmount(viewModel.income))")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    // Expenses
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 5) {
                            Image(systemName: "arrow.up")
                                .foregroundColor(.white.opacity(0.8))
                                .font(.system(size: 14))
                                .padding(8)
                                .background(Circle().foregroundColor(.white.opacity(0.1)))
                            
                            Text("Spending")
                                .foregroundColor(.white.opacity(0.9))
                        }
                        
                        Text("$ \(viewModel.formatAmount(viewModel.spending))")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding()
        }
        .frame(height: 220)
    }
    
    // MARK: - Transaction History View
    private var transactionHistoryView: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Recent Transactions")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button("+"){
                    showingManual = true
                }
            }
            VStack(spacing: 15) {
                ForEach(viewModel.transactions) { transaction in
                    TransactionRowView(transaction: transaction)
                }
            }
        }
    }
}

// MARK: - Transaction Row View
struct TransactionRowView: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: 15) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color.gray.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                if(transaction.isIncome){
                    Text(transaction.provider.first?.description ?? "").foregroundColor(.green).bold().font(.system(size: 25))
                }else{
                    Text(transaction.provider.first?.description ?? "").foregroundColor(.red).bold().font(.system(size: 25))
                }
            }
            
            // Transaction Details
            VStack(alignment: .leading, spacing: 5) {
                Text(transaction.provider)
                    .font(.headline)
                
                Text(transaction.date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Amount
            Text("\(transaction.isIncome ? "+" : "-") $ \(formatAmount(transaction.amount))")
                .font(.headline)
                .foregroundColor(transaction.isIncome ? .green : .red)
        }
        .padding(.vertical, 5)
    }
    
    private func formatAmount(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: amount)) ?? "0.00"
    }
}

// MARK: - Preview
struct WalletHomeView_Previews: PreviewProvider {
    static var previews: some View {
        WalletHomeView(viewModel: AppViewModel())
    }
}
