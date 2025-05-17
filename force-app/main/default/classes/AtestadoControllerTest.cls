@isTest
public class AtestadoControllerTest {

    @TestSetup
    static void setupData() {
        Profile medicoProfile = [SELECT Id FROM Profile WHERE Name = 'Médico' LIMIT 1];

        User medicoUser = new User(
            FirstName = 'Lucas',
            LastName = 'Santos',
            Alias = 'lsantos',
            Email = 'lucas.med@test.com',
            Username = 'lucas.med@test.com',
            ProfileId = medicoProfile.Id,
            TimeZoneSidKey = 'America/Sao_Paulo',
            LocaleSidKey = 'pt_BR',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'pt_BR'
        );
        insert medicoUser;

        Hospital__c hosp = new Hospital__c(
            Bairro__c = 'Teste Bairro',
            Cidade__c = 'Teste Cidade',
            Estado__c = 'MG',
            Name = 'Teste Hosp',
            Numero__c = 10,
            Rua__c = 'Teste Rua'
        );
        insert hosp;

        Medico__c med = new Medico__c(
            CRM__c = 'Teste CRM',
            Especialidade__c = 'Teste especialidade',
            Hospital__c = hosp.Id,
            Name = 'Teste Medico',
            User__c = medicoUser.Id
        );
        insert med;

        Paciente__c paci = new Paciente__c(
            Bairro__c = 'Teste bairro',
            Celular__c = '34999999999',
            CEP__c = '38400400',
            Cidade__c = 'Teste Cidade',
            CPF__c = '08108108181',
            Email__c = 'teste@teste.com',
            Estado__c = 'MG',
            Name = 'Teste Paciente',
            Numero__c = '10',
            Rua__c = 'Teste Rua',
            Telefone__c = '3432323232'
        );
        insert paci;

        Consulta__c consulta = new Consulta__c(
            Data__c = DateTime.now().addDays(2),
            Medico__c = med.Id,
            Paciente__c = paci.Id,
            Valor__c = 100.11
        );
        insert consulta;
    }

    @isTest
    static void testAtestadoController() {
        Consulta__c consulta = [SELECT Id FROM Consulta__c LIMIT 1];

        Test.setCurrentPageReference(new PageReference('/apex/Atestado'));
        ApexPages.currentPage().getParameters().put('id', consulta.Id);

        Test.startTest();
        AtestadoController controller = new AtestadoController();
        Test.stopTest();

        System.assertNotEquals(null, controller.consulta, 'Consulta deveria estar carregada');
        System.assert(controller.getNomeMedico() != '', 'Nome do médico deve estar preenchido');
        System.assert(controller.getNomePaciente() != '', 'Nome do paciente deve estar preenchido');
        System.assert(controller.getNomeHospital() != '', 'Nome do hospital deve estar preenchido');
    }
}
