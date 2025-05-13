public with sharing class ViaCepService {

    public static EnderecoViaCep getAddressByCEP(String cep) {
        return makeCallout(cep);
    }

    private static EnderecoViaCep makeCallout(String cep) {
        if (String.isBlank(cep)) {
            throw new IllegalArgumentException('CEP não pode ser vazio');
        }

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:ViaCep/ws/' + cep + '/json/');
        request.setMethod('GET');
        request.setTimeout(10000);

        try {
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                return (EnderecoViaCep)JSON.deserialize(response.getBody(), EnderecoViaCep.class);
            } else {
                throw new ViaCepServiceException('Erro na chamada ViaCEP. Status: ' + response.getStatus());
            }
        } catch (Exception ex) {
            throw new ViaCepServiceException('Erro ao chamar ViaCEP: ' + ex.getMessage());
        }
    }

     public class EnderecoViaCep {
        @AuraEnabled public String logradouro;
        @AuraEnabled public String complemento;
        @AuraEnabled public String bairro;
        @AuraEnabled public String localidade;
        @AuraEnabled public String uf;
    }

    public class ViaCepServiceException extends Exception {}
}