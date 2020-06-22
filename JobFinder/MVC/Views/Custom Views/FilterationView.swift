//
//  FilterationView.swift
//  JobFinder
//
//  Created by Suliman Mishael on 22/06/2020.
//  Copyright © 2020 LTM. All rights reserved.
//

import UIKit

class FilterationView: UIView {

    var doneHandler:((_ provider: ProviderModel?,_ position: String?,_ location: String?)->Void)?
    
    private let filterationView : UIView?
    private var selectedProvider: ProviderModel?  // nil for All Providers
    private var selectedPosition: String?
    private var selectedLocation: String?
    
    init(provider: ProviderModel?, position: String?, location: String?, handler:((_ provider: ProviderModel?,_ position: String?,_ location: String?)->Void)?) {
        filterationView = Bundle.main.loadNibNamed("FilterationView", owner: nil, options: nil)?.first as? UIView
        super.init(frame: .zero)
        doneHandler = handler
        selectedProvider = provider
        selectedPosition = position
        selectedLocation = location
        setup()
    }
    override init(frame: CGRect) {
        filterationView = Bundle.main.loadNibNamed("FilterationView", owner: nil, options: nil)?.first as? UIView
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = UIColor(white: 0.3, alpha: 0.5)
        if let view = filterationView {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
            view.widthAnchor.constraint(equalToConstant: 300).isActive = true
            view.heightAnchor.constraint(equalToConstant: 236).isActive = true
            view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            view.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100).isActive = true
            
            (view.viewWithTag(1) as? UICollectionView)?.delegate = self
            (view.viewWithTag(1) as? UICollectionView)?.dataSource = self
            (view.viewWithTag(1) as? UICollectionView)?.register(UINib(nibName: "ProviderCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ProviderCollectionViewCell")
            (view.viewWithTag(2) as? UITextField)?.text = selectedPosition
            (view.viewWithTag(3) as? UITextField)?.text = selectedLocation
            
            view.layer.cornerRadius = 8
            view.layer.borderColor = UIColor.lightGray.cgColor
            view.layer.borderWidth = 1
            
            let doneBtn = view.viewWithTag(4) as? UIButton
            doneBtn?.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        }
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
    
    @objc private func doneAction() {
        endEditing(true)
        let position = (filterationView?.viewWithTag(2) as? UITextField)?.text
        let location = (filterationView?.viewWithTag(3) as? UITextField)?.text
        
        doneHandler?(selectedProvider,position,location)
        doneHandler = nil
        self.removeFromSuperview()
    }
}

extension FilterationView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProvidersManager.shared.providers.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProviderCollectionViewCell", for: indexPath) as? ProviderCollectionViewCell else {
            return UICollectionViewCell()
        }
        if indexPath.item == 0 {
            cell.setup(title: "All", isSelected: selectedProvider == nil)
        } else {
            let model = ProvidersManager.shared.providers[indexPath.item - 1]
            cell.setup(title: model.name, isSelected: model.id == (selectedProvider?.id ?? 0))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            selectedProvider = nil
        } else {
            let model = ProvidersManager.shared.providers[indexPath.item - 1]
            selectedProvider = model
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}

