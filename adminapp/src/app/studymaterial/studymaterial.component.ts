import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { GeneralDialog } from '../dialog/general-dialog';
import { FirebaseopsService } from '../firebaseops.service';
import { MatSnackBar } from '@angular/material/snack-bar';
import { takeUntil, catchError } from 'rxjs/operators';
import { Subject, EMPTY, Observable } from 'rxjs';
import { Attachment } from '../models/jobpost.model';

@Component({
  selector: 'app-studymaterial',
  templateUrl: './studymaterial.component.html',
  styleUrls: ['./studymaterial.component.css']
})
export class StudymaterialComponent implements OnInit {
  fileSelected: File;
  destroy$: Subject<null> = new Subject();
  isLoading = false;
  studyMaterialList: Observable<Attachment[]> = null;

  constructor(private readonly snackBar: MatSnackBar, private dialog: MatDialog, private firebaseOps: FirebaseopsService) {

  }

  ngOnInit(): void {
      this.studyMaterialList = this.firebaseOps.getStudyMaterials();
  }

  handleFileInput(files: FileList) {
    this.fileSelected = files.item(0);
  }
  async uploadDocument() {
    this.isLoading = true;
    var url = await this.uploadFile('study-material', this.fileSelected);
    let ref = await this.firebaseOps.addStudyMaterial({fileName: this.fileSelected.name, fileUrl: url});
    console.log(url);
    console.log(ref);
    this.fileSelected = null;
    this.isLoading = false;
    this.dialog.open(GeneralDialog, { data: "Post creation/updation successful!" });
  }

  uploadFile(path, file): Promise<string> {
    const downloadUrl = this.firebaseOps.uploadFileAndGetMetadata(path, file).downloadUrl$;
    return new Promise<string>(resolve => {
      downloadUrl.pipe(takeUntil(this.destroy$), catchError((error) => {
        this.snackBar.open('Error uploading file', 'Close', {});
        resolve(null);
        return EMPTY;
      })).subscribe(downloadUrl => {
        resolve(downloadUrl);
      });
    });

  }
}
