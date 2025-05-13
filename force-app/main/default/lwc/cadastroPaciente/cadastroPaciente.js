import { LightningElement, track } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// Importa o objeto
import PACIENTE_OBJECT from '@salesforce/schema/Paciente__c';

// Importa os campos
import NAME_FIELD from '@salesforce/schema/Paciente__c.Name';
import CPF_FIELD from '@salesforce/schema/Paciente__c.CPF__c';
import TELEFONE_FIXO_FIELD from '@salesforce/schema/Paciente__c.Telefone__c';
import CELULAR_FIELD from '@salesforce/schema/Paciente__c.Celular__c';
import EMAIL_FIELD from '@salesforce/schema/Paciente__c.Email__c';
import CEP_FIELD from '@salesforce/schema/Paciente__c.CEP__c';
import ESTADO_FIELD from '@salesforce/schema/Paciente__c.Estado__c';
import CIDADE_FIELD from '@salesforce/schema/Paciente__c.Cidade__c';
import BAIRRO_FIELD from '@salesforce/schema/Paciente__c.Bairro__c';
import RUA_FIELD from '@salesforce/schema/Paciente__c.Rua__c';
import NUMERO_FIELD from '@salesforce/schema/Paciente__c.Numero__c';
import COMPLEMENTO_FIELD from '@salesforce/schema/Paciente__c.Complemento__c';

// Importa o método getEndereco do Apex
import getEndereco from '@salesforce/apex/CadastroPacienteController.getAddressByCEP';

export default class CadastroPaciente extends NavigationMixin(LightningElement) {
    showSpinner = false;
    cadastrarDisable = true;

    @track name = '';
    @track cpf = '';
    @track telefoneFixo = '';
    @track telefoneCelular = '';
    @track email = '';
    @track cep = '';
    @track estado = '';
    @track cidade = '';
    @track bairro = '';
    @track rua = '';
    @track numero = '';
    @track complemento = '';

    handleInputChange(event) {
        const field = event.target.name;
        this[field] = event.target.value;
        this.validateRequiredFields();
    }

    async handlePesquisarCEP() {
        this.showSpinner = true;
        try {
            const result = await getEndereco({ cep: this.cep });

            if(result.erro){
                this.showToast('Erro', `Erro ao recuperar as informações do CEP: ${this.cep}`, 'error', 'dismissable');
            } else {
                this.estado = result.uf;
                this.cidade = result.localidade;
                this.bairro = result.bairro;
                this.rua = result.logradouro;
                this.validateRequiredFields();
            }
        } catch (error) {
            this.showToast('Erro', error, 'error', 'dismissable');
        } finally {
            this.showSpinner = false;
        }
    }

    async handleSubmit() {
        this.showSpinner = true;
        const fields = {};
        fields[NAME_FIELD.fieldApiName] = this.name;
        fields[CPF_FIELD.fieldApiName] = this.cpf;
        fields[TELEFONE_FIXO_FIELD.fieldApiName] = this.telefoneFixo;
        fields[CELULAR_FIELD.fieldApiName] = this.telefoneCelular;
        fields[EMAIL_FIELD.fieldApiName] = this.email;
        fields[CEP_FIELD.fieldApiName] = this.cep;
        fields[ESTADO_FIELD.fieldApiName] = this.estado;
        fields[CIDADE_FIELD.fieldApiName] = this.cidade;
        fields[BAIRRO_FIELD.fieldApiName] = this.bairro;
        fields[RUA_FIELD.fieldApiName] = this.rua;
        fields[NUMERO_FIELD.fieldApiName] = this.numero;
        fields[COMPLEMENTO_FIELD.fieldApiName] = this.complemento;

        const recordInput = {
            apiName: PACIENTE_OBJECT.objectApiName,
            fields
        };

        try {
            const result = await createRecord(recordInput);

            setTimeout(() => {
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: result.id,
                        objectApiName: PACIENTE_OBJECT.objectApiName,
                        actionName: 'view'
                    }
                });
            }, 1000);

             setTimeout(() => {
                this.showToast('Sucesso', 'Paciente cadastrado com sucesso!', 'success', 'dismissable');
            }, 1300);
        } catch (error) {
            this.showToast('Erro', error, 'error', 'dismissable');
        } finally{
            this.showSpinner = false;
        }
    }

    validateRequiredFields() {
            const camposObrigatoriosPreenchidos =
            this.name?.trim() &&
            this.telefoneCelular?.trim() &&
            this.estado?.trim() &&
            this.cidade?.trim() &&
            this.bairro?.trim() &&
            this.rua?.trim() &&
            this.numero?.trim();

        this.cadastrarDisable = !camposObrigatoriosPreenchidos;
    }

    showToast(title, message, variant, mode) {
        this.dispatchEvent(new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode
        }));
    }
}
