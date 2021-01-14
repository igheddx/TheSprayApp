//
//  DBHelper.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 8/9/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import Foundation
import SQLite3

class DBHelper
{
    init()
    {
        db = openDatabase()
        //dropBook()
        //dropStudent()
        //createBookTable()
        //createStudentTable()
        
//        dropSenderSprayBalanceTable()
//        dropSprayTransactionTable()
        
        createSprayTransactionTable()
        createSenderSprayBalanceTable()
    }

    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?
    
    func dropSenderSprayBalanceTable() {
        let createTableString = "DROP TABLE senderSprayBalance;"
               var createTableStatement: OpaquePointer? = nil
               if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
               {
                   if sqlite3_step(createTableStatement) == SQLITE_DONE
                   {
                       print("SenderSprayBalanceTable table is dropped .")
                   } else {
                       print("SenderSprayBalanceTable table could not be dropped.")
                   }
               } else {
                   print("DROP TABLE statement could not be prepared.")
               }
               sqlite3_finalize(createTableStatement)
    }
    func dropSprayTransactionTable() {
         let createTableString = "DROP TABLE sprayTransaction;"
                var createTableStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
                {
                    if sqlite3_step(createTableStatement) == SQLITE_DONE
                    {
                        print("sprayTransaction.")
                    } else {
                        print("sprayTransaction table could not be created.")
                    }
                } else {
                    print("DROP TABLE statement could not be prepared.")
                }
                sqlite3_finalize(createTableStatement)
     }
    
    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }

    
    
    func createSprayTransactionTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS sprayTransaction(id INTEGER PRIMARY KEY AUTOINCREMENT,eventId INTEGER,senderId INTEGER, receiverId INTEGER, senderAmountRemaining INTEGER, receiverAmountReceived INTEGER, transactionDateTime TEXT, paymentType INTEGER);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("spraytransaction table created.")
            } else {
                print("spraytransaction table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func createSenderSprayBalanceTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS senderSprayBalance(id INTEGER PRIMARY KEY AUTOINCREMENT,eventId INTEGER,senderId INTEGER, senderAmountRemaining INTEGER, isAutoReplenish INTEGER, transactionDateTime TEXT, paymentType INTEGER);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("balance table created.")
            } else {
                print("balance table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insertSprayTransactionTable(eventId: Int, senderId: Int, receiverId: Int, senderAmountRemaining: Int, receiverAmountReceived: Int, transactionDateTime: String, paymentType: Int)
      {
          let spraytransaction = readSprayTransaction()
          for s in spraytransaction
          {
            let uniqueId = eventId + senderId + receiverId
            let uniqueIdFromDb = s.eventId + s.senderId + s.receiverId
            
            if uniqueId == uniqueIdFromDb
              {
                  return
              }
          }
          let insertStatementString = "INSERT INTO sprayTransaction (eventId, senderId, receiverId, senderAmountRemaining, receiverAmountReceived, transactionDateTime, paymentType) VALUES (?, ?, ?, ?, ?, ?, ?);"
          var insertStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
              //sqlite3_bind_int(insertStatement, 1, Int32(id))
                sqlite3_bind_int(insertStatement, 1, Int32(eventId))
                sqlite3_bind_int(insertStatement, 2, Int32(senderId))
                sqlite3_bind_int(insertStatement, 3, Int32(receiverId))
                sqlite3_bind_int(insertStatement, 4, Int32(senderAmountRemaining))
                sqlite3_bind_int(insertStatement, 5, Int32(receiverAmountReceived))
                sqlite3_bind_text(insertStatement, 6, (transactionDateTime as NSString).utf8String, -1, nil)
                sqlite3_bind_int(insertStatement, 7, Int32(paymentType))
                

              if sqlite3_step(insertStatement) == SQLITE_DONE {
                  print("Successfully inserted row.")
              } else {
                  print("Could not insert row.")
              }
          } else {
              print("INSERT statement could not be prepared.")
          }
          sqlite3_finalize(insertStatement)
      }
    
    
    func insertSenderSprayBalanceTable(eventId: Int, senderId: Int, senderAmountRemaining: Int, isAutoReplenish: Int, transactionDateTime: String, paymentType: Int)
        {
            let spraybalance = readSenderSprayBalance()
            for s in spraybalance
            {
              let uniqueId = eventId + senderId
              let uniqueIdFromDb = s.eventId + s.senderId
              
              if uniqueId == uniqueIdFromDb
                {
                    return
                }
            }
            let insertStatementString = "INSERT INTO senderSprayBalance (eventId, senderId, senderAmountRemaining, isAutoReplenish, transactionDateTime, paymentType) VALUES (?, ?, ?, ?, ?, ?);"
            var insertStatement: OpaquePointer? = nil
              if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                //sqlite3_bind_int(insertStatement, 1, Int32(id))
                  sqlite3_bind_int(insertStatement, 1, Int32(eventId))
                  sqlite3_bind_int(insertStatement, 2, Int32(senderId))
                  sqlite3_bind_int(insertStatement, 3, Int32(senderAmountRemaining))
                sqlite3_bind_int(insertStatement, 4, Int32(isAutoReplenish))
                  sqlite3_bind_text(insertStatement, 5, (transactionDateTime as NSString).utf8String, -1, nil)
                  sqlite3_bind_int(insertStatement, 6, Int32(paymentType))
                  

                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    print("Successfully inserted row.")
                } else {
                    print("Could not insert row.")
                }
            } else {
                print("INSERT statement could not be prepared.")
            }
            sqlite3_finalize(insertStatement)
        }
      
    
    
    func readSprayTransaction() -> [SprayTransaction] {
          let queryStatementString = "SELECT * FROM sprayTransaction;"
          var queryStatement: OpaquePointer? = nil
          var psns : [SprayTransaction] = []
          if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    let id = sqlite3_column_int(queryStatement, 0)
                    let eventId = sqlite3_column_int(queryStatement, 1)
                    let senderId = sqlite3_column_int(queryStatement, 2)
                    let receiverId = sqlite3_column_int(queryStatement, 3)
                    let senderAmountRemaining = sqlite3_column_int(queryStatement, 4)
                    let receiverAmountReceived = sqlite3_column_int(queryStatement, 5)
                    let transactionDateTime = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
                    let paymentType = sqlite3_column_int(queryStatement, 7)
                    
   
                  
                    psns.append(SprayTransaction(id: Int(id), eventId: Int64(eventId), senderId: Int64(senderId), receiverId: Int64(receiverId), senderAmountRemaining: Int(senderAmountRemaining), receiverAmountReceived: Int(receiverAmountReceived), transactionDateTime: transactionDateTime, paymentType: Int(paymentType)))
                    
              }
          } else {
              print("SELECT statement could not be prepared")
          }
          sqlite3_finalize(queryStatement)
          return psns
      }
    
    
    func readSenderSprayBalance() -> [SenderSprayBalance] {
            let queryStatementString = "SELECT * FROM senderSprayBalance;"
            var queryStatement: OpaquePointer? = nil
            var psns : [SenderSprayBalance] = []
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                  while sqlite3_step(queryStatement) == SQLITE_ROW {
                      let id = sqlite3_column_int(queryStatement, 0)
                      let eventId = sqlite3_column_int(queryStatement, 1)
                      let senderId = sqlite3_column_int(queryStatement, 2)
                      let senderAmountRemaining = sqlite3_column_int(queryStatement, 3)
                    let isAutoReplenish = sqlite3_column_int(queryStatement, 4)
                      let transactionDateTime = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                      let paymentType = sqlite3_column_int(queryStatement, 6)
                      
     
                    
                    psns.append(SenderSprayBalance(id: Int(id), eventId: Int64(eventId), senderId: Int64(senderId), senderAmountRemaining: Int(senderAmountRemaining), isAutoReplenish: Int(isAutoReplenish),  transactionDateTime: transactionDateTime, paymentType: Int(paymentType)))
                      
                }
            } else {
                print("SELECT statement could not be prepared")
            }
            sqlite3_finalize(queryStatement)
            return psns
        }
    
    func readSenderSprayBalanceById(eventId: Int64, senderId: Int64) -> [SenderSprayBalance] {
               let queryStatementString = "SELECT * FROM senderSprayBalance WHERE eventId =? AND senderId = ?;"
               var queryStatement: OpaquePointer? = nil
               var psns : [SenderSprayBalance] = []
               if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                    sqlite3_bind_int(queryStatement, 1, Int32(eventId))
                    sqlite3_bind_int(queryStatement, 2, Int32(senderId))
                
                
                     while sqlite3_step(queryStatement) == SQLITE_ROW {
                         let id = sqlite3_column_int(queryStatement, 0)
                         let eventId = sqlite3_column_int(queryStatement, 1)
                         let senderId = sqlite3_column_int(queryStatement, 2)
                         let senderAmountRemaining = sqlite3_column_int(queryStatement, 3)
                         let isAutoReplenish = sqlite3_column_int(queryStatement, 4)
                         let transactionDateTime = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                         let paymentType = sqlite3_column_int(queryStatement, 6)
                         
        
                       
                        psns.append(SenderSprayBalance(id: Int(id), eventId: Int64(eventId), senderId: Int64(senderId), senderAmountRemaining: Int(senderAmountRemaining), isAutoReplenish: Int(isAutoReplenish), transactionDateTime: transactionDateTime, paymentType: Int(paymentType)))
                         
                   }
               } else {
                   print("SELECT statement could not be prepared")
               }
               sqlite3_finalize(queryStatement)
               return psns
           }
       
    func updateSprayBalanceById(eventId: Int64, senderId: Int64, senderAmountRemaining: Int, isAutoReplenish: Int) {
      
        let df = DateFormatter()
        df.dateFormat = "MM-dd-yyyy HH:mm"
        let transactionDateTime = df.string(from: Date())
       
        
        
        let queryStatementString = "UPDATE senderSprayBalance SET senderAmountRemaining = ?, isAutoReplish = ?, TransactionDateTime = ? WHERE eventId = ? AND senderId = ? ;"
        var queryStatement: OpaquePointer? = nil
            
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(queryStatement, 1, Int32(senderAmountRemaining))
            sqlite3_bind_int(queryStatement, 2, Int32(isAutoReplenish))
            sqlite3_bind_text(queryStatement, 3, (transactionDateTime  as NSString).utf8String, -1, nil)
            sqlite3_bind_int(queryStatement, 4, Int32(eventId))
            sqlite3_bind_int(queryStatement, 5, Int32(senderId))
            
                       if sqlite3_step(queryStatement) == SQLITE_DONE {
                           print("Successfully updated row.")
                       } else {
                           print("Could not updated  row.")
                       }
                   } else {
                       print("UPDATE statement could not be prepared")
                   }
                   sqlite3_finalize(queryStatement)
                

    //        sqlite3_finalize(queryStatement)
        }
    

        
    //
    //    func createStudentTable() {
    //           let createTableString = "CREATE TABLE IF NOT EXISTS student(studentId INTEGER PRIMARY KEY AUTOINCREMENT,firstName TEXT,lastName TEXT, grade TEXT, createDate TEXT);"
    //           var createTableStatement: OpaquePointer? = nil
    //           if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
    //           {
    //               if sqlite3_step(createTableStatement) == SQLITE_DONE
    //               {
    //                   print("Book table created.")
    //               } else {
    //                   print("book table could not be created.")
    //               }
    //           } else {
    //               print("CREATE TABLE statement could not be prepared.")
    //           }
    //           sqlite3_finalize(createTableStatement)
    //       }
    //
    //    func insert(bookTitle:String, authorName:String, bookCategory:String, isCheckedOut:Int, borrowerName:String, dueDate:String)
    //    {
    //        let books = read()
    //        for b in books
    //        {
    //            if b.bookTitle == bookTitle
    //            {
    //                return
    //            }
    //        }
    //        let insertStatementString = "INSERT INTO book (bookTitle, authorName,bookCategory, isCheckedOut, borrowerName, dueDate) VALUES (?, ?, ?, ?, ?, ?);"
    //        var insertStatement: OpaquePointer? = nil
    //        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
    //            //sqlite3_bind_int(insertStatement, 1, Int32(id))
    //            sqlite3_bind_text(insertStatement, 1, (bookTitle as NSString).utf8String, -1, nil)
    //            sqlite3_bind_text(insertStatement, 2, (authorName as NSString).utf8String, -1, nil)
    //            sqlite3_bind_text(insertStatement, 3, (bookCategory as NSString).utf8String, -1, nil)
    //             sqlite3_bind_int(insertStatement, 4, Int32(isCheckedOut))
    //            sqlite3_bind_text(insertStatement, 5, (borrowerName as NSString).utf8String, -1, nil)
    //            sqlite3_bind_text(insertStatement, 6, (dueDate as NSString).utf8String, -1, nil)
    //
    //
    //            if sqlite3_step(insertStatement) == SQLITE_DONE {
    //                print("Successfully inserted row.")
    //            } else {
    //                print("Could not insert row.")
    //            }
    //        } else {
    //            print("INSERT statement could not be prepared.")
    //        }
    //        sqlite3_finalize(insertStatement)
    //    }
    //
    
