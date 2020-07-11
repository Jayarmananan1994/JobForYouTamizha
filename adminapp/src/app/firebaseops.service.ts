import { Injectable } from '@angular/core';
import { AngularFirestore, AngularFirestoreDocument, AngularFirestoreCollection, DocumentSnapshot, DocumentReference } from '@angular/fire/firestore';
import { AngularFireStorage, AngularFireUploadTask } from '@angular/fire/storage';
import { firestore } from 'firebase';
import { Observable, from, Subscription, Subject, pipe } from 'rxjs';
import { JobPost } from './models/jobpost.model';
import { Category } from './models/category.model';
import { finalize } from 'rxjs/operators';
import { switchMap } from 'rxjs/operators';

@Injectable({
  providedIn: 'root'
})
export class FirebaseopsService {

  constructor(private firestore: AngularFirestore, private storage: AngularFireStorage) { }

  getInitialJobPosts(): AngularFirestoreCollection<JobPost> {
    return this.firestore.collection<JobPost>('jobposts', ref => ref.limit(2).orderBy('createdDate', 'desc'));
  }

  fetchNextJobposts(lastPost: JobPost): AngularFirestoreCollection<JobPost> {
    return this.firestore.collection<JobPost>('jobposts', ref => ref.limit(2).orderBy('createdDate', 'desc').startAfter(lastPost.createdDate));
  }

  getJobPost(jobId: string): AngularFirestoreDocument<JobPost> {
    return this.firestore.doc<JobPost>('jobposts/HlMXGey9lkMcDyndtZYH')
  }

  addJobPost(jobpost: JobPost): Promise<DocumentReference> {
    delete jobpost.id;
    return this.firestore.collection("jobposts").add(jobpost);
  }

  modifyJobPost(jobpost): Promise<void> {
    return this.firestore.collection("jobposts").doc(jobpost.id).set(jobpost);
  }

  uploadFileAndGetMetadata(mediaFolderPath: string,fileToUpload: File  ): FilesUploadMetadata {
    const { name } = fileToUpload;
    const filePath = `${mediaFolderPath}/${new Date().getTime()}_${name}`;
    const uploadTask: AngularFireUploadTask = this.storage.upload(
      filePath,
      fileToUpload,
    );
    return {
      uploadProgress$: uploadTask.percentageChanges(),
      downloadUrl$: this.getDownloadUrl$(uploadTask, filePath),
    };
  }

  private getDownloadUrl$(
    uploadTask: AngularFireUploadTask,
    path: string,
  ): Observable<string> {
    return from(uploadTask).pipe(
      switchMap((_) => this.storage.ref(path).getDownloadURL()),
    );
  }

  getCategories(): Observable<Category[]> {
    var subject = new Subject<Category[]>();
    this.firestore.collection('categories').valueChanges().subscribe(val => {
      var categories = val.map(i => new Category(i['display-name'], i['tag-short-hand']));
      subject.next(categories);
    });
    return subject.asObservable()
  }
}

export interface FilesUploadMetadata {
  uploadProgress$: Observable<number>;
  downloadUrl$: Observable<string>;
}