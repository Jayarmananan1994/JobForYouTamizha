

export interface JobPost{
   id: string;
   title: string;
   content: string;
   description: string;
   //HlMXGey9lkMcDyndtZYH
   attachments: Attachment[];
   createdDate: any;
   lastDate: Date;
   imageUrl: string;
   tags: string[]
   searchTexts: string[]

}

export interface Attachment{
  id: string;
  fileName: string;
  fileUrl: string;
}
