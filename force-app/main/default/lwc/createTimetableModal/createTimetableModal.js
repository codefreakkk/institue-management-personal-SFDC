import LightningModal from 'lightning/modal';

export default class CreateTimetableModal extends LightningModal {
    closeModal() {
        this.close('okay');
    }
}