//    func updateById(borrowerName: String, dueDate: String, id: Int) {
//          let queryStatementString = "UPDATE book SET borrowerName = ?, isCheckedOut=1, dueDate= ? WHERE id = ?;"
//          var queryStatement: OpaquePointer? = nil
//
//        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
//
//            sqlite3_bind_text(queryStatement, 1, (borrowerName as NSString).utf8String, -1, nil)
//            sqlite3_bind_text(queryStatement, 2, (dueDate as NSString).utf8String, -1, nil)
//            sqlite3_bind_int(queryStatement, 3, Int32(id))
//
//                       if sqlite3_step(queryStatement) == SQLITE_DONE {
//                           print("Successfully deleted row.")
//                       } else {
//                           print("Could not delete row.")
//                       }
//                   } else {
//                       print("DELETE statement could not be prepared")
//                   }
//                   sqlite3_finalize(queryStatement)
            
            
          //var psns : [Books] = []
//          if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
//            sqlite3_bind_int(queryStatementString, 3, Int32(id))
//            let message = "Update was successful."
//
//
//            // return message
//          } else {
//
//            let message = "Something went wrong. Update was not completed"
//            //return message
//          }
//        sqlite3_finalize(queryStatement)

    
    
        
    //    func deleteByID(id:Int) {
    //        let deleteStatementStirng = "DELETE FROM person WHERE Id = ?;"
    //        var deleteStatement: OpaquePointer? = nil
    //        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
    //            sqlite3_bind_int(deleteStatement, 1, Int32(id))
    //            if sqlite3_step(deleteStatement) == SQLITE_DONE {
    //                print("Successfully deleted row.")
    //            } else {
    //                print("Could not delete row.")
    //            }
    //        } else {
    //            print("DELETE statement could not be prepared")
    //        }
    //        sqlite3_finalize(deleteStatement)
    //    }
    
    
