@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CONTRACT ACCOUNT PARTNER CHILD VIEW'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCV_CONTRACTACCOUNTPARTNER
  as select from I_ContractAccountPartner as ca

  association to parent ZRV_BUISNESSPARTNER as _Parent on $projection.BusinessPartner = _Parent.BusinessPartner
{

  key ca.BusinessPartner,
  key ca.ContractAccount,

      /* Status fields */
      cast( '' as abap.char(1) )   as IsEligible,
      cast( '' as abap.char(1) )   as HasEnrolled,

      /* Company */
      cast( '' as abap.char(4) )   as CompanyCode,
      cast( '' as abap.char(40) )  as CompanyCodeDescription,

      /* Bank details */
      cast( '' as bankn )          as BankAccountNumber,
      cast( '' as abap.char(20) )  as BankRoutingNumber,
      cast( '' as abap.char(20) )  as BankAccountType,

      /* Token */
      cast( '' as abap.char(132) ) as PaymentToken,
      cast( '' as abap.char(1) )   as ActionType,
      cast( '' as abap.char(1) )   as ProcessStatus,
      cast( '' as abap.char(255) ) as ProcessMessage,

      _Parent
}
