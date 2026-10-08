@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Autopay Enrollment Interface'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_AUTOPAY_ENROLL
  as select from zap_enroll

  association [1] to I_BusinessPartner as _BusinessPartner on $projection.BpId = _BusinessPartner.BusinessPartner
{
  key zap_enroll.enroll_id        as EnrollId,
      @ObjectModel.text.association: '_BusinessPartner'
      zap_enroll.bp_id            as BpId,
      zap_enroll.contract_account as ContractAccount,
      zap_enroll.bank_account     as BankAccount,
      zap_enroll.routing_number   as RoutingNumber,
      zap_enroll.account_type     as AccountType,
      zap_enroll.status           as Status,
      zap_enroll.message          as Message,
      zap_enroll.created_at       as CreatedAt,
      _BusinessPartner
}
