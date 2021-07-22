//
//  StudenLocationListViewController.swift
//  OnTheMap
//
//  Created by Alhanouf Alawwad on 04/12/1442 AH.
//


import UIKit

class StudenLocationListViewController : UIViewController ,UITableViewDelegate ,UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func reloadLocations(){
        tableView?.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentModel.studentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell") as! StudentLocationCell
        let student = StudentModel.studentList[indexPath.row]
        cell.nameLabel.text = "\(student.firstName) \(student.lastName)"
        cell.URLLabel.text = student.mediaURL
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = StudentModel.studentList[indexPath.row]
        openURL(student.mediaURL)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    
}
