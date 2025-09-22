//
//  AuthFlowView.swift
//  Insta_clone
//
//  Created by 野中淳 on 2025/09/22.
//

import SwiftUI

struct AuthFlowView: View {
    @EnvironmentObject var auth: AuthManager
    
    var body: some View {
        NavigationStack {
            LoginView(vm: auth.makeLoginViewModel()) { user in
                // 成功時の共通処理：AuthManager にセット（ルートが Home に切り替わる）
                auth.setLoggedInUser(user)
            }
        }
    }
}

#Preview {
    AuthFlowView()
}
