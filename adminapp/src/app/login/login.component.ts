import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { FirebaseopsService } from '../firebaseops.service';

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

  constructor( private router: Router, private firebaseOps: FirebaseopsService ) { }

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

    console.log(this.password+"  "+this.username);
      this.firebaseOps.validateLogin(this.username, this.password).subscribe(result =>{
        console.log(result)
        sessionStorage.setItem("sessionstart","true");
        this.router.navigate([''])
      });
  }

}
