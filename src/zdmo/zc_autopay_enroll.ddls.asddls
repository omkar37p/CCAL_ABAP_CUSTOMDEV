@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Autopay Enrollment Consumption'
@Metadata.ignorePropagatedAnnotations: true
@UI.headerInfo: {
  typeName: 'Enrollment',
  typeNamePlural: 'Enrollments',
  title: { value: 'EnrollId' }
}
define root view entity ZC_AUTOPAY_ENROLL
  provider contract transactional_query
  as projection on ZI_AUTOPAY_ENROLL
{
      @UI.lineItem: [{ position: 10, value: 'EnrollId' }]
      @UI.identification: [{ position: 10, value: 'EnrollId' }]
  key EnrollId,
      @UI.lineItem: [{ position: 10, value: 'BpId' }]
      @UI.identification: [{ position: 10, value: 'BpId' }]
      BpId,
      @UI.lineItem: [{ position: 10, value: 'ContractAccount' }]
      @UI.identification: [{ position: 10, value: 'ContractAccount' }]
      ContractAccount,
      BankAccount,
      RoutingNumber,
      AccountType,
      @UI.lineItem: [{ position: 10, value: 'Status' }]
      Status,
      Message,
      CreatedAt,
      /* Associations */
      _BusinessPartner
}
