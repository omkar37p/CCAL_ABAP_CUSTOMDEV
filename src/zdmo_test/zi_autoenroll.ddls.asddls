@EndUserText.label: 'AUTOENROLLMENT'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_AUTOENROLL_QUERY'
define root custom entity ZI_AUTOENROLL
{
      @UI.facet                      : [{
                                  id           :   'AutoPay',
                                  purpose      :   #STANDARD,
                                  type         :   #IDENTIFICATION_REFERENCE,
                                  label        :   'Auto Pay',
                                  position     : 10 }]
   
        @UI                  : { lineItem        : [{ position: 10, label  :'Business Partner' } ] ,
                                identification  : [{ position: 10, label  :'Business Partner' } ]  }
        @EndUserText         : { label           : 'Business Partner'       , quickInfo: 'Business Partner' }
  key BusinessPartner        : gpart_kk;

      Channel                : abap.char(10); // CSR / PORTAL / IVR / PAYMENTUS

      @UI.hidden             : true
      Entity                 : abap.char(1);  // B = BNY, P = Paymentus

      BusinessPartnerName    : abap.char(10);

      BusinessPartnerAddress : abap.char(20);

      CompanyCode            : abap.char(4);

      CustomerToken          : abap.string;

      @UI.hidden             : true
      OverallStatus          : abap.char(1);  // S / E

      @UI.hidden             : true
      OverallMessage         : abap.string;
      
      _CA : composition [0..*] of ZCV_AUTOENROLL;

}
