import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {

  title = 'adminapp';

  constructor(private router : Router){}

  ngOnInit(): void {
    console.log("asssa")
    const currentUrl = location.href;
    let sessionStart = sessionStorage.getItem("sessionstart");
    if((sessionStart==="false" || sessionStart==null) && !currentUrl.endsWith('/privacy')) {
      this.router.navigate(['login'])
    }
  }

  isLoggedIn(){
    let sessionStart = sessionStorage.getItem("sessionstart");
    return (sessionStart==="true");
  }

  logout(){
    sessionStorage.setItem("sessionstart", "false");
    this.router.navigate(['login']);
  }
}
