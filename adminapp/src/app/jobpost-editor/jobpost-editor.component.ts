import { Component, OnInit, Input, Output, EventEmitter, OnDestroy } from '@angular/core';
import { JobPost, Attachment } from '../models/jobpost.model';
import { Category } from '../models/category.model';
import { AngularFirestore } from '@angular/fire/firestore/firestore';
import * as firebase from 'firebase';
import { FirebaseopsService } from '../firebaseops.service';
import { MatDialog } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
import { GeneralDialog } from '../dialog/general-dialog';
import { takeUntil, catchError } from 'rxjs/operators';
import { Observable, Subject, EMPTY } from 'rxjs';
import { ThemePalette } from '@angular/material/core';
import { ProgressSpinnerMode } from '@angular/material/progress-spinner';
import * as uuid from 'uuid';

//import { EventEmitter } from 'protractor';

@Component({
  selector: 'app-jobpost-editor',
  templateUrl: './jobpost-editor.component.html',
  styleUrls: ['./jobpost-editor.component.css']
})
export class JobpostEditorComponent implements OnInit, OnDestroy {

  destroy$: Subject<null> = new Subject();

  @Input()
  documentId: string = "";

  @Output()
  onComplete: EventEmitter<any> = new EventEmitter();

  @Input()
  jobPost: JobPost;

  title: string;
  description: string;
  jobContent: string;
  jobType: string = 'govt';
  lastDate: Date = null;
  coverImage: File = null;
  createdDate: firebase.firestore.Timestamp;

  tags: string[] = [];
  categorySelected: Category;
  categoriesSelected: Category[] = [];
  categoriesOptions: Category[];

  attachmentToUpload: File;
  attachments: Attachment[];
  attachmentsToBeAdded: File[] = [];

  isLoading = false;

  constructor(private readonly snackBar: MatSnackBar, private firebaseOps: FirebaseopsService, private dialog: MatDialog) {

  }

  ngOnInit(): void {
    console.log(" On init....")
    console.log(this.jobPost);
    this.initiateAllFields();
    this.firebaseOps.getCategories().subscribe((cats) => {
      console.log(cats);
      const catToInclude = ['Government Jobs', 'Private Jobs']
      this.categoriesOptions = cats.filter(cat => !catToInclude.includes(cat.tagName));
      this.categorySelected = this.categoriesOptions[0];
    });


  }


  onItemChange(type) {
    console.log(type + ' ' + this.jobType);
    this.jobType = type;
  }

  handleFileInput(files: FileList, type) {
    if (type === "attachment") {
      this.attachmentToUpload = files.item(0);
    } else if (type === "coverImage") {
      this.coverImage = files.item(0);
      console.log(this.coverImage);
    }

  }
  removeTag(tag) {
    console.log(tag);
    this.tags = this.tags.filter(cat => cat !== tag);
  }

  removeAttachment(attachment) {
    this.jobPost.attachments = this.jobPost.attachments.filter(att => att.fileName !== attachment.fileName);
  }

  addToTempCategory() {
    if (!this.categoriesSelected.includes(this.categorySelected)) {
      this.categoriesSelected.push(this.categorySelected);
    }
  }

  async addtoTempAttachmentList() {
    this.attachmentsToBeAdded.push(this.attachmentToUpload);
    this.attachmentToUpload = null;

  }
  removeFromSelectedTag(tag) {
    this.categoriesSelected = this.categoriesSelected.filter(cat => cat.displayName !== tag.displayName);
  }

  removeAttachmentFromTempList(fileToRemove) {

    this.attachmentsToBeAdded = this.attachmentsToBeAdded.filter(att => att.name !== fileToRemove.name);
  }

