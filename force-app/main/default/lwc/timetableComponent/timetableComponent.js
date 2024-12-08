import { LightningElement, track } from 'lwc';
import getTimetableRecord from '@salesforce/apex/TimetableController.getTimetableRecord';

export default class TimetableComponent extends LightningElement {
    @track timetableData = [];
    @track timetableDataCount = 0;

    timetableColumns = [
        {
            label: 'Subject',
            fieldName: 'Subject_Name__c',
            type: 'text'
        },
        {
            label: 'Faculty Name',
            fieldName: 'FacultyName',
            type: 'text'
        },
        {
            label: 'Time Slot',
            fieldName: 'Subject_Time_Slot__c',
            type: 'text'
        }, 
        {
            label: 'Scheduled Date',
            fieldName: 'Scheduled_Date__c',
            type: 'text'
        },
    ];

    connectedCallback() {
        this.getTimetable();
    }

    async getTimetable() {
        try {
            const result = await getTimetableRecord();
            if (result) {
                this.timetableData = result.map(record => ({
                    ...record,
                    FacultyName: record.Faculties__r ? record.Faculties__r.Name : null
                }));
                this.timetableDataCount = result.length;
            }
        } catch (e) {
            console.log(e);
        }

    }

    handleSearchChange() {

    }

    handleSearchChange() {

    }

    handleNew() {

    }
}