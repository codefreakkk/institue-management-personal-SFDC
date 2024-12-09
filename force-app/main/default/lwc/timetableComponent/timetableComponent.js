import { LightningElement, track, wire } from 'lwc';
import getTimetableRecord from '@salesforce/apex/TimetableController.getTimetableRecord';
import deleteTimetableRecord from '@salesforce/apex/TimetableController.deleteTimetableRecord';
import getSubjectRecord from '@salesforce/apex/SubjectsController.getSubjectRecord';
import TIMETABLE_OBJECT from '@salesforce/schema/Timetable__c';
import SLOT_PICKLIST from '@salesforce/schema/Timetable__c.Subject_Time_Slot__c';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import createTimetableModal from 'c/createTimetableModal';

export default class TimetableComponent extends NavigationMixin(LightningElement) {
    @track timetableData = [];
    @track timetableDataCount = 0;
    @track scheduledDate;
    @track slot;
    @track subjects;
    
    actions=[
        {label: 'View', name : 'view'},
        {label: 'Edit', name : 'edit'}, 
        {label: 'Delete', name : 'delete'}
    ];

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
        {
            type: 'action',
            typeAttributes: {
                rowActions : this.actions,
                menuAlignment : 'right'
            }
        }
    ];
    slotOptions = []
    subjectOptions = [];

    connectedCallback() {
        this.fetchTimetableData();
        this.fetchSubjectData();
    }

    @wire(getObjectInfo, {objectApiName: TIMETABLE_OBJECT})
    objectInfo;

    // get picklist value for slot
    @wire(getPicklistValues, {recordTypeId: "$objectInfo.data.defaultRecordTypeId", fieldApiName: SLOT_PICKLIST})
    wiredPicklistValues({ error, data }) {
        if (data) {
            this.slotOptions = data.values.map(value => ({ label: value.label, value: value.value }));
        }
    }

    // get data for timetable
    async fetchTimetableData() {
        try {
            const result = await getTimetableRecord({
                scheduledDate: this.scheduledDate,
                slot: this.slot,
                subject: this.subjects
            });
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

    async fetchSubjectData() {
        try {
            const result = await getSubjectRecord();
            if (result) {
                this.subjectOptions = result.map(result => ({label: result.Name, value: result.Id}))
            }
        } catch (e) {
            console.log(e);
        }
    }




    // handlers
    async handleNew() {
        await createTimetableModal.open({
            size: 'small',
            description: 'Create New Timetable',
        });
    }

    handleDate(event) { 
        this.scheduledDate = event.detail.value;
        console.log("date is", this.scheduledDate);
    }

    handleSlotChange(event) {
        this.slot = event.target.value;
        console.log(this.slot)
    }

    handleSubjectChange(event) {
        this.subjects = event.target.value;
        console.log("Selected subject : ", this.subjects);
    }

    async handleSearch() {
        this.fetchTimetableData();
    }

    async handleTimetableRowAction(event) {
        try {
            const actionName = event.detail.action.name;
            const timetableId = event.detail.row.Id;
            
            if (actionName === 'view') {
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage', 
                    attributes: {
                        recordId: timetableId,
                        objectApiName: TIMETABLE_OBJECT, 
                        actionName: 'view',
                    }
                });
            }
            if (actionName === 'edit') {
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage', 
                    attributes: {
                        recordId: timetableId,
                        objectApiName: TIMETABLE_OBJECT, 
                        actionName: 'edit',
                    }
                });
            }
            if (actionName === 'delete') {
                await deleteTimetableRecord({timetableId: timetableId});
                this.fetchTimetableData();
                this.showToast('Success', 'Timetable record deleted', 'success');
            }
        } catch (e) {
            console.log(e);
            this.showToast('Error', 'Some error occured', 'error');
        }
    }   

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title,message,variant
        })
        this.dispatchEvent(event);
    }
}