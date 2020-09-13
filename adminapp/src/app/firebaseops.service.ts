import { Injectable } from '@angular/core';
import { AngularFirestore, AngularFirestoreDocument, AngularFirestoreCollection, DocumentSnapshot, DocumentReference } from '@angular/fire/firestore';
import { AngularFireStorage, AngularFireUploadTask } from '@angular/fire/storage';
import { firestore } from 'firebase';
import { Observable, from, Subscription, Subject, pipe } from 'rxjs';
import { JobPost, Attachment } from './models/jobpost.model';
import { Category } from './models/category.model';
import { finalize } from 'rxjs/operators';
import { switchMap } from 'rxjs/operators';
import { visitAll } from '@angular/compiler';

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

  addCategory(category: Category): Promise<void> {
    var obj = { 'display-name': category.displayName, 'tag-short-hand': category.tagName }
    var keyName = category.displayName.toLowerCase().replace(" ", "");
    return this.firestore.collection('categories').doc(keyName).set(obj);
  }

  deleteCategory(categoryName: string): Promise<void> {
    var keyName = categoryName.toLowerCase().replace(" ", "");
    return this.firestore.collection('categories').doc(keyName).delete();
  }

  getStudyMaterials(): Observable<Attachment[]> {
    return this.firestore.collection<Attachment>("studymaterial").valueChanges()
  }

  addStudyMaterial(attachment: Attachment): Promise<DocumentReference> {
    return this.firestore.collection("studymaterial").add(attachment);
  }

  modifyJobPost(jobpost): Promise<void> {
    return this.firestore.collection("jobposts").doc(jobpost.id).set(jobpost);
  }

  deleteJobPost(jobpost): Promise<void> {
    return this.firestore.collection("jobposts").doc(jobpost.id).delete();
  }

  uploadFileAndGetMetadata(mediaFolderPath: string, fileToUpload: File): FilesUploadMetadata {
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

  validateLogin(username, password){
    var subject = new Subject<boolean>();
      this.firestore.collection('adminlogin', ref =>
        ref
          .where('emailId', '==', username)
          .where('password', '==',password)
      ).valueChanges().subscribe( val => {
          console.log(val);
          subject.next(val.length>0)
      });
      return subject.asObservable()
  }
}

export interface FilesUploadMetadata {
  uploadProgress$: Observable<number>;
  downloadUrl$: Observable<string>;
}
