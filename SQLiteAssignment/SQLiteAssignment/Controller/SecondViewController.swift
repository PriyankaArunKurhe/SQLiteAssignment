import UIKit
import SQLite3
class SecondViewController: UIViewController {
    let dbManager = DBManager.shared
    //MARK: Outlets
    @IBOutlet weak private var idTF: UITextField!
    @IBOutlet weak private var nameTF: UITextField!
    @IBOutlet weak private var phoneTF: UITextField!
    @IBOutlet weak private var idForUpdate: UITextField!
    @IBOutlet weak private var nameForUpdate: UITextField!
    @IBOutlet weak private var idForDelete: UITextField!
    //MARK: variables
    public var tableStudent = "Student"
    private var dbDetails: OpaquePointer?
    //MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        title = "Second View Controller"
    }
    //MARK: Button Action
    @IBAction func saveStudentDataButton(_ sender: UIButton) {
        let id = idTF.text ?? ""
        let idInt = Int(id) ?? 0
        
        if(idTF.text != "" && nameTF.text != "" && phoneTF.text != ""){
            
            let student = Student(id: idInt, name: nameTF.text ?? "", phone: phoneTF.text ?? "")
            dbManager.insertDataInStudentTable(student: student)
            successAlert()
        }
        else{
            failureAlert()
        }
    }
    @IBAction func popViewToFVC(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func updateRecordButtonAction(_ sender: Any) {
        let id = idForUpdate.text ?? ""
        let idInt = Int(id) ?? 0
        let name = nameForUpdate.text ?? ""
        dbManager.updateStudentDataFromDB(id: idInt, name: name)
    }
    @IBAction func deleteRecordButtonAction(_ sender: Any) {
        let id = idForDelete.text ?? ""
        let idInt = Int(id) ?? 0
        dbManager.deleteStudentDataFromDB(id: idInt)
    }
    func successAlert() {
        let alert = UIAlertController(title: "Succeeded", message: "Data Save Successfully...", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func failureAlert() {
        let alert = UIAlertController(title: "Cancelled", message: "Fill the data", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}




