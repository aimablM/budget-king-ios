//
//  Register.swift
//  Group4Project
//
//  Created by Riley Forney on 4/30/25.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var viewModel: AppViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var passwordConfirm = ""
    @State private var showPassword = false
    
    var body: some View {
        ZStack{
            viewModel.themeColor.edgesIgnoringSafeArea(.all)
            
            VStack{
                Spacer()
                logo
                Spacer()
                registerCard.padding(.horizontal, 20)
                Spacer()
                signIn
                Spacer()
            }
            .padding(.vertical, 30)
        }
    }
    
    private var logo: some View {
        VStack(spacing: 15) {
            Image(systemName: "creditcard.fill")
                .font(.system(size: 60))
                .foregroundColor(.white)
            
            Text("Budget King")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
                .padding(.bottom)
        }
        .padding(.top, 20)
    }
    
    private var registerCard: some View {
        VStack(spacing: 25) {
            Text("Register")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(viewModel.themeColor)
                .padding(.top, 20)
            
            //Email Field
            VStack(alignment: .leading, spacing: 5) {
                Text("Email")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(viewModel.themeColor)
                        .font(.system(size: 18))
                    
                    TextField("Enter your email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
            }
            
            //Username field
            VStack(alignment: .leading, spacing: 5) {
                Text("Username")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(viewModel.themeColor)
                        .font(.system(size: 18))
                    
                    TextField("Enter your username", text: $username)
                        .autocapitalization(.none)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
            }
            
            //Password Field
            VStack(alignment: .leading, spacing: 5) {
                Text("Password")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(viewModel.themeColor)
                        .font(.system(size: 18))
                    
                    SecureField("Enter your password", text: $password)
                        .autocapitalization(.none)
                    
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
            }
            
            //Confirm password
            VStack(alignment: .leading, spacing: 5) {
                Text("Confirm Password")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack {
                    Image(systemName: "lock.fill")
                        .foregroundColor(viewModel.themeColor)
                        .font(.system(size: 18))
                    
                    SecureField("Confirm your password", text: $passwordConfirm)
                        .autocapitalization(.none)
                    
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
            }
            
            //Register Button
            Button(action: {
                Task{
                    do{
                        try await AccessManager.shared.register(email: email,
                            password: password)
                    }catch{
                        print(error)
                    }
                }
            }) {
                Text("Register")
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
            .disabled(email.count < 1 || password.count < 1 || username.count < 1 || password != passwordConfirm)
            .padding(.top, 10)
            .padding(.bottom, 30)
        }
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 10)
        )
    }
    
    private var signIn: some View {
        HStack(spacing: 5) {
            Text("Already have an account?")
                .font(.footnote)
                .foregroundColor(.white)
            
            Button(action: {
                dismiss()
            }) {
                Text("Sign In")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
        .padding(.bottom, 20)
    }
}

struct Register_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(viewModel: AppViewModel())
    }
}

