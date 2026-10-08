@EndUserText.label: 'CHILD VIEW AUTOENROLLMENT'
@ObjectModel.query.implementedBy:'ABAP:ZCL_AUTOENROLL_CA_QUERY'
define custom entity ZCV_AUTOENROLL
{
  key ContractAccount   : vkont_kk;
  key BusinessPartner   : gpart_kk;
      IsEligible        : abap.char(1);
      IsEnrolled        : abap.char(1);
      BankAccountNumber : bankn;
      BankRoutingNumber : bankl;
      BankAccountType   : abap.char(15);
      EligibilityMsg    : abap.string;
      ActionStatus      : abap.char(1); // S = Success, E = Error
      ActionMessage     : abap.string;

      _hdr              : association to parent ZI_AUTOENROLL on $projection.BusinessPartner = _hdr.BusinessPartner;
}
