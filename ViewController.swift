//
//  ViewController.swift
//  MyPictureCarouse
//
//  Created by WillowRivers on 16/9/22.
//  Copyright © 2016年 WillowRivers. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireSwiftyJSON

class ViewController: UIViewController , UIScrollViewDelegate {
    
    var scrollView : UIScrollView! ;//所有图片显示区域
    var pageControl : UIPageControl! ; //页数显示
    var textV : UITextView! ; //show news content
    var timer = NSTimer() ;
    let head = ["appID":"6eaca7f8-e2ae-42b6-88c1-cecc87f4b21b","appKey":"16844a7b-9093-4bd2-ad85-e810da97628d"] ;
    let  url = "http://mobileapi.gree.com/wfapi/api/DataForm/3834" ;
    var allNewsContent : JSON! ;
    var someString : String = "unchanged" ;
   // let hand = {(json : JSON , error : NSError) in allNewsContent2 = json ;}
    
    override func viewDidLoad() {
        super.viewDidLoad() ;
        //getNewsContent() ;
        //loginBtnTapped() ;
        //getNews() ;
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
        
        self.textV = UITextView(frame: CGRect(x: 0 , y: 0 , width: self.view.frame.width , height: self.view.frame.height / 4)) ;
        //textV.text = "abcd" ;
        textV.backgroundColor = UIColor.blueColor() ;
        self.view.addSubview(textV) ;
        if (self.allNewsContent != nil)
        {
            self.textV.text = String(self.allNewsContent["Result"]["BusinessID"]) ;
        }
        else
        {
            //print("change textv.text") ;
           // textV.text = "allNewsContent is nil"
            
        }
        getNews() ;
        self.view.addSubview(textV) ;
        view.addSubview(scrollView) ;
        view.addSubview(pageControl) ;
        //getNewsContent(url , head: head , mHandler: self.hand) ;
        print("outside allNewsContent1 is :\(self.allNewsContent)") ;
        print("someString is \(someString)") ;
    }
    func getNewsContent(url : String , head : NSDictionary , mHandler:(json: JSON , error : NSError?) ->JSON) {
        
        let head = ["appID":"6eaca7f8-e2ae-42b6-88c1-cecc87f4b21b","appKey":"16844a7b-9093-4bd2-ad85-e810da97628d"] ;
        /*
        Alamofire.request(.GET, "http://mobileapi.gree.com/wfapi/api/DataForm/3834", parameters: nil, encoding: .JSON, headers: head).responseSwiftyJSON{ response in print("description is : \(response.debugDescription)") ;
            self.allNewsContent = response.result.value ;
            self.textV.text = String(self.allNewsContent["JsonCode"]) ;//可以正常显示
                    } ;
        print("allNewsContent is :\(self.allNewsContent)") ; //allNewsContent is nil
        */
        Alamofire.request(.GET, "http://mobileapi.gree.com/wfapi/api/DataForm/3834", parameters: nil, encoding: .JSON, headers: head).responseSwiftyJSON{ response in
            switch response.result
            {
            case .Success :
                self.allNewsContent = mHandler(json: response.result.value! , error: nil) ;
            case .Failure(let error):
                print(error) ;
            }
            
        } ;
    }
   
    // func loginBtnTapped(sender: AnyObject)
    func loginBtnTapped()
     {
     
        //MBProgressHUD.showHUDAddedTo(self.view, animated: true) ;
        self.textV = UITextView(frame: CGRect(x: 0 , y: 0 , width: self.view.frame.width , height: self.view.frame.height / 4)) ;
        textV.text = "abcd" ;
        textV.backgroundColor = UIColor.blueColor() ;
        self.view.addSubview(textV) ;
        print("texV frame is \(self.textV.frame)") ;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
     {
     
        let head = ["appID":"6eaca7f8-e2ae-42b6-88c1-cecc87f4b21b","appKey":"16844a7b-9093-4bd2-ad85-e810da97628d"] ;
        self.loginUser(head)
        {   
            responseObject, error in
            print("ooo\(responseObject) \n  \(error) ")
            // Parsing JSON Below
            let status = responseObject?.valueForKey("JsonCode") as! Int
            if status == 0
            {
               // self.allNewsContent = responseObject ; // Login Successfull...Move To New VC
                print("inside allNewsContent is\(self.allNewsContent)") ;
            }
            else 
            {
                print(responseObject?.objectForKey("JsonMessage")! as! String)
               
            }
            return
        }
        dispatch_async(dispatch_get_main_queue())
        {
            //MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.textV.backgroundColor = UIColor.blueColor();
            
            //self.allNewsContent =
        }
     }
     
     }
    
     func loginUser(parameters:NSDictionary, completionHandler: (NSDictionary?, NSError?) -> ()) 
     {
        self.postRequest("http://mobileapi.gree.com/wfapi/api/DataForm/3834",paramDict: parameters as? Dictionary<String, String>,completionHandler: completionHandler) ;
     }
     
     func postRequest(urlString: String, paramDict:Dictionary<String,String>? = nil,
     completionHandler: (NSDictionary?, NSError?) -> ()) 
     {
     
     Alamofire.request(.GET, "http://mobileapi.gree.com/wfapi/api/DataForm/3834", parameters: nil, encoding: .JSON, headers: paramDict)
     .responseJSON 
        { response in
            switch response.result
            {
            case .Success(let JSON):
            completionHandler(JSON as? NSDictionary, nil)
            case .Failure(let error):
            completionHandler(nil, error)
            }
        }
     
     }
    
    func setNewsContent(news : JSON) -> Void {
        self.allNewsContent = news
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
    func getNews()
    {
        /*
         Alamofire.request(.GET, "http://mobileapi.gree.com/wfapi/api/DataForm/3834", parameters: nil, encoding: .JSON, headers: head).responseSwiftyJSON{response in print(response.result.value) ;}
         
         */
        let temp1 = Alamofire.request(.GET, "http://mobileapi.gree.com/wfapi/api/DataForm/3834", parameters: nil, encoding: .JSON, headers: head )
            .responseJSON(completionHandler : {(json) -> Void in print("the result is \(json.result.value)") ;
                //let jsonResult = json.result.value  ;
                if json.result.value != nil
                {
                    print("8888 is :\(json.debugDescription)")
                    self.someString = json.debugDescription ;
                    self.allNewsContent = json.result.value as! JSON ;
                    self.textV.text = self.someString ;
                    // let result = json.result.value as! JSON ;
                    // self.setNewsContent(result) ;
                }
                else
                {
                    return ;
                }
                
            })
        
    }
    


}

