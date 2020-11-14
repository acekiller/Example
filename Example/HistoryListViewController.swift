//
//  HistoryListViewController.swift
//  Example
//
//  Created by Mars Scala on 2020/11/14.
//

import UIKit

class HistoryListViewController: UIViewController {

    lazy var table = UITableView(frame: .zero, style: .plain)
    let queue = DispatchQueue(label: "com.example.readData")
    var records = [RequestHistory]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "请求记录"
        table.frame = view.bounds
        view.addSubview(table)
        table.dataSource = self
        loadHistory()
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HistoryListViewController {
    func loadHistory() {
        queue.async {
            guard let results = try? dataStore?.query(query: RequestHistory.allRecords, binding: {
                RequestHistory.keyValueRow(row: $0)
            }) else {
                return
            }
            DispatchQueue.main.async { [unowned self] in
                updateData(data: results)
            }
        }
    }

    private func updateData(data: [RequestHistory]) {
        records.removeAll()
        records.append(contentsOf: data)
        table.reloadData()
    }
}

extension HistoryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "identifier")
        if nil == cell {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "identifier")
        }
        let data = records[indexPath.row]
        cell?.textLabel?.text = data.key
        cell?.detailTextLabel?.text = data.value
        return cell!
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        records.count
    }
}
