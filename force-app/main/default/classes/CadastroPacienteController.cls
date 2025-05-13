public with sharing class CadastroPacienteController {
   
    @AuraEnabled()
    public static ViaCepService.EnderecoViaCep getAddressByCEP(String cep){
        try {
            return ViaCepService.getAddressByCEP(cep);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}