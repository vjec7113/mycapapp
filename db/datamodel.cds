////refer a reusable module from SAP which offers many types and aspects
///contains multiple reusable types and aspects which we can refer in our entities
using {
    cuid,
    Currency
} from '@sap/cds/common';
using {anubhav.commons} from './common';

///Namespace represents unique ID of a project
///We can differentiate prijects of different companies
///eg company.project.team ----> ibm.fin.app, ibm.hr.payroll
namespace anubhav.db;

//context represents the usage of the entities - grouping
//eg context for master ,transaction etc

context master {


    //reusable types which we can refer in all tables
    //like data element in ABAP
    type guid : String(32);

    entity businesspartner {
        key NODE_KEY      : commons.Guid;
            BP_ROLE       : String(2);
            EMAIL_ADDRESS : String(105);
            PHONE_NUMBER  : String(32);
            FAX_NUMBER    : String(32);
            WEB_ADDRESS   : String(44);
            //Foreign key relationship which is loosly coupled
            ADDRESS_GUID  : Association to one address;
            BP_ID         : String(32);
            COMPANY_NAME  : String(250);
    };

    entity address {
        key NODE_KEY        : commons.Guid;
            CITY            : String(44);
            POSTAL_CODE     : String(8);
            STREET          : String(44);
            BUILDING        : String(128);
            COUNTRY         : String(44);
            ADDRESS_TYPE    : String(44);
            VAL_START_DATE  : Date;
            VAL_END_DATE    : Date;
            LATITUDE        : Decimal;
            LONGITUDE       : Decimal;
            //Backward relation - help us to read data of BP from Address
            //$self predicate to refer current table primary key column
            //not mandatory
            businessPartner : Association to one businesspartner
                                  on businessPartner.ADDRESS_GUID = $self;
    };

    entity product {
        key NODE_KEY       : commons.Guid;
            PRODUCT_ID     : String(28);
            TYPE_CODE      : String(2);
            CATEGORY       : String(32);
            DESCRIPTION    : localized String(255);
            SUPPLIER_GUID  : Association to businesspartner;
            TAX_TARIF_CODE : Integer;
            MEASURE_UNIT   : String(2);
            WEIGHT_MEASURE : Decimal(5, 2);
            WEIGHT_UNIT    : String(2);
            CURRENCY_CODE  : String(4);
            PRICE          : Decimal(15, 2);
            WIDTH          : Decimal(15, 2);
            DEPTH          : Decimal(15, 2);
            HEIGHT         : Decimal(15, 2);
            DIM_UNIT       : String(2);
    };

    entity employees : cuid {

        nameFirst     : String(40);
        nameMiddle    : String(40);
        nameLast      : String(40);
        nameInitials  : String(40);
        sex           : commons.Gender;
        language      : String(1);
        phoneNumber   : commons.phoneNumber;
        email         : commons.emailAddress;
        loginName     : String(32);
        CURRENCY      : Currency;
        salaryAmount  : commons.AmountT;
        accountNumber : String(16);
        bankId        : String(12);
        bankName      : String(64);
    }
};

context transaction {
    entity purchaseorder : commons.Amount {
        key NODE_KEY         : commons.Guid;
            PO_ID            : String(40) @title : '{i18n>POID}';
            PARTNER_GUID     : Association to one master.businesspartner;
            LIFECYCLE_STATUS : String(1);
            OVERALL_STATUS   : String(1);
            Items            : Composition of many poitems
                                   on Items.PARENT_KEY = $self;
    };

    entity poitems : commons.Amount {
        key NODE_KEY     : commons.Guid;
            PARENT_KEY   : Association to one purchaseorder;
            PO_ITEM_POS  : Integer;
            PRODUCT_GUID : Association to one master.product;
    }


}
