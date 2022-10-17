//
//  MainViewController.swift
//  API TEST PECODE
//
//  Created by alekseienko on 14.10.2022.
//
//9f05653438f24480ad395bef6ac8a3ae apiKey1
//4eaddc397dff4f98beb748e4f953edcc apiKey2

import UIKit
import RealmSwift

class MainViewController: UIViewController {
    // MARK: - PROPERTIES
    let newsCellId = "NewsTableViewCell"
    let apiKey = "&apiKey=9f05653438f24480ad395bef6ac8a3ae"
    let apiService = "https://newsapi.org/v2/top-headlines?"
    let apiDecoderManager = APIDecoderManager()
    let searchController = UISearchController(searchResultsController: nil)
    let realm = try! Realm()
    
    private var apiRequest = "country=ua"
    private var apiCurrentUrl = ""
    private var apiData: APIModel? = nil
    private var isSorted: Bool = false
    private var timer: Timer?
    
    // MARK: - IBOTLETS
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
   
    // MARK: - IBACTIONS
    @IBAction func sortTime(_ sender: Any) {
        filterData()
    }
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
        setupPiker()
        setupRefreshControl()
        apiCurrentUrl = apiService + apiRequest + apiKey
        loadData(url: apiCurrentUrl)
    }
    
    // MARK: - SETUP REFRESH
    func setupRefreshControl() {
        table.refreshControl = UIRefreshControl()
        table.refreshControl?.addTarget(self, action: #selector(swipeRefreshControl),for: .valueChanged)
    }
    @objc func swipeRefreshControl() {
        loadData(url: apiCurrentUrl)
        DispatchQueue.main.async {
            self.table.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - FUNCTIONS
    //LOAD DATA
    private func loadData(url: String) {
        let apiURL = url
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: false, block: { _ in
            self.apiDecoderManager.decodeData(urlString: apiURL) { (searchResponse) in
                guard let searchResponse = searchResponse else { return }
                self.apiData = searchResponse
                self.table.reloadData()
                self.navigationItem.title =  "NEWS: \(searchResponse.articles.count)"
            }
        })
    }
    //FILTER DATA
    private func filterData() {
        guard var sortData = apiData?.articles else {return}
        if isSorted {
            sortData.sort(by: {$0.publishedAt! > $1.publishedAt!})
        } else {
            sortData.sort(by: {$0.publishedAt! < $1.publishedAt!})
        }
        apiData?.articles = sortData
        isSorted.toggle()
        table.reloadData()
    }
    
}
// MARK: - EXTENTIONS SEARCHBAR
extension MainViewController: UISearchBarDelegate {
    //SEARCHBAR SETUP
    private func setupSearchBar() {
        navigationItem.searchController =  searchController
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
    }
    //LOAD DATA WITH SERCH TEXT
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        apiCurrentUrl = "https://newsapi.org/v2/everything?q=\(searchText)\(apiKey)"
        loadData(url: apiCurrentUrl)
    }
}

// MARK: - EXTENTIONS TABLEVIEW
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    //TABLEVIEW SETUP
    private func setupTableView() {
        table.delegate = self
        table.dataSource = self
        table.register(UINib.init(nibName: newsCellId, bundle: nil), forCellReuseIdentifier: newsCellId)
    }
    //TABLEVIEW ROW COUNT
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiData?.articles.count ?? 0
    }
    //TABLEVIEW ROW DATA
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: newsCellId, for: indexPath) as! NewsTableViewCell
        let article = apiData?.articles[indexPath.row]
        cell.titleName.text = article?.title ?? ""
        cell.descriptionName.text = article?.description ?? ""
        cell.autorName.text = article?.author ?? ""
        cell.sourseName.text = article?.source?.name ?? ""
        cell.imgName.downloaded(from: article?.urlToImage ?? "", contentMode: .scaleAspectFill)
        return cell
    }
    //TABLEVIEW SAVE DATA
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contexItem = UIContextualAction(style: .normal, title: "SAVE") { [self] contextualAction, view, complete in
            let article = self.apiData?.articles[indexPath.row]
            let newArticle = ArticleObject()
            newArticle.author = article?.author ?? ""
            newArticle.title = article?.title ?? ""
            newArticle.articleDescription = article?.description ?? ""
            newArticle.url = article?.url ?? ""
            newArticle.urlToImage = article?.urlToImage ?? ""
            newArticle.publishedAt = article?.publishedAt ?? ""
            newArticle.content = article?.content ?? ""
            newArticle.articleSource?.name = article?.source?.name ?? ""
            try! self.realm.write({
                realm.add(newArticle)
            })
            complete(true)
        }
        contexItem.backgroundColor = .systemBlue
        let swipeActions = UISwipeActionsConfiguration(actions: [contexItem])
        return swipeActions
    }
    //SEND DATA TO WebViewController
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController
        vc?.urlString = apiData?.articles[indexPath.row].url
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}

// MARK: - EXTENTION PICKERVIEW
extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // PICKERS COUNT
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    //PICKERS ROW COUN
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return filters.count
        } else {
            let selectedFilter = pickerView.selectedRow(inComponent: 0)
            return filters[selectedFilter].value.count
        }
    }
    //PICKER DATA
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return filters[row].type[0]
        } else {
            let selectedFilter = pickerView.selectedRow(inComponent: 0)
            return filters[selectedFilter].value[row]
        }
    }
    //PICKER FILTER
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadAllComponents()
        let selectedType = pickerView.selectedRow(inComponent: 0)
        let selectedValue = pickerView.selectedRow(inComponent: 1)
        let type = filters[selectedType].type
        let value = filters[selectedType].value[selectedValue]
        if component == 0 {
            pickerView.selectRow(0, inComponent: 1, animated: true)
        }
        apiRequest = type[1] + value
        apiCurrentUrl = apiService + apiRequest + apiKey
        loadData(url: apiService + apiRequest + apiKey)
    }
    //PICKERVIEW SETUP
    private func setupPiker() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
}

// MARK: - EXTENTIONS DOWLAND IMAGE FROM JSON API
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}


