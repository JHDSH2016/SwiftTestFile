//
//  SqliteManager.swift
//  AddressBook
//
//  Created by 杜顺 on 16/7/15.
//  Copyright © 2016年 杜顺. All rights reserved.
//

import UIKit



let datapath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first?.stringByAppendingString("/Database.sqlite");
var database:COpaquePointer = nil;



class SqliteManager: NSObject {


    //打开数据库
    static func openDatabase() -> Bool {
        let isOpen = sqlite3_open(datapath!, &database);
        if isOpen != SQLITE_OK {
            print("打开数据库失败");
            return false;
        }
        return true;
    }
    //创建数据表
    static func createTable() -> Bool {
        if openDatabase() {
            let sql = "create table if not exists PEOPLE (id integer primary key autoincrement , name text , num integer)";
            let result = sqlite3_exec(database, sql, nil, nil, nil);
            if result != SQLITE_OK {
                print("打开数据库失败");
                sqlite3_close(database);
                return false;
            }

            sqlite3_close(database);

            return true;
        }
        return false;
    }
    //插入数据
    static func insertDataIntoDatabase(pp:People) -> Bool {
        if openDatabase() {
            let sql = "insert into PEOPLE (name , num) values ('\(pp.name)' , \(pp.num))";
            let result = sqlite3_exec(database, sql, nil, nil, nil);
            if result != SQLITE_OK {
                print("插入数据库失败");
                sqlite3_close(database);
                return false;
            }

            let sql2 = "select * from PEOPLE where id = (select Max(id) from PEOPLE)";
            var stmt:COpaquePointer = nil;
            sqlite3_prepare_v2(database, sql2, -1, &stmt, nil);
            sqlite3_step(stmt);
            let ID = sqlite3_column_int(stmt, 0);
            pp.ID = ID;
            sqlite3_finalize(stmt);
            sqlite3_close(database);

            print(pp);

            return true;
        }
        return true;
    }
    //刷新数据
    static func updateDatabase(pp:People) -> Bool {
        if openDatabase() {
            let sql = "update PEOPLE set name = '\(pp.name)' , num = \(pp.num) where id = \(pp.ID)";
            let result = sqlite3_exec(database, sql, nil, nil, nil);
            sqlite3_close(database);
            if result != SQLITE_OK {
                print("刷新数据库失败");
                return false;
            }
            return true;
        }
        return false;
    }
    //删除数据
    static func deleteDataFromDatabase(pp:People) -> Bool {
        if openDatabase() {
            let sql = "delete from PEOPLE where id = '\(pp.ID)'";
            let result = sqlite3_exec(database, sql, nil, nil, nil);
            sqlite3_close(database);
            if result != SQLITE_OK {
                print("插入数据库失败");
                return false;
            }
            return true;
        }
        return false;
    }

    //获取数据
    static func selectDataFromDatabase() -> [People] {

        var array = [People]();

        if openDatabase() {
            let sql2 = "select * from PEOPLE";
            var stmt:COpaquePointer = nil;
            let result = sqlite3_prepare_v2(database, sql2, -1, &stmt, nil);
            if result != SQLITE_OK {
                sqlite3_close(database);
                return array;
            }

            while sqlite3_step(stmt) == SQLITE_ROW {

                let ID = sqlite3_column_int(stmt, 0);
                let name = sqlite3_column_text(stmt, 1);
                let num = sqlite3_column_int(stmt, 2);

                let pp = People();
                pp.name = String.init(UTF8String: UnsafePointer<CChar>(name));
                pp.ID = ID;
                pp.num = num;

                array.append(pp);
            }

            sqlite3_finalize(stmt);
            sqlite3_close(database);
            return array;
        }
        


        return array;
    }
}





//创建People类，用来接收数据
class People: NSObject {

    var ID:Int32!;
    var name:String!;
    var num:Int32!;

}