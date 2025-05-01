//
//  ContentView.swift
//  Group4Project
//
//  Created by Riley Forney on 4/5/25.
//

import SwiftUI

//Main view
struct ContentView: View {
    @State private var tab = 1
    @State private var showingLogin = true
    @ObservedObject var viewModel = AppViewModel()
    
    init() {
        AccessManager.shared.setup(viewModel: viewModel)  // Pass the viewModel reference
        }
    
    var body: some View {
        if(viewModel.loggedIn){
            VStack(spacing: 0) {
                ZStack {
                    Color(red: 0.2, green: 0.69, blue: 0.89)
                        .brightness(-0.3)
                        .ignoresSafeArea(edges: .top)
                    HStack{
                        Text("Budget King")
                            .font(.system(size: 36)).bold()
                            .foregroundColor(.white)
                            .padding()
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                TabView(selection: $tab){
                    StatsPage(viewModel: viewModel).tag(0)
                    WalletHomeView(viewModel: viewModel).tag(1)
                    AccountPage(viewModel: viewModel).tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                HStack{
                    Spacer()
                    Button(action: {
                        tab = 0
                    }){
                        Image(systemName: tab == 0 ? "chart.bar.fill" : "chart.bar")
                            .foregroundColor(.white)
                            .font(.system(size:24))
                    }
                    Spacer()
                    Button(action: {
                        tab = 1
                    }){
                        Image(systemName: tab == 1 ? "house.fill" : "house")
                            .foregroundColor(.white)
                            .font(.system(size:24)).padding()
                    }
                    Spacer()
                    Button(action: {
                        tab = 2
                    }){
                        Image(systemName: tab == 2 ? "person.circle.fill" : "person.circle")
                            .foregroundColor(.white)
                            .font(.system(size:24))
                    }
                    Spacer()
                }.background(Color(red: 0.2, green: 0.69, blue: 0.89)
                    .brightness(-0.3)
                    .ignoresSafeArea(edges: .bottom))
            }
        }else{
            WalletLoginView(viewModel: viewModel, showingSheet: $showingLogin)
        }
        
    }
}

#Preview {
    ContentView()
}
