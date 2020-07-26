import { Component, OnInit } from '@angular/core';
import { Category } from '../models/category.model';
import { FirebaseopsService } from '../firebaseops.service';
import { MatDialog } from '@angular/material/dialog';
import { GeneralDialog } from '../dialog/general-dialog';

@Component({
  selector: 'app-categories',
  templateUrl: './categories.component.html',
  styleUrls: ['./categories.component.css']
})
export class CategoriesComponent implements OnInit {

  categories: Category[] = [];
  newCategoryName: string = '';
  isLoading : boolean = false;

  constructor(private firebaseOps: FirebaseopsService, private dialog: MatDialog) { }

  ngOnInit(): void {
    this.firebaseOps.getCategories().subscribe((cats) => {
      console.log(cats);
      this.categories = cats;
    });
  }

  loadCategories(){
    this.firebaseOps.getCategories().subscribe((cats) => {
      console.log(cats);
      this.categories = cats;
    });
  }

  submitForm() {
    console.log(this.newCategoryName);
    this.isLoading = true;
    let newCat = new Category(this.newCategoryName, this.newCategoryName);
    this.firebaseOps.addCategory(newCat).then(()=>{
      //this.loadCategories();
      this.dialog.open(GeneralDialog, {data: 'Category added!'});
      this.isLoading = false;
    })
  }

  deleteCategory(cat: Category){
    this.isLoading = true;
    this.firebaseOps.deleteCategory(cat.displayName).then(()=>{
     // this.loadCategories();
      this.dialog.open(GeneralDialog, {data: 'Category Removed!'});
      this.isLoading = false;
    })
  }

}
