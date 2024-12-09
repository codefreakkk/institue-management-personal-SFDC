import { LightningElement, api, wire } from 'lwc';
import getRelatedRecords from '@salesforce/apex/WrapperDemo.getRelatedRecords';
// import getRelatedOppo from '@salesforce/apex/RelatedRecordsController.getRelatedOppo';
// import getRelatedCases from '@salesforce/apex/RelatedRecordsController.getRelatedCases';
 
export default class ChildComponent extends LightningElement {
    @api recordId;
    contacts;
    opportunities;
    cases;
 
    contactColumns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Email', fieldName: 'Email' }
    ];
 
    opportunityColumns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Stage', fieldName: 'StageName' }
    ];
 
    caseColumns = [
        { label: 'Case Number', fieldName: 'CaseNumber' },
        { label: 'Status', fieldName: 'Status' }
    ];
 
    @wire(getRelatedRecords, { accountId: '$recordId' })
    wiredContacts({ error, data }) {
        if (data) {
            this.contacts = data.contacts;
            this.opportunities = data.opportunities;
            this.cases = data.cases;
        } else if (error) {
            console.error(error);
        }
    }
 
    // @wire(getRelatedRecords, { accountId: '$accountId' })
    // wiredOpportunities({ error, data }) {
    //     if (data) {
    //         this.opportunities = data;
    //     } else if (error) {
    //         console.error(error);
    //     }
    // }
 
    // @wire(getRelatedRecords, { accountId: '$accountId' })
    // wiredCases({ error, data }) {
    //     if (data) {
    //         this.cases = data;
    //     } else if (error) {
    //         console.error(error);
    //     }
    // }
}