public with sharing class MinhasConsultasService {
   
    public static List<Consulta__c> getConsultasByMedico(String userId){        
        return ConsultaDAO.getConsultaByLoggedUser(userId);
    }
}