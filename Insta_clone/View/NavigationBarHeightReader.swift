//
//  NavigationBarHeightReader.swift
//  Insta_clone
//
//  Created by 野中淳 on 2025/09/21.
//

import Foundation
import SwiftUI

struct NavigationBarHeightReader:UIViewControllerRepresentable{
    
    @Binding var height:CGFloat
    
    
    func makeUIViewController(context: Context) -> HeightReaderViewController {
        let vc = HeightReaderViewController()
        
        vc.onLayout = { [weak vc] in
            DispatchQueue.main.async {
                let navBarHeight:CGFloat = vc?.navigationController?.navigationBar.frame.height ?? 0
                self.height = navBarHeight
            }
            
        }
        return vc
    }
    
    func updateUIViewController(_ uiViewController: HeightReaderViewController, context: Context) {
        
    }
    
    class HeightReaderViewController: UIViewController {
        var onLayout:(()->Void)?
        override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()
            onLayout?()
        }
        
    }
    
}
