import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-newpost',
  templateUrl: './newpost.component.html',
  styleUrls: ['./newpost.component.css']
})
export class NewpostComponent implements OnInit {

  constructor() { }

  ngOnInit(): void {
    console.log(window);
    console.log(window.history.state);
  }

  onFormComplete( obj){
    console.log( obj);
  }

}
