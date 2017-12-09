//
//  DriverListPayViewController.swift
//  newDriver
//
//  Created by 凯东源 on 2017/8/10.
//  Copyright © 2017年 凯东源. All rights reserved.
//

import UIKit

class DriverListPayViewController: UIViewController, HttpResponseProtocol, UITableViewDataSource, UITableViewDelegate {
    
    // 未交付订单列表
    @IBOutlet weak var tableView: UITableView!
    
    // 查询装运下的未交付订单
    var biz: GetShipmentUnPayOrderListBiz = GetShipmentUnPayOrderListBiz()
    
    var TMS_SHIPMENT_NO : String = ""
    
    // 订单简介Cell
    let cellIdentifier = "DriverListPayTableViewCell"
    
    let kCellHeight: CGFloat = 95
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "批量交付"
        
        self.tableView.register(UINib.init(nibName: "DriverListPayTableViewCell", bundle: nil), forCellReuseIdentifier: "DriverListPayTableViewCell")
        
        _ = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        biz.GetShipmentUnPayOrderList(andTMS_SHIPMENT_NO: self.TMS_SHIPMENT_NO, andstrIsPay: "N", httpresponseProtocol: self)
    }
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - 功能函数
    // 获取订单id
    func getIdxs() -> String {
        
        var idxs: String = ""
        for or: Order in biz.orders {
            if(or.cellSelected) {
                if(idxs == "") {
                    idxs = or.ORD_IDX
                } else {
                    idxs = idxs + "," + or.ORD_IDX
                }
            }
        }
        return idxs
    }
    
    
    // 获取订单编号
    func getOrdNos() -> NSArray {
        
        var ordNos = [String]()
        for or: Order in biz.orders {
            if(or.cellSelected) {
                ordNos.append(or.ORD_NO)
            }
        }
        return ordNos as NSArray
    }
    
    
    // MARK: - 事件
    @IBAction func allChooseOnclick() {
        
        // 全选
        for or: Order in biz.orders {
            
            or.cellSelected = true
        }
        tableView.reloadData();
    }
    
    
    @IBAction func commitOnclick() {
        
        let idxs = getIdxs()
        if(idxs != "") {
            
            // 交付订单
            let payOrderController = PayOrderViewController(nibName:"PayOrderViewController", bundle: nil)
            payOrderController.orderIDX = idxs
            payOrderController.orderNOs = getOrdNos()
            self.navigationController?.pushViewController(payOrderController, animated: true)
        } else {
            
            Tools.showAlertDialog("请选择需要交付的订单", self)
        }
    }
    
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return biz.orders.count
    }
    
    
    // 设置 cell 高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let or: Order = biz.orders[(indexPath as NSIndexPath).row]
        
        return or.cellHeight
    }
    
    
    // 设置自定义的 cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DriverListPayTableViewCell
        cell.order = biz.orders[(indexPath as NSIndexPath).row]
        return cell
    }
    
    
    // Cell点击
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let order = biz.orders[indexPath.row]
        order.cellSelected = !order.cellSelected
        
        tableView.reloadData()
    }
    
    
    // MARK: - HttpResponseProtocol
    func responseSuccess() {
        
        _ = MBProgressHUD.hideHUDForView(self.view, animated: true)
        
        for order:Order in biz.orders {
            
            let oneLine = Tools.getHeightOfString(text: "fds", fontSize: 14, width: CGFloat(MAXFLOAT))
            var mulLine = Tools.getHeightOfString(text: order.ORD_TO_NAME, fontSize: 14, width: (SCREEN_WIDTH - 8 - 65 - 3))
            order.cellHeight = kCellHeight + (mulLine - oneLine)
           
            mulLine = Tools.getHeightOfString(text: order.ORD_TO_ADDRESS, fontSize: 14, width: (SCREEN_WIDTH - 8 - 65 - 3))
            order.cellHeight += (mulLine - oneLine)
        }
        tableView.reloadData()
    }
    
    
    /**
     * 获取订单详情信息失败回调方法
     *
     * message: 显示的信息
     */
    func responseError(_ error: String) {
        
        _ = MBProgressHUD.hideHUDForView(self.view, animated: true)
        Tools.showAlertDialog(error, self)
    }
}
