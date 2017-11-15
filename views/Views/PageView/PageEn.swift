//
//  PageEn.swift
//  CardsKeeper
//
//  Created by Victoriia Rohozhyna on 11/9/17.
//  Copyright © 2017 Victoriia Rohozhyna. All rights reserved.
//
import UIKit

class pageenabled: UIViewController,UIScrollViewDelegate
{

    @IBAction func editting(_ sender: UIButton) {
       goToEditting()
    }
    func goToEditting(){
         performSegue(withIdentifier: "Edit", sender: self.cardArray)
    }
    var imagelist = 3
    var scrollView = UIScrollView()
    var cardArray : Card?
    var fileManager = FileManager()
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Edit"){
            let editingController = segue.destination as? AddViewController
            editingController?.cardEditting = sender as! Card?
        }
    }
    @IBOutlet weak var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView = UIScrollView(frame: CGRect(x: 0, y: 60, width: self.view.frame.width, height: UIScreen.main.bounds.height - 100))
 
        configurePageControl()

        scrollView.delegate = self

        self.view.addSubview(scrollView)
        for  i in stride(from: 0, to: imagelist, by: 1) {
            var frame = CGRect.zero
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(i)
            frame.origin.y = 0
            frame.size = self.scrollView.frame.size
            self.scrollView.isPagingEnabled = true
            
            
            let myImageView:UIImageView = UIImageView()
            myImageView.transform = myImageView.transform.rotated(by: CGFloat((Double.pi / 2) * -1))
            myImageView.image = fileManager.loadImageFromPath(date: (cardArray?.created)!, count: i+1)
            myImageView.contentMode = UIViewContentMode.scaleAspectFit
            myImageView.frame = frame
            
            scrollView.addSubview(myImageView)
        }
        
       
        

        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width * CGFloat(imagelist), height: self.scrollView.frame.size.height)
        pageControl.addTarget(self, action: Selector(("changePage:")), for: UIControlEvents.valueChanged)
        // Do any additional setup after loading the view.
    }
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        self.pageControl.numberOfPages = imagelist
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.black
        self.pageControl.currentPageIndicatorTintColor = UIColor.green
        self.view.addSubview(pageControl)
        
    }
    
    // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
    func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: x,y :0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
