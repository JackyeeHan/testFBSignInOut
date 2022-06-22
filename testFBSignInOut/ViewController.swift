//
//  ViewController.swift
//  testFBSignInOut
//
//  Created by 黃柏瀚 on 2022/6/20.
//

import UIKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController, LoginButtonDelegate {

    @IBOutlet weak var status: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        //創建 FB 登入按鈕
        let loginButton = FBLoginButton()
        loginButton.center = view.center
        view.addSubview(loginButton)
    
        //檢查目前的登入登出狀態
        if let token = AccessToken.current, !token.isExpired {
                print("目前登入")
        }else{
            print("目前登出")
        }
        
        //登入後可以讀取使用者其他資料??
        loginButton.permissions = ["public_profile", "email"]
        
        loginButton.delegate = self
        
    }

    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {

        let credential = FacebookAuthProvider
            .credential(withAccessToken: AccessToken.current!.tokenString)

        Auth.auth().signIn(with: credential) { authResult, error in
            print("try signIn Firebase")
            
            Auth.auth().addStateDidChangeListener { auth, user in
                  if let user = user{
                    let name = user.displayName ?? ""
                    print("登入狀態\(name)")
                    self.status.text = "歡迎:\(name)"
                  }else{
                    self.status.text = "登出狀態"
        }
    }
        }
    }
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        do {
            try Auth.auth().signOut()
            } catch {
            print("Sign Out error:\(error.localizedDescription)")
            }
            self.status.text = "請登入"
    }
}
