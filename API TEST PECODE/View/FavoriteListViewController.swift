//
//  FavoriteListViewController.swift
//  API TEST PECODE
//
//  Created by alekseienko on 15.10.2022.
//

import UIKit
import RealmSwift

class FavoriteListViewController: UIViewController {
    
    // MARK: - PROPERTIES
    let newsCellId = "NewsTableViewCell"
    //DATA BASE
    let realm = try! Realm()
    var news: Results<ArticleObject>!
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        news = realm.objects(ArticleObject.self)
    }
}

    // MARK: - EXTENTIONS TABLEVIEW
    extension FavoriteListViewController: UITableViewDelegate, UITableViewDataSource {
        //SETUP TABLEVIEW
        private func setupTableView() {
            table.delegate = self
            table.dataSource = self
            table.register(UINib.init(nibName: newsCellId, bundle: nil), forCellReuseIdentifier: newsCellId)
            navigationItem.title = "My favorite news".uppercased()
        }
        
        //COUNT ROW
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return news.count
        }
        
        //SETUP ROW
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = table.dequeueReusableCell(withIdentifier: newsCellId, for: indexPath) as! NewsTableViewCell
            let myNews = news[indexPath.row]
            cell.titleName.text = myNews.title
            cell.descriptionName.text = myNews.articleDescription
            cell.autorName.text = myNews.author
            cell.sourseName.text = myNews.articleSource?.name
            cell.imgName.downloaded(from: myNews.urlToImage , contentMode: .scaleAspectFill)
            return cell
        }
        
        //SEND DATA TO WebViewController
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let vc = storyboard?.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController
            vc?.urlString = news[indexPath.row].url
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
        //DELETE ROW
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                if let item = news?[indexPath.row] {
                    try! realm.write {
                        realm.delete(item)
                    }
                    tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                }
            }
        }
    }

