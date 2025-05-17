@isTest
public with sharing class MinhasConsultasControllerTest {

    @TestSetup
    static void makeData() {
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

        User medicoSemConsulta = new User(
            FirstName = 'Lucas',
            LastName = 'SemConsulta',
            Alias = 'lsemcon',
            Email = 'semconsulta@test.com',
            Username = 'semconsulta@test.com',
            ProfileId = medicoProfile.Id,
            TimeZoneSidKey = 'America/Sao_Paulo',
            LocaleSidKey = 'pt_BR',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'pt_BR'
        );
        insert medicoSemConsulta;

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
            Name = 'Teste',
            Numero__c = '10',
            Rua__c = 'Teste Rua',
            Telefone__c = '3432323232'
        );
        insert paci;

        Consulta__c consulta = new Consulta__c(
            Data__c = DateTime.now().addDays(2),
            DescricaoPaciente__c = 'Teste desc',
            Medico__c = med.Id,
            Paciente__c = paci.Id,
            Valor__c = 100.00
        );
        insert consulta;
    }

    @isTest
    public static void MinhasConsultasController_Success() {
        User medicoUser = [SELECT Id FROM User WHERE Username = 'lucas.med@test.com' LIMIT 1];

        System.runAs(medicoUser) {
            Test.startTest();
            List<Consulta__c> result = MinhasConsultasController.getConsultasByMedico();
            Test.stopTest();

            Assert.areNotEqual(0, result.size(), 'Deveria retornar ao menos uma consulta.');
        }
    }

    @isTest
    public static void MinhasConsultasController_NoConsultas_ShouldThrowException() {
        User medicoSemConsulta = [SELECT Id FROM User WHERE Username = 'semconsulta@test.com' LIMIT 1];
        String expectedMsg = 'Script-thrown exception';

        System.runAs(medicoSemConsulta) {
            Test.startTest();
            try {
                MinhasConsultasController.getConsultasByMedico();
                System.assert(false, 'Era esperada uma AuraHandledException, mas nenhuma foi lançada.');
            } catch (AuraHandledException ex) {
                Assert.areEqual(expectedMsg, ex.getMessage(), 'Mensagem de erro inesperada.');
            }
            Test.stopTest();
        }
    }
}