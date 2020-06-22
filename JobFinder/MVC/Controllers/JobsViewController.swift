//
//  JobsViewController.swift
//  JobFinder
//
//  Created by Suliman Mishael on 22/06/2020.
//  Copyright © 2020 LTM. All rights reserved.
//

import UIKit

class JobsViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var noJobLb: UILabel!
    
    private var jobs    : [JobModel] = []
    private var provider: ProviderModel? // nil for All Providers
    private var position: String?
    private var location: String?
    
    private var isFilterationPresented = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        table.register(UINib(nibName: "JobTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "JobTableViewCell")
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 44
        reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    private func fetchData() {
        ActivityIndicatorManager.shared.present()
        APIOperator.shared.getJobs(provider: provider, position: position , location: location) { [weak self] (models) in
            ActivityIndicatorManager.shared.dismiss()
            guard let strongSelf = self else {return}
            strongSelf.jobs = models
            strongSelf.reloadData()
        }
    }
    
    func reloadData() {
        noJobLb.isHidden = !(jobs.count == 0)
        table.isHidden = jobs.count == 0
        table.reloadData()
    }
    
    @IBAction func filterAction(_ sender: Any) {
        if isFilterationPresented {return}
        isFilterationPresented = true
        let filterView = FilterationView(provider: provider, position: position, location: location) { [weak self] provider, position, location in
            
            guard let `self` = self else {return}
            self.provider = provider
            self.position = position
            self.location = location
            self.fetchData()
            self.isFilterationPresented = false
        }
        
        filterView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterView)
        filterView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        filterView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        view.layoutIfNeeded()
    }
    
}

extension JobsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "JobTableViewCell", for: indexPath) as? JobTableViewCell else {
            return UITableViewCell()
        }
        cell.setup(model: jobs[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let jobUrl = URL(string: jobs[indexPath.row].detailsUrl) else {return}
        if UIApplication.shared.canOpenURL(jobUrl) {
            DispatchQueue.main.async {
                UIApplication.shared.open(jobUrl, options: [:], completionHandler: nil)
            }
        }
    }
}

