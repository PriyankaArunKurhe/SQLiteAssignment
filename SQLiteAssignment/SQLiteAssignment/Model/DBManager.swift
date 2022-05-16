import Foundation
import SQLite3
class DBManager {
    static let shared = DBManager()
    private var dbDetails: OpaquePointer?
    private var tableStudent = "Student"
    private init() {
        guard let dbDetails = self.createAndOpenDB() else {
            return
        }
        self.dbDetails = dbDetails
        self.createStudentTableInDB(tableName: tableStudent)
    }
    
    private func fetchDocumentDirectoryPath() -> URL? {
        do{
            let documentDirectoryURL = try FileManager.default.url(for: .documentDirectory,
                                                                      in: .userDomainMask,
                                                                      appropriateFor: nil,
                                                                      create: false)
            return documentDirectoryURL
        }catch{
            print("Error is:\(error.localizedDescription)")
            return nil
        }
    }
    
    private func fetchDBPath() -> String? {
        guard let dbPath = fetchDocumentDirectoryPath()
        else{
            return nil
        }
        let DBPath = dbPath.appendingPathComponent("bitcode.sqlite")
        print("DB should be created at: \(DBPath.absoluteString)")
        return DBPath.absoluteString
    }
    
    private func createAndOpenDB() -> OpaquePointer? {
        let dbPath = fetchDBPath()
        var dbDetails: OpaquePointer?
        
        if(sqlite3_open(dbPath, &dbDetails)) == SQLITE_OK {
            return dbDetails
        }else{
            print("Data Base Can not open")
            return nil
        }
    }
    
    private func createStudentTableInDB(tableName: String){
        var createTableStatement: OpaquePointer?
        let createTableQuery = "CREATE TABLE \(tableName)(ID INT PRIMARY KEY, Name TEXT, PhoneNumber TEXT)"
        
        if (sqlite3_prepare(self.dbDetails,
                            createTableQuery,
                            -1,
                            &createTableStatement,
                            nil) == SQLITE_OK){
            if(sqlite3_step(createTableStatement) == SQLITE_DONE){
                print("Create Table Query excuted Successfully...")
            }else{
                print("Create Table Query not excuted...")
            }
        }else{
            print("Crate Query not Prepared...")
        }
    }
    
    func insertDataInStudentTable(student: Student) {
        var insertStatement: OpaquePointer?
        let insertQuery = "INSERT INTO \(tableStudent)(ID, Name, PhoneNumber) VALUES (?,?,?)"
        
        if sqlite3_prepare(self.dbDetails, insertQuery, -1, &insertStatement, nil) == SQLITE_OK{
            let idInt32 = Int32(student.id)
            let name = (student.name as NSString).utf8String
            let phone = (student.phone as NSString).utf8String
            
            sqlite3_bind_int(insertStatement, 1, idInt32)
            sqlite3_bind_text(insertStatement, 2, name, -1, nil)
            sqlite3_bind_text(insertStatement, 3, phone, -1, nil)
            
            if(sqlite3_step(insertStatement) == SQLITE_DONE){
                print("Data insereted successfully to table....")
            } else {
                print("Data not insereted  to table....")
            }
        } else { 
            print("Insert Query could not be prapared")
            
        }
    }
    
    func readStudentDataFromDB(completionHandler: (_ status: Bool, [Student]) -> ()) {
        var array = [Student]()
        var readStatement: OpaquePointer?
        let readQuery = "SELECT * FROM Student"
        if sqlite3_prepare_v2(self.dbDetails, readQuery, -1, &readStatement, nil) == SQLITE_OK {
            while sqlite3_step(readStatement) == SQLITE_ROW {
                let idInt = sqlite3_column_int(readStatement, 0)
                let nameUTF8 = sqlite3_column_text(readStatement, 1)!
                let phoneUTF8 = sqlite3_column_text(readStatement, 2)!
                
                let id = Int(idInt)
                let name = String(cString: nameUTF8)
                let phone = String(cString: phoneUTF8)
                
                let student = Student(id: id, name: name, phone: phone)
                array.append(student)
            }
            completionHandler(true, array)
        } else {
            print("Unable to prepare read Query for Student Table...")
            completionHandler(false, array)
        }
    }
    
    
    func deleteStudentDataFromDB(id: Int)
    {
        var deleteStatement: OpaquePointer?
        let deleteQuery = "DELETE FROM \(tableStudent) WHERE ID = ?"
        
        if sqlite3_prepare_v2(self.dbDetails,
                              deleteQuery,
                              -1,
                              &deleteStatement,
                              nil) == SQLITE_OK {
            let idInt32 = Int32(id)
            sqlite3_bind_int(deleteStatement, 1, idInt32)
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Data Deleted")
            } else {
                print("Student delete from table failed")
            }
            
        } else {
            print("Student data delete query could not be prepared")
        }
    }
    func updateStudentDataFromDB(id: Int, name: String)
    {
        var updateStatement: OpaquePointer?
        let updateQuery = "UPDATE \(tableStudent) SET NAME = ? WHERE ID = ?;"
        
        if sqlite3_prepare_v2(self.dbDetails,
                              updateQuery,
                              -1,
                              &updateStatement,
                              nil) == SQLITE_OK {
            
            let changeName = (name as NSString).utf8String
            let idInt32 = Int32(id)
            
            
            sqlite3_bind_text(updateStatement, 1, changeName, -1, nil)
            sqlite3_bind_int(updateStatement, 2, idInt32)
            
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Data Updated")
            } else {
                print("Student update failed")
            }
            
        } else {
            print("Student data update query could not be prepared")
        }
    }
    
    
}