  async submitForm() {
    let attachmentsUploaded, coverImageToUpload;
    this.isLoading = true;
    if (this.coverImage == null && this.jobPost == undefined) {
      this.dialog.open(GeneralDialog, { data: "You must upload a cover image for creating post." });
      this.isLoading = false;
      return;
    }
    if (this.coverImage != null) {
      coverImageToUpload = await this.uploadFile('jobPost', this.coverImage)
    }
    if (this.attachmentsToBeAdded.length > 0) {
      attachmentsUploaded = await this.uploadAttachments();
    }
    const jobType = (this.jobType === 'govt') ? 'Government Jobs' : 'Private Jobs';
    let tags = [jobType];
    let selectedTagNames = this.categoriesSelected.map(cat => cat.displayName);
    selectedTagNames = selectedTagNames.filter(cat => (cat !== 'Government Jobs' && cat !== 'Private Jobs'));
    tags = tags.concat(selectedTagNames);
    let jobPostId = (this.jobPost == undefined || this.jobPost == null) ? null : this.jobPost.id;


    var createdDate = (this.jobPost == undefined || this.jobPost == null) ? new Date() : this.createFirebaseTimestamp(this.jobPost.createdDate);
    //var lastDate = (this.jobPost == undefined || this.jobPost == null) ? new Date() : this.createFirebaseTimestamp(this.jobPost.createdDate);
    let jobPost: JobPost = this.createJobPost(jobPostId, attachmentsUploaded, coverImageToUpload, createdDate, this.lastDate, tags);
    console.log(jobPost);
    if (jobPost.id != null) {
      this.firebaseOps.modifyJobPost(jobPost).then(() => {
        this.isLoading = false;
        this.dialog.open(GeneralDialog, { data: "Post creation/updation successful!" });
        this.onComplete.emit(jobPost);
      });
    } else {
      this.firebaseOps.addJobPost(jobPost).then((ref) => {
        this.isLoading = false;
        jobPost.id = ref.id;
        this.dialog.open(GeneralDialog, { data: "Post creation/updation successful!" });
        this.onComplete.emit(jobPost);
      });
    }

  }

  createFirebaseTimestamp(createdDate) {
    let timp = new firebase.firestore.Timestamp(createdDate.seconds, createdDate.nanoseconds);
    console.log(timp);
    return timp;
  }

  firebaseTimeStampToDate(timeStamp) {
    console.log(timeStamp)
    let timp = new firebase.firestore.Timestamp(timeStamp.seconds, timeStamp.nanoseconds);
    return timp.toDate();
  }

  initiateAllFields() {
    if (this.jobPost != null) {
      this.title = this.jobPost.title;
      this.description = this.jobPost.description;
      this.jobContent = this.jobPost.content;
      this.tags = this.jobPost.tags;
      this.lastDate = (this.jobPost.lastDate === null) ? null : this.firebaseTimeStampToDate(this.jobPost.lastDate);
      this.jobType = this.tags.includes('Government Jobs') ? 'govt' : 'pvt'
    } else {
      console.log("Field is empty")
    }
  }


  async uploadAttachments(): Promise<Attachment[]> {
    const attachments: Attachment[] = [];
    //const url = await this.uploadFile('attachments', null);
    for (const file of this.attachmentsToBeAdded) {
      const url = await this.uploadFile('attachments', file);
      console.log(url);
      const myId = uuid.v4();
      const attachemntId = myId.replaceAll('-', '');
      const att: Attachment = { id: '', fileName: file.name, fileUrl: url };
      attachments.push(att);
    }
    return attachments;
  }

  uploadFile(path, file): Promise<string> {
    const downloadUrl = this.firebaseOps.uploadFileAndGetMetadata(path, file).downloadUrl$;
    return new Promise<string>(resolve => {
      downloadUrl.pipe(takeUntil(this.destroy$), catchError((error) => {
        console.log(error);
        this.snackBar.open('Error uploading file', 'Close', {});
        resolve(null);
        return EMPTY;
      })).subscribe(downloadUrl => {
        resolve(downloadUrl);
      });
    });

  }



  createJobPost(jobId, attachments: Attachment[], newImageUrl, createdDate, lastDate, newTags): JobPost {
    attachments = (attachments == undefined) ? [] : attachments;
    const jobAttachemnet = (this.jobPost != null) ? this.jobPost.attachments.concat(attachments) : attachments;
    const notDefaultCat = (this.jobPost !== undefined && this.jobPost !== null) ? this.tags.filter(cat => (cat !== 'Government Jobs' && cat !== 'Private Jobs')) : [];
    const tags = (this.jobPost != null) ? notDefaultCat.concat(newTags) : newTags
    const imageUrl = (newImageUrl == undefined) ? this.jobPost.imageUrl : newImageUrl;
    const searchTexts = this.title.toLowerCase().split(" ");
    return {
      title: this.title,
      id: jobId,
      description: this.description,
      content: this.jobContent,
      attachments: jobAttachemnet,
      createdDate: createdDate, //new Date(),
      lastDate,
      imageUrl,
      tags,
      searchTexts
    }
  }

  ngOnDestroy() {
    this.destroy$.next(null);
  }
}
