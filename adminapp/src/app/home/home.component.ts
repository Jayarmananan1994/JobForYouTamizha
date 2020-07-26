import { Component, OnInit } from '@angular/core';
import { FirebaseopsService } from '../firebaseops.service';
import { JobPost } from '../models/jobpost.model';
import { Router } from '@angular/router';
import { map } from 'rxjs/operators';
import { MatDialog } from '@angular/material/dialog';
import { ConfirmDialog } from '../dialog/ConfirmDialog';
import { GeneralDialog } from '../dialog/general-dialog';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {
  documentId: string = 'HlMXGey9lkMcDyndtZYH';
  jobPost: JobPost;
  jobposts: JobPost[];
  firstJobPost: JobPost;
  lastJobPost: JobPost;
  isLoading: boolean = false;

  //cards = [1,2,3,4,5,6,7,8]

  constructor(private firebaseOps: FirebaseopsService, private router: Router, private dialog: MatDialog) {

  }

  ngOnInit(): void {

    this.firebaseOps.getInitialJobPosts().snapshotChanges().pipe(
      map(actions => {
        return actions.map(this.documentToJobPost);
      })).subscribe(val => {
        this.jobposts = val;
        this.lastJobPost = val[val.length - 1];
      })

  }

  loadInitialPost(){
    this.firebaseOps.getInitialJobPosts().snapshotChanges().pipe(
      map(actions => {
        return actions.map(this.documentToJobPost);
      })).subscribe(val => {
        this.jobposts = val;
        this.lastJobPost = val[val.length - 1];
      });
  }

  onFormComplete(obj) {
    console.log(obj);
  }

  scrollHandler() {
    console.log("Scrolled down");
    if (this.lastJobPost != null) {
      this.firebaseOps.fetchNextJobposts(this.lastJobPost).snapshotChanges().pipe(
        map(actions => {
          return actions.map(this.documentToJobPost);
        })).subscribe(val => {
          this.jobposts = this.jobposts.concat(val);
          this.lastJobPost = val[val.length - 1];

        })

    }
  }

  documentToJobPost = a => {
    const data = a.payload.doc.data() as JobPost;
    const id = a.payload.doc.id;
    return { id, ...data } as JobPost;
  }


  editJobPost(jobPost) {
    this.router.navigate(['editpost'], {
      state: { 'jobToEdit': jobPost }
    });
  }

   deleteJobPost(jobPost) {
    console.log(jobPost);
    const dialogRef = this.dialog.open(ConfirmDialog, { data: "Are you sure you want to delete the post?"});

    dialogRef.afterClosed().subscribe(result=> {
      console.log(result);
      if(result){
        this.isLoading = true;
         this.firebaseOps.deleteJobPost(jobPost).then(()=>{
            this.isLoading = false;
            this.loadInitialPost();
            this.dialog.open(GeneralDialog, {data: "Post deleted successfully"});

         })
      }
    });
  }

}
