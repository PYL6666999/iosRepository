//
//  ViewController.swift
//  Project7
//
//  Created by Pyl on 2025/7/24.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()  //原始数据
    var filteredPetitions = [Petition]()  //筛选后的数据
    @objc func showCredits() {
        let ac = UIAlertController(
            title: "Data Source",
            message: "Data comes from the We The People API of the Whitehouse.",
            preferredStyle: .alert
        )
        ac.addAction(UIAlertAction(title:"OK", style: .default))
        present(ac, animated:true)
    }
    
    @objc func promptForFilter() {
        let ac = UIAlertController(title: "Filter petitions", message: "Enter a keyword", preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Search", style: .default) { [weak self, weak ac] _ in
            guard let keyword = ac?.textFields?[0].text else { return }
            self?.filterPetitions(by: keyword)
        }
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    func filterPetitions(by keyword: String)
    {
        if keyword.isEmpty {
            filteredPetitions = petitions
        } else {
            filteredPetitions = petitions.filter{
                $0.title.lowercased().contains(keyword.lowercased()) ||
                $0.body.lowercased().contains(keyword.lowercased())
            }
        }
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Credits",
            style: .plain,
            target: self,
            action: #selector(showCredits)
        )
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Filter",
            style: .plain,
            target: self,
            action: #selector(promptForFilter)
        )
        
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        }else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url){
                //we're OK to parse!
                parse(json: data)
            } else {
                showError()
            }
        }
        else {
            showError()
        }
    }
    func parse(json: Data){
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonPetitions.results
            filteredPetitions = petitions  // 初始显示全部
            tableView.reloadData()
        }
    }
    
    func showError(){
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated:true)
    }

}

