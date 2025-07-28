//definition
using { anubhav.db.master.employees } from '../db/datamodel';


service MyService {

    function vijay(input: String(80)) returns String;
    entity EmployeeSrv as projection on employees;
}   