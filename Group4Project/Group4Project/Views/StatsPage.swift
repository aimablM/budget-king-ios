//
//  StatsPage.swift
//  Group4Project
//
//  Created by Aimable Mugwaneza on 5/1/25.
//

import SwiftUI

//Statistics page view
struct StatsPage: View {
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        VStack {  // Wrap everything in a VStack
            HStack {
                Text("Spending History:")
                    .font(.system(size: 20))
                    .padding()
                Spacer()
            }
            
            Text("Graph here could be nice").padding()
            
            HStack {
                Spacer()
                Button("Last Week") {
                    //Filters graph by last week of spending
                }
                Spacer()
                Button("Last Month") {
                    //Filters graph by last month of spending
                }
                Spacer()
                Button("Last Year") {
                    //Filters graph by last year of spending
                }
                Spacer()
            }
            
            VStack {
                Text("Amount Spent: $\(viewModel.formatAmount(viewModel.spending))")
                    .font(.system(size: 20))
                Text("Budget: $\(viewModel.formatAmount(viewModel.budget))")
                    .font(.system(size: 20))
            }.padding()
            
            Text("List with transaction history here")
            
            // List would go here with full transaction history
            List {
                ForEach(viewModel.transactions) { transaction in
                    HStack {
                        Text(transaction.date)
                        Spacer()
                        Text(viewModel.formatAmount(transaction.amount))
                    }
                }
            }
            Spacer()
        }
        .onAppear {
            // Simply log that the view appeared - no need to set mock data here
            print("StatsPage appeared")
            
            // For future implementation, use the viewModel's fetch method instead
            // Task {
            //     await viewModel.fetchTransactions()
            // }
        }
    }
}

struct StatsPage_Previews: PreviewProvider {
    static var previews: some View {
        StatsPage(viewModel: AppViewModel())
    }
}
