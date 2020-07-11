import { Component, OnInit } from '@angular/core';
import { JobPost } from '../models/jobpost.model';
import { Router } from '@angular/router';

@Component({
  selector: 'app-edit-jobpost',
  templateUrl: './edit-jobpost.component.html',
  styleUrls: ['./edit-jobpost.component.css']
})
export class EditJobpostComponent implements OnInit {
  jobId: string;
  jobpost: JobPost
  constructor(private router: Router) { }

  ngOnInit(): void {
    this.jobpost = window.history.state['jobToEdit'];
    if(this.jobpost==null || this.jobpost == undefined){
      this.router.navigate(['']);
    }
    console.log(this.jobpost);
    console.log(this.jobpost == undefined);
  }

  onFormComplete( obj){
    console.log( obj);
  }
}
