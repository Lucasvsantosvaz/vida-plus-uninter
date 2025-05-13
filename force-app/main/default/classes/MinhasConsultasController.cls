public with sharing class MinhasConsultasController {
  
    @AuraEnabled()
    public static List<Consulta__c> getConsultasByMedico(){
        String userId = UserInfo.getUserId();
        
        List<Consulta__c> consultasByMedico = MinhasConsultasService.getConsultasByMedico(userId);

        if(consultasByMedico.isEmpty()){
            throw new AuraHandledException('Não existe consultas');
        }
        return consultasByMedico;
    }

}
