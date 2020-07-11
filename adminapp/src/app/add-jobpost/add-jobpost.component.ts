import { Component, OnInit } from '@angular/core';
import { FirebaseopsService } from '../firebaseops.service';
import { JobPost } from '../models/jobpost.model';
@Component({
  selector: 'app-add-jobpost',
  templateUrl: './add-jobpost.component.html',
  styleUrls: ['./add-jobpost.component.css']
})
export class AddJobpostComponent implements OnInit {
  jobPost: JobPost;
  constructor(private firebaseOps: FirebaseopsService) {
    console.log(window);
  }

  ngOnInit(): void {
    console.log(window);
    console.log(window.history.state);
    // this.firebaseOps.getJobPost('jobposts/HlMXGey9lkMcDyndtZYH').valueChanges().subscribe(val => {
    //   console.log(val);
    //   this.jobPost = val;
    // });
  }


  onFormComplete( obj){
    console.log( obj);
  }


}
