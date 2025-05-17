import { LightningElement, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id'; // <-- ID do usuário logado
import NAME_FIELD from '@salesforce/schema/User.Name';

import getConsultasByMedico from '@salesforce/apex/MinhasConsultasController.getConsultasByMedico';

import { NavigationMixin } from 'lightning/navigation';

const COLUMNS = [{
        label: 'Consulta',
        fieldName: 'consultaLink',
        type: 'url',
        typeAttributes: { label: { fieldName: 'Name' }, target: '_blank' }
    },
    { label: 'Paciente', fieldName: 'Paciente' },
    { label: 'Hospital', fieldName: 'Hospital__c' },
    { label: 'Data', fieldName: 'Data__c', type: 'date' },
];

export default class MinhasConsultas extends NavigationMixin(LightningElement) {
    @track consultas = [];
    @track possuiConsulta = false;
    @track showSpinner = false;
    @track nomeUsuario = '';
    columns = COLUMNS;

    @wire(getRecord, { recordId: USER_ID, fields: [NAME_FIELD] })
    userRecord({ error, data }) {
        if (data) {
            this.nomeUsuario = data.fields.Name.value;
        } else if (error) {
            console.error('Erro ao recuperar nome do usuário:', error);
        }
    }

    connectedCallback() {
        this.getConsultas();
    }

    async getConsultas() {
        this.showSpinner = true;
        try {
            const result = await getConsultasByMedico();
            if (result && result.length > 0) {
                this.consultas = result.map(row => ({
                    ...row,
                    Paciente: row.Paciente__r?.Name,
                    consultaLink: '/' + row.Id
                }));
                this.possuiConsulta = true;
            }
        } catch (error) {
            console.error('Erro ao recuperar as consultas:', JSON.stringify(error));
            this.possuiConsulta = false;
        } finally {
            this.showSpinner = false;
        }
    }
}
