@isTest
public class CadastroPacienteControllerTest {

    @isTest
    static void testGetAddressByCEP_Success() {
        Test.setMock(HttpCalloutMock.class, new ViaCepMock.Success());

        Test.startTest();
        ViaCepService.EnderecoViaCep endereco = CadastroPacienteController.getAddressByCEP('01001000');
        Test.stopTest();

        Assert.areNotEqual(null, endereco, 'O endereço não deveria ser nulo');
        Assert.areEqual('Rua Exemplo', endereco.logradouro, 'Logradouro não esperado');
    }

    @isTest
    static void testGetAddressByCEP_ThrowsAuraHandledException() {
        Test.setMock(HttpCalloutMock.class, new ViaCepMock.ExceptionThrowing());

        Test.startTest();
        try {
            CadastroPacienteController.getAddressByCEP('99999999');
            System.assert(false, 'Era esperada uma AuraHandledException');
        } catch (AuraHandledException ex) {
            System.assert(true, 'AuraHandledException capturada corretamente');
        }
        Test.stopTest();
    }
}
