//
//  ManualAdd.swift
//  Group4Project
//
//  Created by Riley Forney on 4/23/25.
//

import SwiftUI

struct ManualAdd: View {
    @ObservedObject var viewModel: AppViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var amount: String = ""
    @State private var date: Date = Date.now
    @State private var isIncome: Bool = false
    var amountIsDouble: Bool {
        Double(amount) != nil
    }
    
    var body: some View {
        VStack{
            ZStack{
                viewModel.themeColor.edgesIgnoringSafeArea(.all)
                
                VStack{
                    HStack{
                        Text("Manual Transaction").font(.system(size:24, weight: .bold)).foregroundColor(.white).padding(.horizontal, 10)
                        Spacer()
                        Button("Cancel"){
                            dismiss()
                        }.padding(.horizontal, 10)
                    }
                    Fields.padding(.horizontal, 5)
                }
            }
        }
    }
    
    private var Fields: some View {
        VStack(spacing: 25) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Provider")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack {
                    TextField("Transaction provider", text: $name)
                        .autocapitalization(.words)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
            }.padding(.top, 10)
            VStack(alignment: .leading, spacing: 8) {
                Text("Amount")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack {
                    TextField("Transaction amount", text: $amount)
                        .keyboardType(.numberPad)
                        .autocapitalization(.words)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
            }
            VStack(alignment: .leading, spacing: 8) {
                Text("Date")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack {
                    DatePicker("Transaction Date", selection: $date, displayedComponents: .date)
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 5)
                .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
            }
            Button(action: {
                isIncome.toggle()
            }) {
                HStack(spacing: 5) {
                    Image(systemName: isIncome ? "checkmark.square.fill" : "square")
                        .foregroundColor(viewModel.themeColor)
                    Text("Income?")
                        .foregroundColor(.gray)
                    Spacer()
                }
            }.padding(.bottom, 10)
            SubmitButton
        }
        .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 10))
    }
    
    private var SubmitButton: some View {
        Button(action: {
            if let num = Double(amount){
                viewModel.addManualTransaction(provider: name, amount: num, date: date, isIncome: isIncome)
            }else{
                print("Error adding manual transaction")
            }
            dismiss()
        }) {
            Text("Add Transaction")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(viewModel.themeColor)
                )
                .shadow(color: viewModel.themeColor.opacity(0.4), radius: 5, x: 0, y: 5)
        }
        .disabled(name.count < 3 || date > Date.now || !amountIsDouble)
        .padding(.bottom, 30)
    }
}

struct ManualAdd_Previews: PreviewProvider {
    static var previews: some View {
        ManualAdd(viewModel: AppViewModel())
    }
}
