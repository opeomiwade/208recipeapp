//
//  introView.swift
//  208recipeapp
//
//  Created by Ope Omiwade on 21/02/2022.
//

import UIKit

class introView: UIViewController {
   
    @IBOutlet weak var pagecontrol: UIPageControl!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var myButton: UIButton!
    var slide : [introview] = []
    var currentPage = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        slide = [introview(title: "Recipes at Your Disposal", description: "Multiple recipes from different parts of the world available with instructions and ingredients needed,caloric infromation provided and more incredible features.",image: UIImage(named: "Bubbles-Food")!),introview(title: "Recipes this way", description: "Click next button to proceed", image: UIImage(named: "green arrow")!)]
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonclicked(_ sender: Any) {
        if currentPage == slide.count - 1{
            performSegue(withIdentifier: "toTabBar", sender: nil)
        }
        else{
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionview.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

extension introView : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slide.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! introviewcellCollectionViewCell
        cell.setup(slide[indexPath.row])
        return cell
    }
     
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width : collectionView.frame.width, height:collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x/width)
        pagecontrol.currentPage = currentPage
    }
}
