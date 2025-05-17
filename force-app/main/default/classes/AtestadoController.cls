public with sharing class AtestadoController {

    public Consulta__c consulta { get; private set; }

    public AtestadoController() {
        Id consultaId = ApexPages.currentPage().getParameters().get('id');
        consulta = ConsultaDAO.getConsultaById(consultaId);
    }

    public String getNomeMedico() {
        return (consulta != null && consulta.Medico__r != null) ? consulta.Medico__r.Name : '';
    }

    public String getNomePaciente() {
        return (consulta != null && consulta.Paciente__r != null) ? consulta.Paciente__r.Name : '';
    }

    public String getNomeHospital() {
        return (consulta != null && consulta.Hospital__c != null) ? consulta.Hospital__c : '';
    }
}