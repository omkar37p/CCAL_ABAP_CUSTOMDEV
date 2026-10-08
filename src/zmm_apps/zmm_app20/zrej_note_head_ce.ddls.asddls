@EndUserText.label: 'Rejection Note Header Print'
@ObjectModel.query.implementedBy: 'ABAP:ZMM_PRINT_IMP_CLS'
define custom entity ZREJ_NOTE_HEAD_CE
  // with parameters parameter_name : parameter_type
{
  key Uuid                 : sysuuid_x16;
  key Materialdocument     : abap.char(10);
      Materialdocumentyear : abap.numc(4);
      Invoicedate          : abap.dats;
      Migodate             : abap.dats;
      Plant                : abap.char(4);
      Invoiceno            : abap.char(16);
      Purchaseorder        : abap.char(10);
      Purchaseorderitem    : abap.numc(5);
      Supplier             : abap.char(10);
      Companycode          : abap.char(4);
      Goodsmovementtype    : abap.char(3);
      Purchaseorderdate    : abap.dats;
      Supplierfullname     : abap.char(163);
      Street1              : abap.char(40);
      Street2              : abap.char(40);
      Cityname             : abap.char(35);
      Postalcode           : abap.char(10);
      Country              : abap.char(3);
      Region               : abap.char(3);
      Mdnno                : abap.char(20);
      Mdn                  : abap.char(10);
      Mdndate              : abap.dats;
      Remark               : abap.char(120);
      PersonFullName       : abap.char(80);
      PlantName            : abap.char(30);
      gstin                : abap.char(15);
      cin                   : abap.char(21);
      add1                   : abap.char(40);
      add2                   : abap.char(40);
      add3                   : abap.char(45);
      sgstin                   : abap.char(18);
      semail                   : abap.char(241);
      createdby            : abp_creation_user;
      createdat            : abp_creation_tstmpl;
      lastchangedby        : abp_lastchange_user;
      lastchangedat        : abp_lastchange_tstmpl;
      @ObjectModel.filter.enabled: false
      _Item : association [1..*] to ZMM_FORM_ITEM_CE on  $projection.Uuid             = _Item.Uuid
                                                   and $projection.Materialdocument = _Item.Materialdocument;


}
