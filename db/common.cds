using {Currency} from '@sap/cds/common';

namespace anubhav.commons;

//Domain Fixed values
type Gender       : String(1) enum {
    male = 'M';
    female = 'F';
    undisclosed = 'U';
};

//When we put amount in SAP, we always provide a reference field - currency code
//When we put quantity in SAP We always provide a UOM
//@ - Annotation
type AmountT      : Decimal(10, 2) @(
    semantics.amount.currencyCode: 'CURRENCY_code',
    sap.unit                     : 'CURRENCY_code'
);

//aspects - Structures like a append in ABAP
aspect Amount: {
    CURRENCY: Currency;
    GROSS_AMOUNT: AmountT;
    NET_AMOUNT: AmountT;
    TAX_AMOUNT: AmountT;
};

//reusable types which we can refer in all tables
//like data element in ABAP
type Guid         : String(50);
//Adding regular expression -regex : check w3 schools
//Add Phone number and email address type with validation
type phoneNumber  : String(30) @assert.format: '/^(?:\+?\d{1,3}[-.\s]?)?(\(?\d{1,4}\)?[-.\s]?)?\d{1,4}[-.\s]?\d{1,4}[-.\s]?\d{1,4}$/';
type emailAddress : String(255); 
