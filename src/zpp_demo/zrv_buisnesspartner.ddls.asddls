@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Business Partner Root view'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZRV_BUISNESSPARTNER
  as select from I_BusinessPartner as bp
  composition [0..*] of ZCV_CONTRACTACCOUNTPARTNER as _Child
{
  key bp.BusinessPartner           as BusinessPartner,

      /* Input fields */
      cast( '' as abap.char(10) )  as AlternateBusinessPartner,
      cast( '' as abap.char(1) )   as ContractAccountIdentifier, // A / S
      cast( '' as abap.char(20) )  as APISource,
      cast( '' as abap.char(1) )   as PaymentChannel,

      /* Derived fields */
      bp.BusinessPartnerFullName   as BusinessPartnerName,

      cast( '' as abap.char(132) ) as BusinessPartnerAddress,
      cast( '' as abap.char(132) ) as CustomerToken,

      _Child

}
