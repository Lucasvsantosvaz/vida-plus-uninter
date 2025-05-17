public with sharing class ConsultaDAO {
   
    public static List<Consulta__c> getConsultaByLoggedUser(String userId){
        return [SELECT Id, Name, Paciente__r.Name, Hospital__c, format(Data__c)
            FROM Consulta__c
            WHERE Medico__r.User__c = :userId
            AND Finalizada__c = false];
    }

    public static Consulta__c getConsultaById(String consultaId){
        return [
            SELECT Id, Data__c, Hospital__c,
                Medico__r.Name,
                Paciente__r.Name
            FROM Consulta__c 
            WHERE Id = :consultaId 
            LIMIT 1
        ];
    }
}
