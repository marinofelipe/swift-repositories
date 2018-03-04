//
//  RepositoriesViewController.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/1/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit

class RepositoriesViewController: BaseViewController {

    var repositories: [Repository]?
    var repositoriesViewModel = RepositoriesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionView.collectionViewLayout as? CustomGridFlowLayout {
            layout.delegate = self
        }
        
        //repos mock
        repositories = []
        for index in 0...22 {
            var repository = Repository()
            repository.name = "Nome \(index)"
            repository.description = "Descricao maior asd asd asd asd asd asda sda dasd as asd asd asd asd asdas dasd asd asd asdas dasd asd asd asd asda sdasd asd ashudh uahsdh uasduahsudhu asdahsudh ausdhu hasudhu ashdu ahsudh uashdu hasudhu ahsdu ahsudh uadahsdu hausuashdu husdhu aduahsud hasudhausdhu aduasdadasdhausduashd as"
            repository.forksCount = "10"
            repository.starsCount = "3"
            repository.owner?.name = "alamo"
            repository.owner?.imageUrl = ""
            
            repositories?.append(repository)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}

// MARK: UICollectionViewDelegate
extension RepositoriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        //TODO: add row animation
    }
}

// MARK: UICollectionViewDataSource
extension RepositoriesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return repositories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifier.Cell.repository, for: indexPath) as? RepositoryCollectionViewCell {
            
            var repository = repositories![indexPath.item]
            
            cell.imageView.image = #imageLiteral(resourceName: "star")
            cell.nameLabel.text = repository.name
            cell.descriptionLabel.text = repository.description
            cell.forksCountLabel.text = repository.forksCount
            cell.starsCountLabel.text = repository.starsCount
            cell.ownerNameLabel.text = repository.owner?.name

//            cell.backgroundColor = UIColor.blue
            
            return cell
        }
        
        assertionFailure("")
        return UICollectionViewCell()
    }
}

extension RepositoriesViewController: GridHeightLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForCellAt indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        
        var string = repositories![indexPath.item].description
        
        let attributedString = NSAttributedString(string: string ?? "", attributes: [.font : UIFont(name: "Avenir-LightOblique", size: 12)!])
        let boundingRect = attributedString.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        
        var height = boundingRect.height
        height += 10 + 10 + 30 + 15 + 20 //margins and other fixed cell heights
        return height
    }
}
