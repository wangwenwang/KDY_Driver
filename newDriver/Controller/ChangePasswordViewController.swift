//
//  ChangePasswordViewController.swift
//  newDriver
//
//  Created by 凯东源 on 16/6/28.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController, HttpResponseProtocol, UITextFieldDelegate {
    
    
    /// 更改密码的业务类
    let biz = ChangePasswordBiz()
    
    /// 用于记录用户当前编辑的文本框
    fileprivate var editTextField: UITextField?
    
    /// 原密码
    @IBOutlet weak var oldPasswordField: UITextField! {
        didSet {
            oldPasswordField.delegate = self
        }
    }
    
    /// 新密码
    @IBOutlet weak var newPasswordField: UITextField! {
        didSet {
            newPasswordField.delegate = self
        }
    }
    
    /// 重复确认新密码
    @IBOutlet weak var repeatPasswordField: UITextField! {
        didSet {
            repeatPasswordField.delegate = self
        }
    }
    
    /// 提交按钮
    @IBOutlet weak var changePasswordButtonField: UIButton!
    
    /// 网络请求时显示的进度条
    @IBOutlet weak var progress: UIActivityIndicatorView!
    
    /// 网络请求时显示的文本框
    @IBOutlet weak var progressfiels: UILabel!
    
    @IBOutlet weak var oldPassTop: NSLayoutConstraint!
    
    // 状态栏高度
    let kStatusHeight = UIApplication.shared.statusBarFrame.size.height
    
    // 导航栏高度
    func kNavHeight() -> CGFloat {
        
        return self.navigationController!.navigationBar.frame.size.height
    }
    
    /// 提交修改密码
    @IBAction func changePassword(_ sender: UIButton) {
        
        let oldpwd: String = oldPasswordField.text!
        let newpwd: String = newPasswordField.text!
        let repwd: String = repeatPasswordField.text!
        
        if(oldpwd != "") {
            if(newpwd != "") {
                if(repwd != "") {
                    if(newpwd == repwd) {
                        if(newpwd.count >= 6) {
                            if(oldpwd == UserDefaults.standard.string(forKey: BusinessConstants.passWord)) {
                                if(oldpwd != repwd) {
                                    
                                    //判断连接状态
                                    let reachability = Reachability.forInternetConnection()
                                    if reachability!.isReachable() {
                                        changePasswordButtonField.isEnabled = false
                                        editTextField?.resignFirstResponder()
                                        showProgress()
                                        biz.changePassword(oldPassword: oldpwd, newPassword: newpwd, httpresponseProtocol: self)
                                    } else {
                                        Tools.showAlertDialog("网络连接不可用!", self)
                                    }
                                } else {
                                    Tools.showAlertDialog("新密码与旧密码相同!", self)
                                }
                            } else {
                                Tools.showAlertDialog("旧密码不正确!", self)
                            }
                        } else {
                            Tools.showAlertDialog("新密码不能小于六位数字或字母！", self)
                        }
                    } else {
                        Tools.showAlertDialog("两次输入新密码不同！", self)
                    }
                } else {
                    Tools.showAlertDialog("请确认新密码！", self)
                }
            } else {
                Tools.showAlertDialog("请输入新密码！", self)
            }
        } else {
            Tools.showAlertDialog("请输入原密码！", self)
        }
    }
    
    /// 用户点击编辑框外的空间隐藏键盘
    @IBAction func click(_ sender: UITapGestureRecognizer) {
        if let textField = editTextField {
            textField.resignFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改密码"
        oldPassTop.constant += (kStatusHeight + kNavHeight())
        dismissProgress()
    }
    
    // 修改登陆密码成功回调
    func responseSuccess() {
        changePasswordButtonField.isEnabled = true
        dismissProgress()
        
        let hud: MBProgressHUD = MBProgressHUD.showHUDAddedTo(UIApplication.shared.keyWindow!, animated: true)
        hud.mode = .text
        hud.labelText = "修改密码成功！"
        hud.margin = 10.0
        hud.removeFromSuperViewOnHide = true
        hud.hide(true, afterDelay: 3)
        
        // 清空密码，返回登录界面
        UserDefaults.standard.set("", forKey: BusinessConstants.passWord)
        UserDefaults.standard.synchronize()
        DispatchQueue.global().async {
            sleep(1)
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    /**
     * 修改登陆密码失败回调方法
     *
     * message: 显示的信息
     */
    func responseError(_ error: String) {
        Tools.showAlertDialog(error, self)
        changePasswordButtonField.isEnabled = true
        dismissProgress()
    }
    
    /**
     * 记录用户正在编辑的文本框
     *
     * textField: 获取焦点的文本编辑框
     */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        editTextField = textField
    }
    
    /**
     * 显示或者隐藏键盘
     *
     * textField: 获取焦点的文本编辑框
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // 显示修改密码网络请求时显示的进度
    fileprivate func showProgress () {
        progress.startAnimating()
        progressfiels.text = "修改密码中。。。"
    }
    
    // 隐藏修改密码网络请求时显示的进度
    fileprivate func dismissProgress () {
        progress.stopAnimating()
        progressfiels.text = ""
    }
}
