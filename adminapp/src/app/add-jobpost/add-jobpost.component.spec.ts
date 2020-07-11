import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AddJobpostComponent } from './add-jobpost.component';

describe('AddJobpostComponent', () => {
  let component: AddJobpostComponent;
  let fixture: ComponentFixture<AddJobpostComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AddJobpostComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AddJobpostComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
