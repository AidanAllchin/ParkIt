//
//  ViewSpotViewController.swift
//  GoogleToolboxForMac
//
//  Created by Guest User  on 3/14/18.
//

import UIKit

class ViewSpotViewController: UIViewController {


    @IBAction func BuySpot(_ sender: Any) {
        self.performSegue(withIdentifier: "toBuySpot", sender:nil);
    }
    @IBOutlet var ImageScrollView: UIScrollView!
    
    var imageArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageArray = [#imageLiteral(resourceName: "autos-technology-vw-multi-storey-car-park-63295"), #imageLiteral(resourceName: "car-race-ferrari-racing-car-pirelli-50704"), #imageLiteral(resourceName: "pexels-photo-170811")]
        
        for i in 0..<imageArray.count {
            let imageView = UIImageView()
            imageView.image = imageArray[i]
            let xposition = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xposition, y: 0, width: self.ImageScrollView.frame.width, height: self.ImageScrollView.frame.height)
            ImageScrollView.contentSize.width = ImageScrollView.frame.width * CGFloat(i + 1)
            ImageScrollView.addSubview(imageView)
        }
        
        
        // Do any additional setup after loading the view.
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
