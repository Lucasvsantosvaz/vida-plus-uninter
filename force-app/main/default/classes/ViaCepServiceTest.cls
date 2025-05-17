@isTest
private class ViaCepServiceTest {

    @isTest
    static void testGetAddressByCEP_Success() {
        Test.setMock(HttpCalloutMock.class, new ViaCepMock.Success());

        String cep = '01001000';
        ViaCepService.EnderecoViaCep endereco = ViaCepService.getAddressByCEP(cep);

        Assert.areNotEqual(null, endereco, 'O endereço não deveria ser nulo');
        Assert.areEqual('Rua Exemplo', endereco.logradouro, 'Logradouro inválido');
        Assert.areEqual('Apto 101', endereco.complemento, 'Complemento inválido');
        Assert.areEqual('Centro', endereco.bairro, 'Bairro inválido');
        Assert.areEqual('São Paulo', endereco.localidade, 'Localidade inválida');
        Assert.areEqual('SP', endereco.uf, 'UF inválida');
        Assert.areEqual(null, endereco.erro, 'Erro deveria ser nulo');
    }

    @isTest
    static void testGetAddressByCEP_BlankCEP() {
        Test.startTest();
        try {
            ViaCepService.getAddressByCEP('');
            Assert.fail('Deveria ter lançado exceção para CEP em branco');
        } catch (IllegalArgumentException ex) {
            Assert.areEqual('CEP não pode ser vazio', ex.getMessage(), 'Mensagem de exceção incorreta');
        }
        Test.stopTest();
    }

    @isTest
    static void testGetAddressByCEP_CalloutThrowsException() {
        Test.setMock(HttpCalloutMock.class, new ViaCepMock.ExceptionThrowing());

        Test.startTest();
        try {
            ViaCepService.getAddressByCEP('99999999');
            Assert.fail('Deveria ter lançado ViaCepServiceException');
        } catch (ViaCepService.ViaCepServiceException ex) {
            System.debug('Mensagem da exceção: ' + ex.getMessage());
            Assert.isTrue(
                ex.getMessage().startsWith('Erro ao chamar ViaCEP'),
                'Mensagem de erro não esperada: ' + ex.getMessage()
            );
        }
        Test.stopTest();
    }
}
