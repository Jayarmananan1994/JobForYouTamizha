import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { JobpostEditorComponent } from './jobpost-editor.component';

describe('JobpostEditorComponent', () => {
  let component: JobpostEditorComponent;
  let fixture: ComponentFixture<JobpostEditorComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ JobpostEditorComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(JobpostEditorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
