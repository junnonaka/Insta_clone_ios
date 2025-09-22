//
//  LoginView.swift
//  Insta_clone
//
//  Created by 野中淳 on 2025/09/21.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var vm:LoginViewModel
    let onSuccess: (AppUser) -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var isSecure: Bool = true
    
    init(vm: LoginViewModel, onSuccess: @escaping (AppUser) -> Void) {
        _vm = StateObject(wrappedValue: vm)
        self.onSuccess = onSuccess
    }
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing:15) {
                Spacer()
                    .frame(height:150)
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 100)
                TextField("メールアドレス", text: $vm.email)
                    .textContentType(UITextContentType.emailAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal,15)
                ZStack{
                    if !isSecure{
                        TextField("パスワード",text: $vm.password)
                            .textContentType(UITextContentType.newPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal,15)
                    }else {
                        SecureField("パスワード",text: $vm.password)
                            .textContentType(UITextContentType.newPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal,15)
                    }
                    HStack{
                        Spacer()
                        Button(action: {
                            isSecure.toggle()
                        }) {
                            Image(systemName: isSecure ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing,30)
                    }
                    
                }
                Button {
                    Task{
                        do{
                            let user = try await vm.signIn()
                            onSuccess(user)
                            dismiss()
                        }catch{
                            vm.errorMessage = error.localizedDescription
                        }
                    }
                
                } label: {
                    Text("ログイン")
                        .foregroundStyle(Color.white)
                }
                .frame(maxWidth: .infinity, minHeight:50)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal,15)
                
                HStack{
                    VStack{
                        Divider()
                    }
                    .padding(.horizontal,15)
                    Text("または")
                        .foregroundStyle(Color.gray)
                        .padding(.horizontal,15)
                    VStack{
                        Divider()
                    }
                    .padding(.horizontal,15)
                }
                
                NavigationLink {
                    SignupView(vm: SignupViewModel(authService: vm.authService)){user in
                        onSuccess(user)
                    }
                } label: {
                    Text("サインアップ")
                        .foregroundStyle(Color.blue)
                }
                .frame(maxWidth: .infinity, minHeight:50)
                .padding(.horizontal,15)
                Spacer()
                
            }
        }
    }
}




#Preview("デフォルト") {
    NavigationStack {
        LoginView(vm: LoginViewModel(authService: MockAuthService())) { user in
            print("Preview login success: \(user.email)")
        }
    }
}

#Preview("ダークモード") {
    NavigationStack {
        LoginView(vm: LoginViewModel(authService: MockAuthService())) { user in
            print("Preview login success: \(user.email)")
        }
    }
    .preferredColorScheme(.dark)
}

#Preview("iPad") {
    NavigationStack {
        LoginView(vm: LoginViewModel(authService: MockAuthService())) { user in
            print("Preview login success: \(user.email)")
        }
    }
    .previewDevice("iPad Air (5th generation)")
}
