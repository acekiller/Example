//
//  ViewController.swift
//  Example
//
//  Created by Mars Scala on 2020/11/12.
//

import UIKit

class ViewController: UIViewController {
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        return textView
    }()

    private var subscriberUniqueID: String!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        subscriberUniqueID = subscribeEndPointData { [unowned self] in
            appendData($0)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        subscriberUniqueID = subscribeEndPointData { [unowned self] in
            appendData($0)
        }
    }

    deinit {
        removeSubscriber(uniqueID: subscriberUniqueID)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "History",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(historyAction(_:)))

        textView.frame = view.bounds
        view.addSubview(textView)
        loadLastData()
    }

    @objc func historyAction(_ sender: Any) {
        let historyViewControlelr = HistoryListViewController()
        navigationController?.pushViewController(historyViewControlelr, animated: true)
    }

    func loadLastData() {
        let data = try? dataStore?.justOne(query: KeyValue.latest, binding: { KeyValue.keyValueRow(row: $0) })
        guard let value = data?.value else {
            return
        }
        appendData(value)
    }

    func appendData(_ value: Data) {
        let text = self.jsonDataToString(data: value)
        DispatchQueue.main.async { [unowned self] in
            self.appendText(text)
        }
    }

    func appendText(_ text: String) {
        textView.text = textView.text.count > 0 ? textView.text.appending(text) : text
    }

    func jsonDataToString(data: Data) -> String {
        let jsonDic = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: String]
        var result = String()
        jsonDic?.forEach({ (key, value) in
            result.append("\(key):\(value)\n\n")
        })
        return result
    }

}
