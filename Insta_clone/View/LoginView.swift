//
//  LoginView.swift
//  Insta_clone
//
//  Created by 野中淳 on 2025/09/21.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSecure: Bool = true
    
    var body: some View {
        NavigationStack {
            VStack(spacing:15) {
                Spacer()
                    .frame(height:150)
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 100)
                TextField("メールアドレス", text: $email)
                    .textContentType(UITextContentType.emailAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal,15)
                ZStack{
                    if !isSecure{
                        TextField("パスワード",text: $password)
                            .textContentType(UITextContentType.newPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal,15)
                    }else {
                        SecureField("パスワード",text: $password)
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
                    SignupView()
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




#Preview {
    LoginView()
}
