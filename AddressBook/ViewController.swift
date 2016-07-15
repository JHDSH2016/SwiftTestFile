//
//  ViewController.swift
//  AddressBook
//
//  Created by 杜顺 on 16/7/15.
//  Copyright © 2016年 杜顺. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate {

    var array:[People]!;


    @IBOutlet weak var _tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false;

        //获取数据
        array = SqliteManager.selectDataFromDatabase();

        print(NSHomeDirectory());

    }


//设置行数：好友的个数。
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count;
    }
//设置cell：显示好友信息。
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("cell");
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell");
        }


        let pp = array[indexPath.row];
        cell.textLabel?.text = pp.name;
        cell.detailTextLabel?.text = "\(pp.num)";

        return cell;
    }
//选中cell：可以选择是否需要更改数据。
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let pp = array[indexPath.row];


        let alertController = UIAlertController.init(title: "添加好友", message: "是否确认添加", preferredStyle: UIAlertControllerStyle.Alert);
        alertController.addTextFieldWithConfigurationHandler { (tf:UITextField) in
            tf.textAlignment = NSTextAlignment.Center;
            tf.placeholder = "请输入姓名";
            tf.text = pp.name;
        }
        alertController.addTextFieldWithConfigurationHandler { (tf:UITextField) in
            tf.textAlignment = NSTextAlignment.Center;
            tf.secureTextEntry = false;
            tf.placeholder = "请输入号码";
            tf.keyboardType = UIKeyboardType.NumberPad;
            tf.text = "\(pp.num)"
        }
        let cancelAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil);
        let sureAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.Default) { (UIAlertAction) in

            print("确定添加好友");

            let pp = People();
            pp.name = alertController.textFields![0].text;
            pp.num = Int32(alertController.textFields![0].text!);
            print(pp);

            SqliteManager.updateDatabase(pp);

            self._tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade);

        }
        alertController.addAction(cancelAction);
        alertController.addAction(sureAction);
        self.presentViewController(alertController, animated: true, completion: nil);
    }


    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

        let pp = array[indexPath.row];
        array.removeAtIndex(indexPath.row);
        SqliteManager.deleteDataFromDatabase(pp);
        _tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Right);
    }





//点击添加调用的方法：添加联系人。
    @IBAction func addData(sender: AnyObject) {

        let alertController = UIAlertController.init(title: "添加好友", message: "是否确认添加", preferredStyle: UIAlertControllerStyle.Alert);
        alertController.addTextFieldWithConfigurationHandler { (tf:UITextField) in
            tf.textAlignment = NSTextAlignment.Center;
            tf.placeholder = "请输入姓名";
        }
        alertController.addTextFieldWithConfigurationHandler { (tf:UITextField) in
            tf.textAlignment = NSTextAlignment.Center;
            tf.secureTextEntry = false;
            tf.placeholder = "请输入号码";
            tf.keyboardType = UIKeyboardType.NumberPad;
        }
        let cancelAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil);
        let sureAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.Default) { (UIAlertAction) in

            print("确定添加好友");

            let pp = People();
            pp.name = alertController.textFields![0].text;
            pp.num = Int32(alertController.textFields![0].text!);
            print(pp);

            SqliteManager.insertDataIntoDatabase(pp);
            self.array.append(pp);

            self._tableView.insertRowsAtIndexPaths([NSIndexPath.init(forRow: self.array.count-1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Left);
            print("\(pp.name)---\(pp.num)----\(pp.ID)");

        }
        alertController.addAction(cancelAction);
        alertController.addAction(sureAction);
        self.presentViewController(alertController, animated: true, completion: nil);

    }



}


























