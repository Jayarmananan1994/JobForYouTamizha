import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { GeneralDialog } from '../dialog/general-dialog';
import { FirebaseopsService } from '../firebaseops.service';
import { MatSnackBar } from '@angular/material/snack-bar';
import { takeUntil, catchError } from 'rxjs/operators';
import { Subject, EMPTY, Observable } from 'rxjs';
import { Attachment } from '../models/jobpost.model';
import * as uuid from 'uuid';
import { ConfirmDialog } from '../dialog/ConfirmDialog';

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
    const myId = uuid.v4();
    const attachemntId = myId.replaceAll('-','');
    let ref = await this.firebaseOps.addStudyMaterial({id: attachemntId,fileName: this.fileSelected.name, fileUrl: url});
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

  deleteAttachement(item){
    console.log(item);
    const myId = uuid.v4();
    console.log(myId);
    const dialogRef = this.dialog.open(ConfirmDialog, {data: "Are you sure you want to delte the file ?"});
    dialogRef.afterClosed().subscribe(result=>{
        if(result){
          this.firebaseOps.deleteStudyMaterial(item).then(()=>{
            //console.log("Deleted");
            this.dialog.open(GeneralDialog, { data: "File deleted successfully"});
          });
        }
    })

  }

  openAttachment(item) {
    window.open(item.fileUrl, "_blank");
  }
}
