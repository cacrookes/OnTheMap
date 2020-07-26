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
    
    @IBAction func logoutPressed(_ sender: Any) {
        _ = OTMClient.logout(completion: { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.showAlert(message: "Unable to logout.")
            }
        })
    }
    
    // Grabs the 100 most recent student locations and adds them to the table view.
    func populateList(){
        OTMClient.getStudentList(numStudents: 100) { (students, error) in
            if error != nil {
                self.showAlert(message: "Unable to download student locations. Please try again later.")
            } else {
                StudentModel.studentList = students
            }
        }
    }
    
    /// Show an alert to the user
    ///
    /// - Parameter message: The message to display to the user in the alert.
    func showAlert(message: String){
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
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
