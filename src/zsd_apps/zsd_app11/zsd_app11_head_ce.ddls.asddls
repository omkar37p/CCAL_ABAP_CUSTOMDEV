@EndUserText.label: 'Print Header Custom Entity'
@ObjectModel.query.implementedBy: 'ABAP:ZSD_APP11_PRINT_IMP'
define custom entity ZSD_APP11_HEAD_CE

{
  key BillingDocument     : vbeln;
      BillingDocumentDate : fkdat;
      BillingDocumentType : fkart;
      CompanyCode         : bukrs;
      DistributionChannel : vtweg;
      Division            : spart;
      attachment          : zsd_attach_de;
      mimetype            : abap.char(128);
      filename            : abap.char(128);
      @ObjectModel.filter.enabled  : false
      _item :association [1..*] to ZSD_APP11_ITEM_PRINT on $projection.BillingDocument = _item.BillingDocument;

}
