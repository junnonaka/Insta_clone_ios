//
//  ContentView.swift
//  Insta_clone
//
//  Created by 野中淳 on 2025/09/21.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var auth: AuthManager
    @State private var selectedTab: Int = 0
    
    var body: some View {
        if let _ = auth.currentUser {
            // ログイン済み：メインアプリ
            createMainTabView()
        } else {
            // 未ログイン：認証画面
            NavigationStack {
                LoginView(vm: LoginViewModel(authService: auth.authService)) { user in
                    auth.setLoggedInUser(user)
                }
            }
        }
    }
    
    @ViewBuilder
    private func createMainTabView() -> some View {
        TabView(selection: $selectedTab) {
            HomeTabView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(0)
            
            ProfileTabView()
                .tabItem {
                    Image(systemName: "person.2")
                    Text("Profile")
                }
                .tag(1)
        }
    }
}

// 個別のタブビューを定義
struct HomeTabView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.blue.ignoresSafeArea()
                VStack {
                    Text("Home")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
            .navigationTitle("Home")
            .navigationBarHidden(true)
        }
    }
}

struct ProfileTabView: View {
    @EnvironmentObject var auth: AuthManager
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.green.ignoresSafeArea()
                VStack(spacing: 20) {
                    Text("Profile")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    if let user = auth.currentUser {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email: \(user.email)")
                                .foregroundColor(.white)
                            if let displayName = user.displayName {
                                Text("Name: \(displayName)")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(10)
                    }
                    
                    Button("ログアウト") {
                        auth.signOut()
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .navigationTitle("Profile")
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    let auth = AuthManager(authService: MockAuthService()) // AuthManager が非isolatedならOK
    auth.currentUser = nil // or set to a User
    return ContentView().environmentObject(auth)
}
