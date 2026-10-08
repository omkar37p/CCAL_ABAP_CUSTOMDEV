@EndUserText.label: 'Update Customer Token Input'
define abstract entity ZABS_UPDATE_TOKEN

{
//  BusinessPartner          : abap.char(10);
  AlternateBusinessPartner : abap.char(10);

  CustomerToken            : abap.char(132);

  BankAccountNumber        : abap.char(30);
  BankRoutingNumber        : abap.char(20);
  BankAccountType          : abap.char(10);

}
