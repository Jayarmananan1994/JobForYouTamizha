import { Component, OnInit } from '@angular/core';
import { Category } from '../models/category.model';
import { FirebaseopsService } from '../firebaseops.service';

@Component({
  selector: 'app-categories',
  templateUrl: './categories.component.html',
  styleUrls: ['./categories.component.css']
})
export class CategoriesComponent implements OnInit {

  categories: Category[] = [];
  constructor(private firebaseOps: FirebaseopsService) { }

  ngOnInit(): void {
    this.firebaseOps.getCategories().subscribe((cats) => {
      console.log(cats);
      //const catToInclude = ['govt job', 'pvt job']
      this.categories = cats;
    });
  }

}
