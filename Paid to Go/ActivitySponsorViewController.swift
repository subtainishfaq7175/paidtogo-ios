//
//  ActivitySponsorViewController.swift
//  Paid to Go
//
//  Created by Razi Tiwana on 16/07/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit
import FSPagerView

class ActivitySponsorViewController: ViewController {

    // MARK: - Variables
    var sponsors = [Sponsor]()
    var reachedEnd = false
    var selectedIndex = 0
    
    // MARK: - Outlets
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var vistUsButton: UIButton!
    @IBOutlet weak var sopnsorNameLabel: UILabel!
    @IBOutlet weak var sopnsorDescriptionLabel: UILabel!
    @IBOutlet weak var crossButton: UIButton!
    
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.itemSize = .zero
//            self.pagerView.transformer = FSPagerViewTransformer (type: .linear)
//            let transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//            self.pagerView.itemSize = self.pagerView.frame.size.applying(transform)
            self.pagerView.isInfinite = false
        }
    }
    
    @IBOutlet weak var pageControl: FSPageControl! {
        didSet {
            self.pageControl.contentHorizontalAlignment = .right
            self.pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            self.pageControl.contentHorizontalAlignment = .center
            self.pageControl.setFillColor(#colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1), for: .selected)
            self.pageControl.setFillColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        addOnTapDismiss()
        updatePageView()
        containerView.cardView()
        view.addblurView()
        vistUsButton.cardView()
        crossButton.cardView()
        
        sopnsorNameLabel.text = sponsors[selectedIndex].title
        sopnsorDescriptionLabel.text = sponsors[selectedIndex].description
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // function which is triggered when handleTap is called
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
       
    }
    
    @IBAction func dismisAction(sender: AnyObject) {
        if reachedEnd || sponsors.count == 1 {
             dismiss(animated: true, completion: nil)
        } else {
            showAlert(text: "Swipe to the end to continue")
        }
    }
    
    @IBAction func visitUsAction(sender: AnyObject) {
      openURL()
    }
    
    
    // MARK: - Private Methods
    
    private func configureView() {
        self.containerView.cardView()
    }
    
    private func updatePageView() {
        pageControl.numberOfPages = sponsors.count
        
        if sponsors.count == 1 {
             pageControl.numberOfPages = 0 
        }
    }
    
    private func addOnTapDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
    }
    
    private func openURL() {
        let url = sponsors[selectedIndex].url
        
        let viewController = StoryboardRouter.webViewNavController(withUrl: url!)
        self.present(viewController, animated: false) {
        }
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

extension ActivitySponsorViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    
    // MARK:- FSPagerView DataSource
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return sponsors.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let sponsor = sponsors[index]
        
        cell.imageView?.yy_setImage(with: URL(string: sponsor.banner!) , placeholder: UIImage(named: "sponsorplaceholder"), options: .showNetworkActivity, completion: { (image, url, type, stage, error) in
            
            guard let img = image else {
                cell.imageView?.image = UIImage(named: "sponsorplaceholder")
                return
            }
            cell.imageView?.image = img
        })
        
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        
        return cell
    }
    
    // MARK:- FSPagerView Delegate
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        self.pageControl.currentPage = index
       
        openURL()
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard self.pageControl.currentPage != pagerView.currentIndex else {
            return
        }
        self.pageControl.currentPage = pagerView.currentIndex // Or Use KVO with property "currentIndex"
        
        selectedIndex = pagerView.currentIndex
        
        sopnsorNameLabel.text = sponsors[selectedIndex].title
        sopnsorDescriptionLabel.text = sponsors[selectedIndex].description

        if !reachedEnd {
            reachedEnd = (pagerView.currentIndex == sponsors.count - 1)
        }
    }
    
}

