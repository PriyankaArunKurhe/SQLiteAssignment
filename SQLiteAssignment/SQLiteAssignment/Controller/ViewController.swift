import UIKit
import SQLite3
class ViewController: UIViewController {
    let dbManager = DBManager.shared
    @IBOutlet weak var studentCollectionView: UICollectionView!
    private var dbDetails: OpaquePointer?
    var array = [Student]()
    //MARK: Lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.studentCollectionView.dataSource = self
        self.studentCollectionView.delegate = self
        title = "First View Controller"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        dbManager.readStudentDataFromDB {[weak self] status, studentArray in
            if status {
                self?.array = studentArray
                studentCollectionView.reloadData()
            } else {
                print("Unable to read data")
            }
        }
    }
    //MARK: Button Action
    @IBAction func addStudentDataButton(_ sender: Any) {
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController")
        self.navigationController?.pushViewController(secondVC!, animated: true)
    }
}
//MARK: DataSource Methods
extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if array.count == 0   {
            let label: UILabel = UILabel()
            label.text = "Data Is not available Add data to student Table"
            label.font = .systemFont(ofSize: 16)
            label.textColor = .black
            label.textAlignment = .center
            label.numberOfLines = 1
            studentCollectionView.backgroundView = label
            return 0
        }else{
            studentCollectionView.backgroundView = nil
            return array.count
        }    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.studentCollectionView.dequeueReusableCell(withReuseIdentifier: "ReadDataLabelCollectionViewCell", for: indexPath) as? ReadDataLabelCollectionViewCell else{
            return UICollectionViewCell()
        }
        cell.idLabel.text = String(array[indexPath.row].id as Int)
        cell.nameLabel.text = array[indexPath.row].name
        cell.phoneLabel.text = array[indexPath.row].phone
        return cell
    }
}
//MARK: Delegate Methods
extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 150)
    }
    func reloadCollectionView(collectionView: UICollectionView,index:IndexPath){
        
        let contentOffset = studentCollectionView.contentOffset
        studentCollectionView.reloadData()
        studentCollectionView.layoutIfNeeded()
        studentCollectionView.setContentOffset(contentOffset, animated: false)
        studentCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
    }    
}


