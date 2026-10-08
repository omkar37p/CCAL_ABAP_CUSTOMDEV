@EndUserText.label: 'Fetch Eligibility Request'
define abstract entity ZABS_FETCH_ELIGIBILITY

{
  //     BusinessPartner          : abap.char(10);
  AlternateBusinessPartner  : abap.char(10);
  ContractAccountIdentifier : abap.char(1);
  ContractAccount           : abap.char(12);

}