//    func insertStudent(firstName:String, lastName:String, grade:String, createDate: String)
//        {
//            let students = readStudents()
//            for b in students
//            {
//                if b.firstName == firstName
//                {
//                    return
//                }
//            }
//            let insertStatementString = "INSERT INTO student(firstName, lastName, grade, createDate) VALUES (?, ?, ?, ?);"
//            var insertStatement: OpaquePointer? = nil
//            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
//                //sqlite3_bind_int(insertStatement, 1, Int32(id))
//                sqlite3_bind_text(insertStatement, 1, (firstName as NSString).utf8String, -1, nil)
//                sqlite3_bind_text(insertStatement, 2, (lastName as NSString).utf8String, -1, nil)
//                sqlite3_bind_text(insertStatement, 3, (grade as NSString).utf8String, -1, nil)
//                sqlite3_bind_text(insertStatement, 4, (createDate as NSString).utf8String, -1, nil)
//
//                if sqlite3_step(insertStatement) == SQLITE_DONE {
//                    print("Successfully inserted row.")
//                } else {
//                    print("Could not insert row.")
//                }
//            } else {
//                print("INSERT statement could not be prepared.")
//            }
//            sqlite3_finalize(insertStatement)
//        }
     
    
//    func readStudents() -> [Students] {
//           let queryStatementString = "SELECT * FROM student;"
//           var queryStatement: OpaquePointer? = nil
//           var psns : [Students] = []
//           if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
//               while sqlite3_step(queryStatement) == SQLITE_ROW {
//                    let studentId = sqlite3_column_int(queryStatement, 0)
//                    let firstName = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
//                    let lastName = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
//                    let grade = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
//                    let createDate = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
//                   psns.append(Students(studentId: Int(studentId), firstName: firstName, lastName: lastName, grade: grade, createDate: createDate) )
//                   print("Query Result:")
//
//               }
//           } else {
//               print("SELECT statement could not be prepared")
//           }
//           sqlite3_finalize(queryStatement)
//           return psns
//       }
//
    
  
    
//    func deleteByID(id:Int) {
//        let deleteStatementStirng = "DELETE FROM person WHERE Id = ?;"
//        var deleteStatement: OpaquePointer? = nil
//        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
//            sqlite3_bind_int(deleteStatement, 1, Int32(id))
//            if sqlite3_step(deleteStatement) == SQLITE_DONE {
//                print("Successfully deleted row.")
//            } else {
//                print("Could not delete row.")
//            }
//        } else {
//            print("DELETE statement could not be prepared")
//        }
//        sqlite3_finalize(deleteStatement)
//    }
    
}
