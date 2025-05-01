import SwiftUI

struct WalletLoginView: View {
    // MARK: - Properties
    @ObservedObject var viewModel: AppViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = false
    @State private var showPassword: Bool = false
    @Binding var showingSheet: Bool
    @State var showingRegister: Bool = false
    
    var body: some View {
        ZStack {
            // Background
            viewModel.themeColor.edgesIgnoringSafeArea(.all)
            
            VStack {
                logoArea
                Spacer()
                loginCard
                    .padding(.horizontal, 20)
                Spacer()
                bottomOptions
            }
            .padding(.vertical, 30)
        }
        .fullScreenCover(isPresented: $showingRegister){
            RegisterView(viewModel: viewModel)
        }
    }
    
    // MARK: - Header
    private var logoArea: some View {
        VStack(spacing: 15) {
            Image(systemName: "creditcard.fill")
                .font(.system(size: 60))
                .foregroundColor(.white)
            
            Text("Budget King")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
                .padding(.bottom)
        }
        .padding(.top, 60)
    }
    
    // MARK: - Login Card
    private var loginCard: some View {
        VStack(spacing: 25) {
            Text("Sign In")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(viewModel.themeColor)
                .padding(.top, 30)
            
            //Email Field
            VStack(alignment: .leading, spacing: 8) {
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
            
            // Password Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Password")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack {
                    Image(systemName: "lock.fill")
                        .foregroundColor(viewModel.themeColor)
                        .font(.system(size: 18))
                    
                    if showPassword {
                        TextField("Enter your password", text: $password)
                            .autocapitalization(.none)
                    } else {
                        SecureField("Enter your password", text: $password)
                            .autocapitalization(.none)
                    }
                    
                    Button(action: {
                        showPassword.toggle()
                    }) {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
            }
            
            // Remember me and Forgot Password
            HStack {
                HStack {
                    Button(action: {
                        rememberMe.toggle()
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: rememberMe ? "checkmark.square.fill" : "square")
                                .foregroundColor(viewModel.themeColor)
                            
                            Text("Remember me")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Spacer()
                
//                Button(action: {
//                    // Handle forgot password
//                }) {
//                    Text("Forgot Password?")
//                        .font(.footnote)
//                        .foregroundColor(viewModel.themeColor)
//                }
            }
            
            //Sign In Button
            Button(action: {
                Task{
                    do{
                        try await AccessManager.shared.logIn(email: email,
                            password: password)
                    }catch{
                        print(error)
                    }
                }
            }) {
                Text("Sign In")
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
    
    // MARK: - Sign up option
    private var bottomOptions: some View {
        HStack(spacing: 5) {
            Text("Don't have an account?")
                .font(.footnote)
                .foregroundColor(.white)
            
            Button(action: {
                showingRegister = true
            }) {
                Text("Sign Up")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
        .padding(.bottom, 20)
    }
}

struct WalletLoginView_Previews: PreviewProvider {
    static var previews: some View {
        WalletLoginView(viewModel: AppViewModel(), showingSheet: .constant(false))
    }
}
