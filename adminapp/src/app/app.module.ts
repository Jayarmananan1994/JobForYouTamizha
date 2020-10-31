import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms'
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { HeaderComponent } from './header/header.component';
import { HomeComponent } from './home/home.component';
import { environment } from 'src/environments/environment';
import { AngularFireModule } from "@angular/fire";
import { JobpostEditorComponent } from './jobpost-editor/jobpost-editor.component';
import { FirebaseopsService } from './firebaseops.service';
import { RouterModule } from '@angular/router';
import { InfiniteScrollModule } from 'ngx-infinite-scroll';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatListModule } from '@angular/material/list';
import { MatButtonModule } from '@angular/material/button';
import {MatToolbarModule} from '@angular/material/toolbar';
import {MatIconModule} from '@angular/material/icon';
import { DemoComponent } from './demo/demo.component';
import { NewpostComponent } from './newpost/newpost.component';
import { ScrollableDirective } from './scrollable.directive';
import { EditJobpostComponent } from './edit-jobpost/edit-jobpost.component';
import { MatDialogModule} from '@angular/material/dialog';
import { GeneralDialog } from './dialog/general-dialog';
import { MatDatepickerModule,} from '@angular/material/datepicker';
import {MatNativeDateModule} from '@angular/material/core';
import {MatSnackBarModule} from '@angular/material/snack-bar';
import {MatProgressSpinnerModule} from '@angular/material/progress-spinner';
import { CategoriesComponent } from './categories/categories.component';
import { StudymaterialComponent } from './studymaterial/studymaterial.component';
import { ConfirmDialog } from './dialog/ConfirmDialog';
import { LoginComponent } from './login/login.component';
import { PrivacyPolicyComponent } from './privacy-policy/privacy-policy.component';

@NgModule({
  declarations: [
    AppComponent,
    HeaderComponent,
    HomeComponent,
    JobpostEditorComponent,
    DemoComponent,
    NewpostComponent,
    ScrollableDirective,
    EditJobpostComponent,
    GeneralDialog,
    ConfirmDialog,
    CategoriesComponent,
    StudymaterialComponent,
    LoginComponent,
    PrivacyPolicyComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    MatSidenavModule,
    MatListModule,
    MatButtonModule,
    MatToolbarModule,
    MatIconModule,
    MatDialogModule,
    MatDatepickerModule,
    MatNativeDateModule,
    MatSnackBarModule,
    MatProgressSpinnerModule,
    FormsModule,
    AngularFireModule.initializeApp(environment.firebaseConfig),
    RouterModule.forRoot([
      { path: '', component: HomeComponent },
      { path: 'addpost', component: NewpostComponent },
      { path: 'editpost', component: EditJobpostComponent},
      { path: 'categories', component: CategoriesComponent},
      {path: 'study-materials', component: StudymaterialComponent},
      { path: 'login', component: LoginComponent},
      { path: 'privacy', component: PrivacyPolicyComponent}
    ]),
    BrowserAnimationsModule,
    InfiniteScrollModule
  ],
  providers: [FirebaseopsService],
  bootstrap: [AppComponent]
})
export class AppModule { }
