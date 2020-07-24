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
        
        OTMClient.getStudentList(numStudents: 100) { (students, error) in
            StudentModel.studentList = students
            self.studentTableView.reloadData()
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        studentTableView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension StudentListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentModel.studentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = studentTableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell")!
    
        let student = StudentModel.studentList[indexPath.row]
        cell.imageView?.image = #imageLiteral(resourceName: "icon_pin")
        cell.textLabel?.text = "\(student.firstName) \(student.lastName)"
        cell.detailTextLabel?.text = student.mediaURL
        
        return cell
    }
    
    
}
