import { LightningElement, wire } from 'lwc';
import USER_NAME from '@salesforce/schema/User.Name';
import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';

import imagemHome from '@salesforce/resourceUrl/ImagemHome';

export default class HomePage extends LightningElement {
    userName;
    imagemUrl = imagemHome;

    @wire(getRecord, { recordId: USER_ID, fields: [USER_NAME] })
    wiredUser({ error, data }) {
        if (data) {
            this.userName = data.fields.Name.value;
        } else if (error) {
            console.error('Erro ao buscar o nome do usuário:', error);
        }
    }
}
