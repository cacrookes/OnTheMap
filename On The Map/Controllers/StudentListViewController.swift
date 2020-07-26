//
//  StudentListViewController.swift
//  On The Map
//
//  Created by Christopher Crookes on 2020-07-23.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import UIKit

class StudentListViewController: UIViewController {

    @IBOutlet weak var studentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        studentTableView.delegate = self
        studentTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        populateList()
        studentTableView.reloadData()
    }
    
    @IBAction func refreshClicked(_ sender: Any) {
        populateList()
        studentTableView.reloadData()
    }
    
    // Grabs the 100 most recent student locations and adds them to the table view.
    func populateList(){
        OTMClient.getStudentList(numStudents: 100) { (students, error) in
            StudentModel.studentList = students
        }
    }

}

extension StudentListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentModel.studentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = studentTableView.dequeueReusableCell(withIdentifier: K.identifiers.studentTableViewCell)!
    
        let student = StudentModel.studentList[indexPath.row]
        cell.imageView?.image = #imageLiteral(resourceName: "icon_pin")
        cell.textLabel?.text = "\(student.firstName) \(student.lastName)"
        cell.detailTextLabel?.text = student.mediaURL
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let mediaURL = URL(string: StudentModel.studentList[indexPath.row].mediaURL) {
            UIApplication.shared.open(mediaURL, options: [:], completionHandler: nil)
        }
    }
}
