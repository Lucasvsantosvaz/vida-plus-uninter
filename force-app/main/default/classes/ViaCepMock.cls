@isTest
global class ViaCepMock {

    global class Success implements HttpCalloutMock {

        global HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"logradouro":"Rua Exemplo","complemento":"Apto 101","bairro":"Centro","localidade":"São Paulo","uf":"SP"}');
            res.setStatusCode(200);
            return res;
        }
    }

    global class ExceptionThrowing implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest req) {
            throw new CalloutException('Simulated callout exception');
        }
    }

}
