//
//  ViewController.swift
//  WhiteHousePetition
//
//  Created by Olibo moni on 08/02/2022.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions: [Petition] = []
   
    var objectTask : Task<Void,Never>? = nil
    
    var filteredPetitions: [Petition] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credit", style: .plain, target: self, action: #selector(creditTapped))
        tabBarItem.badgeColor = .blue
        tabBarController?.tabBar.backgroundColor = .gray
        
        //filterButton = navigationItem.leftBarButtonItem
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterTapped))
        
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        objectTask?.cancel()
       objectTask = Task{
            do{
                let petitions = try? await NetworkController().fetchPetition(urlString: urlString)
                 if let petitions = petitions{
                     self.petitions = petitions
                     tableView.reloadData()
                 } else{
                     showError()
                 }
            }


           objectTask = nil  }
        
       
    
    }
    
    @objc func creditTapped(){
        let ac = UIAlertController(title: "Credit", message: "Data pulled from \"We The People API of the Whitehouse\"", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
    @objc func filterTapped(){
        var string = ""
        let ac = UIAlertController(title: "Filter", message: nil, preferredStyle: .alert)
        ac.addTextField { UITextField in
            UITextField.backgroundColor = .green
        }
        ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [self] _ in
            if let text = ac.textFields?.first?.text {
                string = text
                print("And the text is... \(string)")
                filteredPetitions = petitions.filter({$0.title.contains(string) || $0.body.contains(string)})
                print(filteredPetitions)
            }
            self.tableView.reloadData()
            
        }))
        present(ac, animated: true)
    }
    
    
    
    
    func showError(){
        let ac = UIAlertController(title: "Loading Error", message: "There was an error loading the feed, please check you connection and try again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredPetitions.count == 0 ? petitions.count : filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition =   filteredPetitions.isEmpty ? petitions[indexPath.row] : filteredPetitions[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = petition.title
        content.secondaryText = petition.body
        cell.contentConfiguration = content
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailVC()
        vc.detailItem = filteredPetitions.isEmpty ? petitions[indexPath.row] : filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

}

