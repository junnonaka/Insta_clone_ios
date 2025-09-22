//
//  SignupView.swift
//  Insta_clone
//
//  Created by 野中淳 on 2025/09/21.
//

import SwiftUI

struct SignupView: View {
    
    @StateObject private var vm: SignupViewModel
    let onSuccess: (AppUser) -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var isSecure: Bool = true
    @State private var navBarHeight: CGFloat = 0
    
    init(vm: SignupViewModel, onSuccess: @escaping (AppUser) -> Void) {
        _vm = StateObject(wrappedValue: vm)
        self.onSuccess = onSuccess
    }
    
    
    var body: some View {
        VStack(spacing:15){
            Spacer()
                .frame(height:150 - self.navBarHeight)
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
                Task {
                    do {
                        let user = try await vm.signUp()
                        onSuccess(user)
                        dismiss()
                    } catch {
                        // エラーはViewModelで処理済み
                    }
                }
            } label: {
                Text("サインアップ")
                    .foregroundStyle(Color.white)
            }
            .frame(maxWidth: .infinity, minHeight:50)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal,15)
            Spacer()
            
        }.background(
            NavigationBarHeightReader(height: $navBarHeight)
                .frame(width:0, height:0)
        )
        
    }
}

#Preview {
        let vm: SignupViewModel = {
            let v = SignupViewModel(authService: MockAuthService())
            v.email = ""
            v.displayName = ""
            return v
        }()
    SignupView(vm: vm) { User in
        print(User.displayName)
    }
}
