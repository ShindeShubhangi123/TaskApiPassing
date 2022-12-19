import UIKit
import SDWebImage


class ViewController: UIViewController {

    @IBOutlet weak var CollectionViewImg: UICollectionView!
    @IBOutlet weak var tblUserInfo: UITableView!
    var arrayUserInfo = [UserInfo]()
    var arrayProduct = [Product]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        toFetchUserData()
        toFetchProducts()
    }
    
    
    
    func registerXib()
    {
        let nibName = UINib(nibName: "TableViewCell", bundle: nil)
        tblUserInfo.register(nibName, forCellReuseIdentifier: "TableViewCell")
    }
    
    func toFetchUserData()
        {
           let urlString = "https://fakestoreapi.com/users"
            
           let url = URL(string: urlString)
            
            var request = URLRequest(url: url!)
            
            request.httpMethod = "GET"
            
            let session = URLSession(configuration: .default)
            
            let dataTask = session.dataTask(with: request) { data, response, error in
                
                let getJsonObj = try! JSONSerialization.jsonObject(with: data!) as! [[String:Any]]
                
                for dictionary in getJsonObj
                {
                    let eachAddressDictionary = dictionary as [String:Any]
                    let id = eachAddressDictionary["id"] as! Int
                    let email = eachAddressDictionary["email"] as! String
                    let userName = eachAddressDictionary["username"] as! String
                    let password = eachAddressDictionary["password"] as! String
                    let phone = eachAddressDictionary["phone"] as! String
                    let vParameter = eachAddressDictionary["__v"] as! Int
                    
                    let nameDict =  eachAddressDictionary["name"] as! [String:Any]
                    print(nameDict)
                    let firstName = nameDict["firstname"] as! String
                    let lastName = nameDict["lastname"] as! String
                    
                    self.arrayUserInfo.append(UserInfo(addressDictionary: eachAddressDictionary,
                        id: id,
                        email: email,
                        userName: userName, password: password,
                        nameDictionary: nameDict,phone: phone,
                        vParameter: vParameter,
                        firstName: firstName, lastName: lastName))
                    
                }
                DispatchQueue.main.async {
                    self.tblUserInfo.reloadData()
            }
            }
        dataTask.resume()
    }
    
        func toFetchProducts()
           {
             let urlString = "https://fakestoreapi.com/products"
             let url = URL(string: urlString)
             var request = URLRequest(url: url!)
             request.httpMethod = "GET"
             let session = URLSession(configuration: .default)
               
               let dataTask = session.dataTask(with: request) { data, response, error in
                   
                   let getJsonObject = try! JSONSerialization.jsonObject(with: data!) as! [[String:Any]]
                   
                   for dictionary in getJsonObject{
                       
                       let eachDictionary = dictionary as [String:Any]
                       
                       let productId = eachDictionary["id"] as! Int
                       let productTitle = eachDictionary["title"] as! String
                       let productPrice = eachDictionary["price"] as! Double
                       let productDecrip = eachDictionary["description"] as! String
                       let productCategory = eachDictionary["category"] as! String
                       let productImg = eachDictionary["image"] as! String
                       
                       self.arrayProduct.append(Product(id: productId,
                                       title: productTitle,
                                       price: productPrice,
                                       description: productDecrip,
                                       category: productCategory,
                                       image: productImg))
                   }
                   DispatchQueue.main.async
                   {
                       self.CollectionViewImg.reloadData()
           }
              
         }
               dataTask.resume()
               
           }

}

// MARK : CollectionViewDataSource Method
    extension ViewController : UICollectionViewDataSource
    {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
        {
            return arrayProduct.count
        }
        
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
            {
                let cell = CollectionViewImg.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
                
                let imgUrl = NSURL(string: arrayProduct[indexPath.row].image)
                cell.ProductImage.sd_setImage(with:imgUrl as URL?)
                
                return cell
            }

    }



extension ViewController:UICollectionViewDelegateFlowLayout
{
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
   {
       return CGSize(width:Int(CollectionViewImg.frame.width), height: 150)
   }
}



    //MARK: TableViewDelegate Method
    extension ViewController:UITableViewDelegate
    {
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
        {
            return 90
        }
    }


    //MARK: TableViewDataSource Method
    extension ViewController :UITableViewDataSource
    {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            return arrayUserInfo.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
            let tblCell = tblUserInfo.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
            tblCell.lblFirstName.text = arrayUserInfo[indexPath.row].firstName
            tblCell.lblLastName.text =  arrayUserInfo[indexPath.row].lastName
            return tblCell
        }
    }
