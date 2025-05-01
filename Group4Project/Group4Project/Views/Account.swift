//
//  Account.swift
//  Group4Project
//
//  Created by Riley Forney on 4/23/25.
//

import SwiftUI

//Account page view
struct AccountPage: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var showingSheet: Bool = false;
    
    var body: some View {
        ZStack {
            viewModel.themeColor.ignoresSafeArea(.all)
            VStack{
                Text("Your account")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 25)
                usernameView
                    .padding(.all, 20)
                Spacer()
                HStack{
                    Image(systemName: "person")
                        .foregroundColor(.white)
                    Button("Account Settings"){
                        //Could pull up menu with account settings
                    }
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                }
                if(viewModel.bankLinked){
                    HStack{
                        Image(systemName: "creditcard")
                            .foregroundColor(.white)
                        Button("Unlink bank account"){
                            //Unlinks bank account
                        }
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.vertical)
                    }
                }else{
                    HStack{
                        Image(systemName: "creditcard.fill")
                            .foregroundColor(.white)
                        Button("Link bank account"){
                            //Pulls up menu to link bank account
                        }
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.vertical)
                    }
                }
                Spacer()
            }
        }
    }
    
    private var usernameView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 6)
            
            VStack(spacing: 5) {
                HStack{
                    Text("Currently logged in as:")
                        .foregroundColor(viewModel.themeColor)
                        .fontWeight(.medium)
                        .padding(.all, 30)
                    Spacer()
                }
                
                Spacer()
                
                //Username
                Text("\(viewModel.username)")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(viewModel.themeColor)
                    .padding(.bottom, 25)
                
                Spacer()
                
                Text("Your monthly budget: $\(viewModel.formatAmount(viewModel.budget))")
                    .font(.system(size: 16))
                    .foregroundColor(viewModel.themeColor)
                    .padding(.bottom, 10)
                
            }
        }
        .frame(height: 220)
    }
}
struct Account_Previews: PreviewProvider {
    static var previews: some View {
        AccountPage(viewModel: AppViewModel())
    }
}
