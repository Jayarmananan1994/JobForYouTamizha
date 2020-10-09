import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { FirebaseopsService } from '../firebaseops.service';
import { MatDialog } from '@angular/material/dialog';
import { GeneralDialog } from '../dialog/general-dialog';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {
  form: FormGroup;
  isLoading = false;
  submitted = false;
  username: string;
  password: string;

  constructor( private router: Router, private firebaseOps: FirebaseopsService, private dialog: MatDialog ) { }

  ngOnInit(): void {
    // this.form = this.formBuilder.group({
    //   username: ['', Validators.required],
    //   password: ['', Validators.required]
    // });
  }

  get f() { return this.form.controls; }

  onSubmit() {
    this.submitted = true;
    // stop here if form is invalid
    // if (this.form.invalid) {
    //   return;
    // }


      this.firebaseOps.validateLogin(this.username, this.password).subscribe(result =>{
        console.log(result)
        if(result){
          sessionStorage.setItem("sessionstart","true");
          this.router.navigate([''])
        }else{
          this.dialog.open(GeneralDialog, {data: "Invalid credentail"})
        }
      });
  }

}
