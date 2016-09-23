//
//  ViewController.swift
//  MyPictureCarouse
//
//  Created by WillowRivers on 16/9/22.
//  Copyright © 2016年 WillowRivers. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UIScrollViewDelegate{
    
    var scrollView : UIScrollView! ;//所有图片显示区域
    var pageControl : UIPageControl! ; //页数显示
    var timer = NSTimer() ;
    override func viewDidLoad() {
        super.viewDidLoad() ;
        let pictureNameArr=["16-2.PNG","16-3.PNG","16-4.PNG","16-5.PNG"] ;
        let viewW = view.frame.width ;
        let viewH = view.frame.height ;
        
        //set scrollView
        scrollView = UIScrollView(frame: CGRectMake(0,viewH/4,viewW,viewH/2)) ;
        scrollView.contentSize = CGSizeMake(viewW * CGFloat(pictureNameArr.count) , viewH/2) ;
        scrollView.pagingEnabled = true ;
        scrollView.delegate = self ;
        
        //set pageControl
        pageControl = UIPageControl(frame: CGRectMake(viewW/CGFloat(4) , scrollView.frame.maxY + 20 , viewW / 2 , 20)) ;
        pageControl.numberOfPages = pictureNameArr.count ;
        pageControl.currentPage = 0 ;
        pageControl.currentPageIndicatorTintColor = UIColor.blueColor() ;
        pageControl.pageIndicatorTintColor = UIColor.redColor() ;
        
        //将图片添加到scrollView
        for i in 0 ... pictureNameArr.count-1
        {
            let imageView = UIImageView(frame: CGRectMake(CGFloat(i) * viewW , 0 , viewW , viewH/2)) ;
            imageView.image = UIImage(named: pictureNameArr[i]) ;
            scrollView.addSubview(imageView) ;
        }
      
        addTimer() ;
        view.addSubview(scrollView) ;
        view.addSubview(pageControl) ;

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        let page = Int(scrollView.contentOffset.x / view.frame.width + 0.5) ;
        pageControl.currentPage = page ;
        
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView)
    {
        
        timer.invalidate() ;
        print("user willBeginDrag funciton") ;
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        addTimer() ;
        print("use didendDrag function") ;
    }
    
    func nextPage()
    {
        UIView.beginAnimations(nil, context: nil) ;
        UIView.setAnimationDuration(0.5) ;
        if pageControl.currentPage < 3
        {
            scrollView.contentOffset = CGPoint (x: CGFloat((pageControl.currentPage + 1)) * scrollView.frame.width , y: 0) ;
        }
        else
        {
             pageControl.currentPage = 0 ;
             scrollView.contentOffset = CGPointMake(0 , 0) ;
        }
        
        UIView.commitAnimations() ;
        
    }
    //时间控制器
    func addTimer()
    {
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "nextPage", userInfo: nil, repeats: true) ;
    }


}

